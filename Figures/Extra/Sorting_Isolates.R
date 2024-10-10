library(readxl)
library(ggplot2)
library(dplyr)
Sup_Tables <- read_excel("~/Downloads/Sup Tables.xlsx")

Sup_Tables <- Sup_Tables %>%
  # Set the second row as column names
  setNames(.[2,]) %>%
  # Remove the first two rows
  slice(-(1:2))

# Phylum mapping
phylum_mapping <- c(
  setNames(rep("Actinobacteria", 22), c("Cutibacterium", "Corynebacterium", "Micrococcus", "Kocuria", "Rothia", 
                                        "Brevibacterium", "Gordonia", "Dermabacter", "Kytococcus", "Janibacter", 
                                        "Dietzia", "Microbacterium", "Brachybacterium", "Dermacoccus", 
                                        "Nesterenkonia", "Pseudoclavibacter", "Citricoccus", "Micromonospora",
                                        "Aestuariimicrobium", "Pseudoglutamicibacter", "Cellulosimicrobium", "Rhodocococcus")),
  setNames("Bacteroidota", "Sphingobacterium"),
  setNames(rep("Bacillota", 11), c("Staphylococcus", "Bacillus", "Granulicatella", "Enterococcus",
                                  "Helcococcus", "Lysinibacillus", "Peribacillus", "Niallia", "Paenibacillus", "Oceanobacillus", "Paenibacillus_A")),
  setNames(rep("Pseudomonadota", 6), c("Klebsiella", "Citrobacter", "Escherichia", "Enterobacter", "Morganella", "Raoultella")), 
  setNames("Fungi", "Penicillium"))


# Add phylum
Sup_Tables <- Sup_Tables %>%
  mutate(Phylum = case_when(
    Genus %in% names(phylum_mapping) ~ phylum_mapping[Genus],
    TRUE ~ "Other"
  )) %>%
  relocate(Phylum, .before = Genus)

# Summary
summary_table <- Sup_Tables %>%
  group_by(Phylum) %>%
  dplyr::summarise(
    Distinct_Genera = n_distinct(Genus),
    Distinct_Species = n_distinct(Species[!is.na(Species)]),
    Strains_Not_Speciated = sum(is.na(Species)),
    Total_Strains = n()
  )

# Function to get unique genera and species for a given phylum
get_unique_taxa <- function(phylum_name) {
  phylum_data <- Sup_Tables %>%
    filter(Phylum == phylum_name)
  
  unique_genera <- phylum_data %>%
    distinct(Genus) %>%
    arrange(Genus)
  
  unique_species <- phylum_data %>%
    filter(!is.na(Species) & Species != "") %>%
    distinct(Species) %>%
    arrange(Species)
  
  list(
    Phylum = phylum_name,
    Unique_Genera = unique_genera$Genus,
    Unique_Species = unique_species$Species,
    Genera_Count = nrow(unique_genera),
    Species_Count = nrow(unique_species)
  )
}

# Get list of all phyla
phyla <- unique(Sup_Tables$Phylum)

# Apply the function to each phylum
phylum_summaries <- lapply(phyla, get_unique_taxa)

#write.csv(summary_table, "/Users/thynguyen/Documents/GitHub/SkinBioassayStudy/Figures/Final/Figure2/Isolate_Overview.csv")

ggplot(summary_table, aes(x = Distinct_Genera, y = Distinct_Species, 
                          size = Total_Strains, color = Strains_Not_Speciated)) +
  geom_point(alpha = 0.7) +
  scale_size(range = c(2, 10)) +
  scale_color_viridis_c() +
  labs(title = "Taxonomic Diversity by Phylum",
       x = "Number of Distinct Genera", 
       y = "Number of Distinct Species",
       size = "Total Strains",
       color = "Number of Strain Not Speciated") +
  theme_minimal() +
  geom_text(aes(label = Phylum), vjust = 2, size = 3)
