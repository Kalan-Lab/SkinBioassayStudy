library(pheatmap)
library(RColorBrewer)
library(dplyr)
library(writexl)
library(tidyverse)
library(patchwork)
library(readxl)
data = read.csv("/Users/thynguyen/Documents/GitHub/SkinBioassayStudy/Figures/Final/Figure3/Data/bioassay_data_new_wide_updated.csv")
# row annotaions body_site
annotation_row = read.csv('/Users/thynguyen/Documents/GitHub/SkinBioassayStudy/Figures/Final/Figure3/Data/row_annotation.csv')

Body_Site = c("Nares"="#D53E4F",
              "Toe web space"="#F46D43",
              "Umbilicus"="#FDAE61",
              "Antecubital fossa"="#FEE08B",
              "Volar forearm"="#E6F598",
              "Alar crease"="#ABDDA4",
              "Back"="#66C2A5",
              "Occiput"="#3288BD")

# Phylum mapping
phylum_mapping <- c(
  "Micrococcus" = "Actinomycetota",
  "Dietzia" = "Actinomycetota",
  "Staphylococcus" = "Bacillota",
  "Kocuria" = "Actinomycetota",
  "Brachybacterium" = "Actinomycetota",
  "Brevibacterium" = "Actinomycetota",
  "Corynebacterium" = "Actinomycetota",
  "Paenibacillus_A" = "Bacillota",
  "Gordonia" = "Actinomycetota",
  "Dermabacter" = "Actinomycetota",
  "Morganella" = "Pseudomonadota",
  "Rothia" = "Actinomycetota",
  "Microbacterium" = "Actinomycetota",
  "Dermacoccus" = "Actinomycetota",
  "Oceanobacillus" = "Bacillota",
  "Citricoccus" = "Actinomycetota",
  "Aestuariimicrobium" = "Actinomycetota",
  "Escherichia" = "Pseudomonadota",
  "Granulicatella" = "Bacillota",
  "Pseudoclavibacter" = "Actinomycetota",
  "Enterococcus" = "Bacillota",
  "Sphingobacterium" = "Bacteroidota",
  "Peribacillus" = "Bacillota",
  "Citrobacter" = "Pseudomonadota",
  "Nesterenkonia" = "Actinomycetota",
  "Janibacter" = "Actinomycetota",
  "Raoultella" = "Pseudomonadota",
  "Klebsiella" = "Pseudomonadota",
  "Enterobacter" = "Pseudomonadota",
  "Helcococcus" = "Bacillota",
  "Niallia" = "Bacillota",
  "Micromonospora" = "Actinomycetota",
  "Lysinibacillus" = "Bacillota",
  "Bacillus" = "Bacillota",
  "Rhodocococcus" = "Actinomycetota",
  "Pseudoglutamicibacter" = "Actinomycetota",
  "Paenibacillus" = "Bacillota",
  "Cutibacterium" = "Actinomycetota",
  "Kytococcus" = "Actinomycetota",
  "Penicillium" = "Other",  
  "Cellulosimicrobium" = "Actinomycetota"
)

