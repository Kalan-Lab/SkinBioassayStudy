library(tidyverse)
library(dplyr)
#install.packages("extraoperators")
library(extraoperators)
library(ggplot2)
library(readxl)

#import bioassay raw data (de-duplicated)
bioassay_data <- read.csv("/Users/unguyen2/Documents/GitHub/Kalan_Lab/SkinBioassayStudy/Figures/Final/FigureS5/Data/bioassay_data.csv")
#bioassay data with ID
complete_skin_bioassay_isolate_list <- read_excel("/Users/unguyen2/Documents/GitHub/Kalan_Lab/SkinBioassayStudy/Figures/Final/FigureS5/Data/complete_skin_bioassay_isolate_list_092922.xlsx", 
                                                  sheet = "complete_skin_bioassay_isolate_")
#strains for paper
strain_paper <- read_excel("/Users/unguyen2/Documents/GitHub/Kalan_Lab/SkinBioassayStudy/Figures/Final/FigureS5/Data/complete_skin_bioassay_isolate_list_092922.xlsx", 
                           sheet = "internal - assembly & antismash")
#select strains for paper (dereplicated)
bioassay_paper <- subset(strain_paper, strain_paper$`Representative following Dereplication at 99% ANI` !="No")

#remove strains with ID
complete <- complete_skin_bioassay_isolate_list %>% select(2, 9, 11, 12)
new <- merge(bioassay_data, complete, by="Strain_ID")
new_1 <- new[!is.na(new$Genus),]
#export dataset 
#this is the de-duplicated and contains strains with ID
#library(writexl)
#write_xlsx(new_1, path = "~/Documents/bioassay_data_new.xlsx")

#subset data with sequenced genome
bioassay_genome <- subset(new_1, new_1$`genome sequenced (Y/N)` !="N")

#subset data to Strain_ID, Pathogen_Name, Bioassay_Score, Bioassay_Activity
input <- bioassay_genome %>%
  select(Strain_ID, Pathogen_Name, simplified.score, score.classification)

#Upset plot 

#append a column based on conditions and at a specific spot in the dataframe
input <- input %>%
  add_column(Bioassay_Activity = 
               if_else(.$simplified.score >= 1, TRUE, FALSE), 
             .after = "simplified.score")

#convert bioassay activity from character to logical
logic <- as.logical(input$Bioassay_Activity)

#adding logical column into fungi_input dataframe
logic_data <- add_column(input, logic, .after = "Bioassay_Activity")

#selecting Strain_ID, Pathogen_Name, and logical bioassay activity
upset <- select(logic_data, 1, 2, 5)

#making wide data
wide.data.upset <- upset %>% 
  mutate(Pathogen_Name = factor(Pathogen_Name, levels = unique(Pathogen_Name))) %>%
  group_by(Strain_ID) %>% 
  summarise_all(na.omit) %>%
  spread(Pathogen_Name, logic) %>%
  subset(Strain_ID %in% bioassay_paper$Sample) %>% #subset Strain_ID based on the values in bioassay_paper
  remove_rownames() %>%
  column_to_rownames(var = "Strain_ID")

#data clean up 
upset_input <- wide.data.upset %>% 
  ungroup()

pathogens <- c("Staphylococcus aureus (MRSA) - PID40",
               "Bacillus cereus - PID30",
               "Bacillus subtilis - PID29",
               "Mycobacterium smegmatis - PID1",
               "Norcardia corynebacteroides - PID5",
               "Staphylococcus epidermidis - PID18",
               "Micrococcus luteus - PID19",
               "Enterococcus faecalis - PID41",
               "Escherichia coli - PID37",
               "Pseudomonas aeruginosa (PAO1) - PID38",
               "Pseudomonas aeruginosa 27873 - PID25",
               "Enterobacter cloacae - PID17",
               "Klebsiella oxytoca- PID21",
               "Citrobacter freundii - PID22",
               "Proteus vulgaris - PID24",
               "Serratia marcescens 8055 - PID31",
               "Acinetobacter baumannii - PID42",
               "Cryptococcus neoformans (H99) - PID49",
               "Candida albicans (K1) - PID39",
               "Candida sp. - PID36",
               "Trichosporon asahii - PID56",
               "Metarhizium sp. - PID43",
               "Trichoderma sp. - PID44",
               "Aspergillus flavus - PID14")

colnames(wide.data.upset)  <- pathogens
#wide.data.upset %>% print(n = nrow(wide.data.upset))

#plotting only fungi
upset_input_fungi <- wide.data.upset %>% 
  select(18:24)

fungi <- c("Cryptococcus neoformans (H99)",
           "Candida albicans (K1)",
           "Candida sp.",
           "Trichosporon asahii",
           "Metarhizium sp.",
           "Trichoderma sp.",
           "Aspergillus flavus")

colnames(upset_input_fungi)  <- fungi
#upset_input_fungi %>% print(n = nrow(upset_input_fungi))

#making upset plot without color
library(ComplexUpset)

#import updated, dereplicated strain list 
row_annotation <- read.csv("/Users/unguyen2/Documents/GitHub/Kalan_Lab/SkinBioassayStudy/Figures/Final/FigureS5/Data/row_annotation.csv")
#making annotation
wide.data.annotation <- upset %>% 
  mutate(Pathogen_Name = factor(Pathogen_Name, levels = unique(Pathogen_Name))) %>%
  group_by(Strain_ID) %>% 
  summarise_all(na.omit) %>%
  spread(Pathogen_Name, logic) %>%
  subset(Strain_ID %in% bioassay_paper$Sample)
annotation <- merge(wide.data.annotation, row_annotation, by="Strain_ID")

#making upset plot with genus for intersection size
upset(upset_input_fungi, fungi,
      base_annotations = list(
      'Intersection_size' = intersection_size(
        count = FALSE, 
        aes=aes(fill=annotation$Genus))),
      name = "Fungal Pathogen Groupings", 
      min_size = 1, 
      themes = upset_modify_themes(theme(axis.text.x = element_text(angle = 90))),
      width_ratio = 0.1) + 
  labs(title = "Skin isolates exhibiting antifungal activities") 

# Import color dataframe
color_genus <- read_excel("/Users/unguyen2/Documents/GitHub/Kalan_Lab/SkinBioassayStudy/Figures/Final/FigureS5/Data/complete_skin_bioassay_isolate_list_092922.xlsx", 
                          sheet = "internal - Colors for Species_T")
# Set order
color_genus$Genus <- factor(color_genus$Genus, levels = color_genus$Genus)
# Create color vector
colors_genus <- setNames(color_genus$Hex, color_genus$Genus)

upset(upset_input_fungi, 
      fungi,
      base_annotations = list(
        'Intersection_size' = intersection_size(
          count = FALSE, 
          mapping = aes(fill = annotation$Genus)
        ) + 
          scale_fill_manual(values = colors_genus, 
                            breaks = levels(color_genus$Genus)) +
          theme(legend.position = "right", 
                legend.title = element_blank(), 
                text = element_text(size = 16),
                axis.text = element_text(size = 16),
                axis.title = element_text(size = 16),
                legend.text = element_text(size = 14)
                ) +
          labs(y = "Number of Isolates")
      ),
      name = "Fungal Pathogen Groupings", 
      min_size = 1,
      width_ratio = 0.1) 
