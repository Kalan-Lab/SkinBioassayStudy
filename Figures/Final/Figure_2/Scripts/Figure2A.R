# Load packages
library(tidyverse)
library(readxl)
library(readr)
library(ggplot2)
library(dplyr)
library(janitor)
library(ggpubr)
library(here)

# Load data
culture <- read_excel(here::here("Data", "251010_SupTable2_Updated.xlsx"))

# Assign body and site types
culture <- culture %>%
  #filter(row_number() !=1) %>%
  #row_to_names(row_number = 1) %>%
  mutate(body_site = case_when(
    `Body site` == "Antecubital fossa" ~ "Af", 
    `Body site` == "Alar crease" ~ "Al", 
    `Body site` == "Occiput" ~ "Oc", 
    `Body site` == "Nares" ~ "Na", 
    `Body site` == "Toe web space" ~ "Tw", 
    `Body site` == "Volar forearm" ~ "Vf",
    `Body site` == "Back" ~ "Ba",
    `Body site` == "Umbilicus" ~ "Um",
    TRUE ~ "NA"
  )) %>%
  relocate(body_site, .after =`Body site`) %>%
  mutate(site_type = case_when(
    `Body site` == "Antecubital fossa" ~ "Rarely Moist", 
    `Body site` == "Alar crease" ~ "Sebaceous", 
    `Body site` == "Occiput" ~ "Sebaceous", 
    `Body site` == "Nares" ~ "Moist", 
    `Body site` == "Toe web space" ~ "Moist", 
    `Body site` == "Volar forearm" ~ "Rarely Moist",
    `Body site` == "Back" ~ "Sebaceous",
    `Body site` == "Umbilicus" ~ "Moist",
    TRUE ~ "NA"
  )) %>%
  relocate(site_type, .after =body_site) 

# Summarize culture data
culture_final <- culture %>%
  filter(!is.na(Genus) & Genus != "Penicillium") %>%
  group_by(Genus, body_site, site_type) %>%
  dplyr::summarise(
    count = n(),
    .groups = "drop"
  ) %>%
  group_by(body_site) %>%
  mutate(
    total_body_site_count = sum(count),
    rel_abun = (count / total_body_site_count)
  ) %>%
  ungroup() %>%
  mutate(dataset =  "Culture") %>% 
  relocate(dataset, .before =1) %>%
  mutate(Genus = case_when(
    is.na(Genus) | Genus == "" ~ "Other",
    TRUE ~ Genus
  )) %>%
  dplyr::rename("genus" = "Genus") %>%
  select(dataset, genus, body_site, site_type, count, total_body_site_count, rel_abun)

# Set colors
colors <- c("#b1728f","#c89cb0","#dfc6d2","#efe2e8",
            "#E69138","#edb273","#f5d3af","#fae9d7",
            "#bc3e47","#d0777e","#e4b1b5","#f1d8da",
            "#CBA92B","#dac26a","#eadcaa","#f4edd4",
            "#CD8987", "#CDACA1", "#DCC4BC", "#EADCD7",
            "#2C2C34", "#545463", "#7B7B8E",
            "#493C61",
            "#38761d","#739f60","#afc8a4","#d7e3d1",
            "#3B7D6A", "#59B198","#82C4B2", "#ACD8CC",
            "#3E5641",
            "#073763","#517391","#9bafc0","#cdd7df","#E6EBEF", 
            "#4861AD")


genus <- c(
  # Actinomycetota
  "Cutibacterium","Corynebacterium", "Citricoccus", "Micrococcus",
  "Kocuria","Rothia", "Brevibacterium","Gordonia",
  "Dermabacter","Kytococcus", "Janibacter","Dietzia",
  "Microbacterium","Brachybacterium","Dermacoccus","Nesterenkonia",
  "Pseudoclavibacter","Helcococcus", "Cellulosimicrobium", "Micromonospora", 
  "Rhodococcus", "Aestuariimicrobium", "Pseudoglutamicibacter",
  #Bacteroidota
  "Sphingobacterium",
  #Bacillota
  "Staphylococcus","Bacillus","Granulicatella","Lysinibacillus", 
  "Paenibacillus", "Enterococcus", "Niallia", "Oceanobacillus",
  "Peribacillus",
  #Pseudomonadota
  "Klebsiella","Citrobacter","Enterobacter", "Raoultella", "Escherichia", 
  "Morganella"
  )

# Create a named vector mapping genera to colors
genus_colors <- setNames(colors, genus)

# Calculate percentage and angles
culture_final1 <- culture_final %>%
  group_by(body_site) %>%
  arrange(body_site, desc(count)) %>%
  mutate(
    percentage = (count / sum(count)) * 100
  ) %>%
  ungroup()

# Set factor
culture_final1$genus <- factor(culture_final1$genus, levels = genus)

# Create faceted pie charts
ggplot(culture_final1, aes(x = "", y = count, fill = genus)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  facet_wrap(~ body_site, ncol = 3, scales = "free") +
  scale_fill_manual(values = genus_colors) +
  theme_void() +
  theme(
    strip.text = element_text(size = 11, face = "bold"),
    legend.position = "right",
    legend.title = element_blank(),
    legend.text = element_text(size = 9)
  ) +
  guides(fill = guide_legend(ncol = 2))