# Family mapping
family_mapping <- c(
  "Micrococcus" = "Micrococcaceae",
  "Dietzia" = "Dietziaceae",
  "Staphylococcus" = "Staphylococcaceae",
  "Kocuria" = "Micrococcaceae",
  "Brachybacterium" = "Dermabacteraceae",
  "Brevibacterium" = "Brevibacteriaceae",
  "Corynebacterium" = "Corynebacteriaceae",
  "Paenibacillus_A" = "Paenibacillaceae",
  "Gordonia" = "Gordoniaceae",
  "Dermabacter" = "Dermabacteraceae",
  "Morganella" = "Morganellaceae",
  "Rothia" = "Micrococcaceae",
  "Microbacterium" = "Microbacteriaceae",
  "Dermacoccus" = "Dermacoccaceae",
  "Oceanobacillus" = "Bacillaceae",
  "Citricoccus" = "Micrococcaceae",
  "Aestuariimicrobium" = "Propionibacteriaceae",
  "Escherichia" = "Enterobacteriaceae",
  "Granulicatella" = "Carnobacteriaceae",
  "Pseudoclavibacter" = "Microbacteriaceae",
  "Enterococcus" = "Enterococcaceae",
  "Sphingobacterium" = "Sphingobacteriaceae",
  "Peribacillus" = "Bacillaceae",
  "Citrobacter" = "Enterobacteriaceae",
  "Nesterenkonia" = "Micrococcaceae",
  "Janibacter" = "Intrasporangiaceae",
  "Raoultella" = "Enterobacteriaceae",
  "Klebsiella" = "Enterobacteriaceae",
  "Enterobacter" = "Enterobacteriaceae",
  "Helcococcus" = "Peptostreptococcaceae",
  "Niallia" = "Bacillaceae",
  "Micromonospora" = "Micromonosporaceae",
  "Lysinibacillus" = "Bacillaceae",
  "Bacillus" = "Bacillaceae",
  "Rhodocococcus" = "Nocardiaceae",
  "Pseudoglutamicibacter" = "Micrococcaceae",
  "Paenibacillus" = "Paenibacillaceae",
  "Cutibacterium" = "Propionibacteriaceae",
  "Kytococcus" = "Dermacoccaceae",
  "Penicillium" = "Trichocomaceae",
  "Cellulosimicrobium" = "Promicromonosporaceae"
)

site_mapping <- c(
  "Nares" = "Moist",
  "Toe web space" = "Moist",
  "Umbilicus" = "Moist", 
  "Antecubital fossa" = "Rarely Moist",
  "Volar forearm" = "Rarely Moist",
  "Alar crease" = "Sebaceous",
  "Back" = "Sebaceous",
  "Occiput" = "Sebaceous"
)

# Import updated Supp Table 2
annotation <- read_excel("~/Documents/GitHub/SkinBioassayStudy/Figures/Final/Figure3/Data/250925_SupTable2_Updated.xlsx")
annotation <- annotation %>%
  select(`Strain ID`, `Body site`, Genus, Species)
# Apply the mappings
annotation$Phylum <- phylum_mapping[annotation$Genus]
annotation$Family <- family_mapping[annotation$Genus]
annotation$Site_Type <- site_mapping[annotation$`Body site`]

# Pivot data from wide to long format
data_long <- data %>%
  pivot_longer(
    cols = 4:389,  # Columns with Strain IDs
    names_to = "Strain ID",
    values_to = "Score"
  )

# Merge with annotation dataframe
data_merged <- data_long %>%
  dplyr::left_join(annotation, by = "Strain ID")

# Kocuria antifungal statistics
kocuria_fungi<- data_merged %>%
  filter(Pathogen_Type == "Fungal" & Genus == "Kocuria")
print(unique(kocuria_fungi$`Strain ID`))
kocuria_fungi_summary <- data_merged %>%
  filter(Pathogen_Type == "Fungal" & Genus == "Kocuria") %>%
  group_by(Pathogen_Name) %>%
  summarise(total_strains = n(), 
            partial_active = sum(Score %in% c(1)), 
            complete_active = sum(Score %in% c(2)),
            both_active = sum(Score %in% c(1,2)), 
            percent_partial = (partial_active / total_strains) * 100,
            percent_complete = (complete_active / total_strains) * 100,
            percent_both= (both_active / total_strains) * 100)
kocuria_body_summary <- data_merged %>%
  filter(Pathogen_Type == "Fungal" & Genus == "Kocuria") %>%
  group_by(`Body site`) %>%
  summarise(total_strains = n(), 
            partial_active = sum(Score %in% c(1)), 
            complete_active = sum(Score %in% c(2)),
            both_active = sum(Score %in% c(1,2)), 
            percent_partial = (partial_active / total_strains) * 100,
            percent_complete = (complete_active / total_strains) * 100,
            percent_both= (both_active / total_strains) * 100)
kocuria_fungi_body_summary <- data_merged %>%
  filter(Pathogen_Type == "Fungal" & Genus == "Kocuria") %>%
  group_by(Pathogen_Name, `Body site`) %>%
  summarise(total_strains = n(), 
            partial_active = sum(Score %in% c(1)), 
            complete_active = sum(Score %in% c(2)),
            both_active = sum(Score %in% c(1,2)), 
            percent_partial = (partial_active / total_strains) * 100,
            percent_complete = (complete_active / total_strains) * 100,
            percent_both= (both_active / total_strains) * 100)

