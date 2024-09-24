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
wide.data.upset %>% print(n = nrow(wide.data.upset))

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
upset(upset_input, pathogens,
      name = "Fungal Pathogen Groupings", 
      min_size = 1, 
      themes = upset_modify_themes(theme(axis.text.x = element_text(angle = 90))),
      width_ratio = 0.1) + 
  labs(title = "Skin isolates exhibiting antifungal activities")

#import updated, dereplicated strain list 
row_annotation <- read.csv("~/Documents/Kalan.Lab/2022/June_2022/row_annotation.csv")
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

upset(upset_input_fungi, 
      fungi,
      base_annotations = list(
        'Intersection_size' = intersection_size(
          count = FALSE, 
          mapping=aes(fill=annotation$Genus)
          ) + scale_fill_manual(values = colors_genus)),
      name = "Fungal Pathogen Groupings", 
      min_size = 1,
      width_ratio = 0.1) + 
  labs(title = "Skin isolates exhibiting antifungal activities") 

colors = c("#cccccc",
           "#941752",	"#a94574",	"#be7397",	"#d4a2b9",	"#e9d0dc",
           "#942193",	"#a94da8",	"#be79be",	"#d4a6d3",	"#e9d2e9",
           "#521B93",	"#7448a8",	"#9776be",	"#b9a3d3",	"#dcd1e9",
           "#021893",	"#3446a8",	"#6774be",	"#99a2d3",	"#ccd0e9",
           "#069192",	"#37a7a7",	"#69bdbd",	"#9bd3d3",	"#cde9e9",
           "#038F01",	"#35a533",	"#67bb66",	"#9ad299",	"#cce8cc",
           "#e17c00",	"#e79632",	"#edb066",	"#f3ca99",	"#f9e4cc",
           "#000000",	"#323232",	"#666666",	"#999999")

colors_genus = c("Aestuariimicrobium"="#cccccc",
           "Brachybacterium"="#941752",	"Brevibacterium"="#a94574",	"Citricoccus"="#be7397",	"Citrobacter"="#d4a2b9",	"Corynebacterium"="#e9d0dc",
           "Dermabacter"="#942193",	"Dermacoccus"="#a94da8",	"Dietzia"="#be79be",	"Enterobacter"="#d4a6d3",	"Enterococcus"="#e9d2e9",
           "Escherichia"="#521B93",	"Gordonia"="#7448a8",	"Granulicatella"="#9776be",	"Helcococcus"="#b9a3d3",	"Janibacter"="#dcd1e9",
           "Klebsiella"="#021893",	"Kocuria"="#3446a8",	"Lysinibacillus"="#6774be",	"Microbacterium"="#99a2d3",	"Micrococcus"="#ccd0e9",
           "Micromonospora"="#069192",	"Morganella"="#37a7a7",	"Nesterenkonia"="#69bdbd",	"Niallia"="#9bd3d3",	"Oceanobacillus"="#cde9e9",
           "Paenibacillus"="#038F01",	"Peribacillus"="#35a533",	"Pseudoclavibacter"="#67bb66",	"Raoultella"="#9ad299",	"Rothia"="#cce8cc",
           "Sphingobacterium"="#e17c00",	"Staphylococcus"="#e79632")

#venn diagram 


#making wide data
wide.data.venn <- upset %>% 
  mutate(Pathogen_Name = factor(Pathogen_Name, levels = unique(Pathogen_Name))) %>%
  group_by(Strain_ID) %>% 
  summarise_all(na.omit) %>%
  spread(Pathogen_Name, logic)

#converting data frame from factors to characters
test <- data.frame(lapply(wide.data.venn, as.character),stringsAsFactors = FALSE)
#loop to replace all "TRUE" with strain_id and "FALSE" with blanks
for(i in 1:nrow(test)){
  test[i,] <- ifelse(test[i,] == "TRUE", test[i,1], "")}
#creating table categorized by pathogens and strain_ID with bioactivity
final <- test[,19:25]
#creating list for venn diagram
fungalLS <- lapply(as.list(final), function(x) x[x !=""])
lapply(fungalLS, tail)

# We can rename our list vectors
names(fungalLS) <- c("Cryptococcus neoformans", "Candida albicans", "Candida sp.", "Trichosporon asahii", "Metarhizium sp.", "Trichoderma sp.", "Aspergillus flavus")

VENN.LIST <- fungalLS

# To get the list of gene present in each Venn compartment we can use the gplots package
require("gplots")

a <- venn(VENN.LIST, show.plot=FALSE)
view(a)

# You can inspect the contents of this object with the str() function
str(a)

# By inspecting the structure of the a object created, 
# you notice two attributes: 1) dimnames 2) intersections
# We can store the intersections in a new object named inters
inters <- attr(a,"intersections")

# We can summarize the contents of each venn compartment, as follows:
# in 1) ConditionA only, 2) ConditionB only, 3) ConditionA & ConditionB
lapply(inters, list)

#convert list of intersections into dataframe
library(plyr)
inters_list <- ldply(inters, data.frame)

#changing column names
colnames(inters_list)[1] <- "Pathogen"
colnames(inters_list)[2] <- "Strain_ID"

#export table to excel
library(writexl)
write_xlsx(inters_list, path = "~/Documents/bioassay_genome_intersection_list_092822.xlsx", col_names = TRUE)

#selecting only Strain_ID from bioassay_genome_1
bioassay_genome_1 <- bioassay_genome %>%
  select(1)
inters_list_1 <- inters_list %>%
  select(2)
#find rows which are not in inters_list_1 which are strains that have no antifungal activity
install.packages("sqldf")
library(sqldf)
no_fungal <- sqldf('SELECT * FROM bioassay_genome_1 EXCEPT SELECT * FROM inters_list_1')

#exporting strain list with no antifungal activity
library(writexl)
write_xlsx(no_fungal, path = "~/Documents/bioassay_genome_intersection_list_no_fungal_092822.xlsx", col_names = TRUE)

