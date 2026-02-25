library(tidyverse)
library(readxl)
library(readr)
library(ggplot2)
library(dplyr)
library(janitor)
library(ggpubr)
library(ggrepel)
library(RColorBrewer)
library(ggbreak)

# Culture dataset ----
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
  filter(Genus != "Penicillium") %>%
  group_by(Genus, body_site, site_type) %>%
  dplyr::summarise(
    count = n(),
    .groups = "drop"
  ) %>%
  group_by(body_site) %>%
  mutate(
    total_body_site_count = sum(count),
    rel_abun = (count / total_body_site_count) * 100
  ) %>%
  ungroup() %>%
  mutate(dataset =  "Culture") %>% 
  relocate(dataset, .before =1) %>%
  mutate(Genus = case_when(
    is.na(Genus) | Genus == "" ~ "Other",
    TRUE ~ Genus
  )) %>%
  dplyr::rename("genus" = "Genus") %>%
  select(dataset, genus, body_site, site_type, rel_abun)

# Species ----
metagenome_species <- read_csv(here::here("Data", "Kraken_RelAbun_Species.csv"))

# Summarize data - calculate cumulative relative abundance
metagenome_species_cumsum <- metagenome_species %>%
  filter(!startsWith(genus1, "Candidatus_")) %>%
  group_by(Species) %>%
  dplyr::summarise(mean_rel_abun_kraken = mean(rel_abun_kraken), 
                   prevalence = sum(rel_abun_kraken > 0.01),
                   prevalence_percent = (prevalence/268) * 100, 
  ) %>% 
  dplyr::arrange(desc(mean_rel_abun_kraken)) %>%  
  mutate(
    cumulative_abundance = cumsum(mean_rel_abun_kraken),
    rank = row_number()
  )

# Culture dataset by species
culture_species <- culture %>%
  mutate(Species = str_remove(Species, "_A")) %>%
  mutate(Species = ifelse(is.na(Species), 
                          Genus, 
                          paste(Genus, Species))) %>%
  filter(Genus != "Penicillium") %>%
  group_by(Species, body_site, site_type) %>%
  dplyr::summarise(
    count = n(),
    .groups = "drop"
  ) %>%
  group_by(body_site) %>%
  mutate(
    total_body_site_count = sum(count),
    rel_abun = (count / total_body_site_count) * 100
  ) %>%
  ungroup() %>%
  mutate(dataset =  "Culture") %>% 
  relocate(dataset, .before =1) %>%
  mutate(Species = case_when(
    is.na(Species) | Species == "" ~ "Other",
    TRUE ~ Species
  )) %>%
  dplyr::rename("species" = "Species") %>%
  select(dataset, species, body_site, site_type, rel_abun)

# Indicating whether species is detected in isolate collection
metagenome_species_cumsum1 <- metagenome_species_cumsum %>%
  mutate(Isolated = ifelse(Species %in% culture_species$species, "Yes", "No")) %>%
  mutate(Isolated = case_when(
    Species == "Bacillus thuringiensis" ~ "Yes", 
    Species == "Bacillus cereus" ~ "Yes", 
    TRUE ~ Isolated
  ))

# Intersection with cumulative sum data
intersection_species_cumsum <- metagenome_species_cumsum %>%
  dplyr::inner_join(culture_species, by = c("Species"="species")) 

# Extract C. acnes row
specific_row <- metagenome_species_cumsum %>%
  filter(Species == "Cutibacterium acnes")

# Add C. acnes
intersection_species_cumsum1 <- bind_rows(intersection_species_cumsum, specific_row)

# Plot data
intersection_species_cumsum1 %>%
  #slice(1:40) %>%
  ggplot(aes(x = rank, y = cumulative_abundance)) +
  geom_line(size = 0.5, color = "gray", linetype = "dashed") +
  geom_point(aes(size = prevalence_percent+0.5), 
             shape = 21, 
             color = "#121212", 
             stroke = 1) +
  geom_point(aes(color = prevalence_percent, size = prevalence_percent)) +
  geom_text_repel(data = intersection_species_cumsum1 %>% distinct(Species, .keep_all = TRUE),
                  aes(label = Species), 
                  segment.color = "gray", 
                  segment.linetype = "dotted", 
                  segment.size = 0.7,
                  size = 4, 
                  max.overlaps = 30, 
                  box.padding = 0.3) +
  labs(x = "Rank", 
       y = "Cumulative Relative Abundance (%)", 
       color = "Prevalence (%)",
       size = "Prevalence (%)") +
  theme_minimal(base_size = 14) + 
  scale_color_distiller(palette = "PiYG") +
  ylim(0,100)