# Micrococcus antifungal statistics
micrococcus_fungi<- data_merged %>%
  filter(Pathogen_Type == "Fungal" & Genus == "Micrococcus")
print(unique(micrococcus_fungi$`Strain ID`))
micrococcus_fungi_summary <- data_merged %>%
  filter(Pathogen_Type == "Fungal" & Genus == "Micrococcus") %>%
  group_by(Pathogen_Name) %>%
  summarise(total_strains = n(), 
            partial_active = sum(Score %in% c(1)), 
            complete_active = sum(Score %in% c(2)),
            both_active = sum(Score %in% c(1,2)), 
            percent_partial = (partial_active / total_strains) * 100,
            percent_complete = (complete_active / total_strains) * 100,
            percent_both= (both_active / total_strains) * 100)
micrococcus_body_summary <- data_merged %>%
  filter(Pathogen_Type == "Fungal" & Genus == "Micrococcus") %>%
  group_by(`Body site`) %>%
  summarise(total_strains = n(), 
            partial_active = sum(Score %in% c(1)), 
            complete_active = sum(Score %in% c(2)),
            both_active = sum(Score %in% c(1,2)), 
            percent_partial = (partial_active / total_strains) * 100,
            percent_complete = (complete_active / total_strains) * 100,
            percent_both= (both_active / total_strains) * 100)
micrococcus_fungi_body_summary <- data_merged %>%
  filter(Pathogen_Type == "Fungal" & Genus == "Micrococcus") %>%
  group_by(Pathogen_Name, `Body site`) %>%
  summarise(total_strains = n(), 
            partial_active = sum(Score %in% c(1)), 
            complete_active = sum(Score %in% c(2)),
            both_active = sum(Score %in% c(1,2)), 
            percent_partial = (partial_active / total_strains) * 100,
            percent_complete = (complete_active / total_strains) * 100,
            percent_both= (both_active / total_strains) * 100)

sheet_list <- list(
  "kocuria_fungi" = kocuria_fungi_summary, 
  "kocuria_body" = kocuria_body_summary, 
  "kocuria_fungi_body" = kocuria_fungi_body_summary,
  "micrococcus_fungi" = micrococcus_fungi_summary, 
  "micrococcus_body" = micrococcus_body_summary,
  "micrococcus_fungi_body" = micrococcus_fungi_body_summary
)
#writexl::write_xlsx(sheet_list, "/Users/thynguyen/Documents/GitHub/SkinBioassayStudy/Figures/Final/Figure3/Data/Kocuria_Micrococcus_Statistics.xlsx")

# Plot by Body site
p <- data_merged %>%
  #filter(Family %in% c("Corynebacteriaceae","Micrococcaceae", "Staphylococcaceae")) %>% 
  filter(Score != -1) %>%
  filter(Pathogen_Type == "Fungal") %>%
  group_by(`Strain ID`, `Body site`, Site_Type, Family, Pathogen_Type) %>%
  dplyr::summarise(Score = mean(Score, na.rm = T), .groups="drop") %>%
  mutate(`Body site` = factor(`Body site`, levels =  c("Nares","Toe web space","Umbilicus","Antecubital fossa",
                                                       "Volar forearm","Alar crease","Back","Occiput"))) %>%
  ggplot(aes(x = `Body site`, y = Score, fill = `Body site`, color = `Body site`)) + 
  geom_boxplot(outlier.shape = NA, alpha = 0.7) +
  geom_point(position = position_jitter(width = 0.2), alpha = 0.5, size = 1) +
  #facet_wrap(~ Family, nrow = 1) +
  #facet_grid(Pathogen_Type ~ Family) +
  scale_fill_manual(values = Body_Site) +
  scale_color_manual(values = Body_Site) +
  theme_classic(base_size = 16) +
  theme(axis.text.x = element_blank(),
        #axis.text.x = element_text(angle = 45, hjust = 1), 
        legend.position = "none") +
  labs(x = NULL,
       y = "Average Antifungal Score", 
       title = "Complete") +
  ylim(-0.09, 2.1) + 
  stat_compare_means(
    method = "wilcox.test", 
    ref.group = "Toe web space", 
    label = "p.signif"
  )

# Plot by Body site just Micrococcaceae
p1 <- data_merged %>%
  filter(Family %in% c("Micrococcaceae")) %>% 
  filter(Score != -1) %>%
  filter(Pathogen_Type == "Fungal") %>%
  group_by(`Strain ID`, `Body site`, Site_Type, Family, Pathogen_Type) %>%
  dplyr::summarise(Score = mean(Score, na.rm = T), .groups="drop") %>%
  mutate(`Body site` = factor(`Body site`, levels =  c("Nares","Toe web space","Umbilicus","Antecubital fossa",
                                                       "Volar forearm","Alar crease","Back","Occiput"))) %>%
  ggplot(aes(x = `Body site`, y = Score, fill = `Body site`, color = `Body site`)) + 
  geom_boxplot(outlier.shape = NA, alpha = 0.7) +
  geom_point(position = position_jitter(width = 0.2), alpha = 0.5, size = 1) +
  #facet_wrap(~ Family, nrow = 1) +
  #facet_grid(Pathogen_Type ~ Family) +
  scale_fill_manual(values = Body_Site) +
  scale_color_manual(values = Body_Site) +
  theme_classic(base_size = 16) +
  theme(axis.text.x = element_blank(),
        #axis.text.x = element_text(angle = 45, hjust = 1), 
        legend.position = "none") +
  labs(x = NULL,
       y = NULL, 
       title = "Micrococcaceae") +
  ylim(-0.09, 2.1) +
  stat_compare_means(
    method = "wilcox.test", 
    ref.group = "Toe web space", 
    label = "p.signif"
  )

p2 <- data_merged %>%
  filter(Family %in% c("Staphylococcaceae")) %>% 
  filter(Score != -1) %>%
  filter(Pathogen_Type == "Fungal") %>%
  group_by(`Strain ID`, `Body site`, Site_Type, Family, Pathogen_Type) %>%
  dplyr::summarise(Score = mean(Score, na.rm = T), .groups="drop") %>%
  mutate(`Body site` = factor(`Body site`, levels =  c("Nares","Toe web space","Umbilicus","Antecubital fossa",
                                                       "Volar forearm","Alar crease","Back","Occiput"))) %>%
  ggplot(aes(x = `Body site`, y = Score, fill = `Body site`, color = `Body site`)) + 
  geom_boxplot(outlier.shape = NA, alpha = 0.7) +
  geom_point(position = position_jitter(width = 0.2), alpha = 0.5, size = 1) +
  #facet_wrap(~ Family, nrow = 1) +
  #facet_grid(Pathogen_Type ~ Family) +
  scale_fill_manual(values = Body_Site) +
  scale_color_manual(values = Body_Site) +
  theme_classic(base_size = 16) +
  theme(axis.text.x = element_blank(),
        #axis.text.x = element_text(angle = 45, hjust = 1), 
        legend.position = "none") +
  labs(x = NULL,
       y = NULL, 
       title = "Staphylococcaceae") +
  ylim(-0.09, 2.1) +
  stat_compare_means(
    method = "wilcox.test", 
    ref.group = "Toe web space", 
    label = "p.signif"
  )

p3 <- data_merged %>%
  filter(Family %in% c("Corynebacteriaceae")) %>% 
  filter(Score != -1) %>%
  filter(Pathogen_Type == "Fungal") %>%
  group_by(`Strain ID`, `Body site`, Site_Type, Family, Pathogen_Type) %>%
  dplyr::summarise(Score = mean(Score, na.rm = T), .groups="drop") %>%
  mutate(`Body site` = factor(`Body site`, levels =  c("Nares","Toe web space","Umbilicus","Antecubital fossa",
                                                       "Volar forearm","Alar crease","Back","Occiput"))) %>%
  ggplot(aes(x = `Body site`, y = Score, fill = `Body site`, color = `Body site`)) + 
  geom_boxplot(outlier.shape = NA, alpha = 0.7) +
  geom_point(position = position_jitter(width = 0.2), alpha = 0.5, size = 1) +
  #facet_wrap(~ Family, nrow = 1) +
  #facet_grid(Pathogen_Type ~ Family) +
  scale_fill_manual(values = Body_Site) +
  scale_color_manual(values = Body_Site) +
  theme_classic(base_size = 16) +
  theme(axis.text.x = element_blank(),
        #axis.text.x = element_text(angle = 45, hjust = 1), 
        legend.position = "bottom"
        ) +
  labs(x = NULL,
       y = NULL, 
       title = "Corynebacteriaceae") +
  ylim(-0.09, 2.1) +
  stat_compare_means(
    method = "wilcox.test", 
    ref.group = "Toe web space", 
    label = "p.signif"
  )

p | p1 | p2 | p3

# Plot by Family 
data_merged %>%
  filter(Family %in% c("Corynebacteriaceae","Micrococcaceae", "Staphylococcaceae")) %>% 
  filter(Score != -1) %>%
  filter(Pathogen_Type == "Fungal") %>%
  group_by(`Strain ID`, `Body site`, Site_Type, Family, Pathogen_Type) %>%
  dplyr::summarise(Score = mean(Score, na.rm = T), .groups="drop") %>%
  mutate(`Body site` = factor(`Body site`, levels =  c("Nares","Umbilicus","Toe web space","Antecubital fossa",
                                                       "Volar forearm","Alar crease","Back","Occiput"))) %>%
  ggplot(aes(x = `Body site`, y = Score, fill = `Body site`, color = `Body site`)) + 
  geom_boxplot(outlier.shape = NA, alpha = 0.7) +
  geom_point(position = position_jitter(width = 0.2), alpha = 0.5, size = 1) +
  facet_wrap(~ Family, nrow = 1) +
  #facet_grid(Pathogen_Type ~ Family) +
  scale_fill_manual(values = Body_Site) +
  scale_color_manual(values = Body_Site) +
  theme_bw(base_size = 16) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), 
        legend.position = "none") +
  labs(y = "Average Antifungal Score") 

data_merged %>%
  #filter(Family %in% c("Corynebacteriaceae","Micrococcaceae", "Staphylococcaceae")) %>% 
  filter(Score != -1) %>%
  filter(Pathogen_Type == "Fungal") %>%
  group_by(`Strain ID`, `Body site`, Site_Type, Family, Pathogen_Type) %>%
  dplyr::summarise(Score = mean(Score, na.rm = T), .groups="drop") %>%
  mutate(`Body site` = factor(`Body site`, levels =  c("Nares","Umbilicus","Toe web space","Antecubital fossa",
                                                       "Volar forearm","Alar crease","Back","Occiput"))) %>%
  ggplot(aes(x = `Body site`, y = Score, fill = `Body site`, color = `Body site`)) + 
  geom_boxplot(outlier.shape = NA, alpha = 0.7) +
  geom_point(position = position_jitter(width = 0.2), alpha = 0.5, size = 1) +
  facet_wrap(~ Family, nrow = 3) +
  #facet_grid(Pathogen_Type ~ Family) +
  scale_fill_manual(values = Body_Site) +
  scale_color_manual(values = Body_Site) +
  theme_bw(base_size = 16) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), 
        legend.position = "none") +
  labs(y = "Average Antifungal Score") 

# Plot Micrococcaceae by Pathogen Type
data_merged %>%
  filter(Family %in% c("Micrococcaceae")) %>% 
  filter(Score != -1) %>%
  group_by(`Strain ID`, `Body site`, Site_Type, Family, Pathogen_Type) %>%
  dplyr::summarise(Score = mean(Score, na.rm = T), .groups="drop") %>%
  mutate(`Body site` = factor(`Body site`, levels =  c("Nares","Umbilicus","Toe web space","Antecubital fossa",
                                                   "Volar forearm","Alar crease","Back","Occiput"))) %>%
  ggplot(aes(x = `Body site`, y = Score, fill = `Body site`, color = `Body site`)) + 
  geom_boxplot(outlier.shape = NA, alpha = 0.7) +
  geom_point(position = position_jitter(width = 0.2), alpha = 0.5, size = 1) +
  facet_wrap(~ Pathogen_Type, nrow = 1) +
  #facet_grid(Pathogen_Type ~ Family) +
  scale_fill_manual(values = Body_Site) +
  scale_color_manual(values = Body_Site) +
  theme_bw(base_size = 16) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), 
        legend.position = "none") +
  labs(y = "Average Bioassay Score") 


