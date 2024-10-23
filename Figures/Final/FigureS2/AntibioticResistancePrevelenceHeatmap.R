# Prevelence of Antibiotic resistance

library(data.table)
library(readr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(pheatmap)
library(RColorBrewer)
library(pivottabler)
library(reshape2)

setwd(dir = "SkinBioassayStudy/Figures/Final/FigureS2")

# Prevelence of antiseptic genes in healthy skin metagenomes 
trim <- function (x) gsub("^\\s+|\\s+$", "", x) # remove leading and trailing white spaces from cells 

CardResults.df <- as.data.frame(read_csv("./Concatenated_Results_KMA.csv"))
meta.df<- as.data.frame(read_csv("./LKMB002_Metadata_UPDATED.csv"))
CardResults.df <- CardResults.df %>%  separate_rows(ResistanceMechanism, sep = ";")
CardResults.df$ResistanceMechanism <- trim(CardResults.df$ResistanceMechanism)
table(CardResults.df$ResistanceMechanism)

Efflux <- subset.data.frame(CardResults.df, ResistanceMechanism == "antibiotic efflux" ) # subsetting b/c a lot of the eflux pumps work for multiple antibiotics (and dont want to over count based on how im separating things below)
Efflux<- Efflux %>% mutate(AMRclass = case_when(ResistanceMechanism == "antibiotic efflux" ~ "Efflux"))


noEfflux <- subset.data.frame(CardResults.df, ResistanceMechanism != "antibiotic efflux")
noEfflux <- noEfflux  %>%  separate_rows(DrugClass, sep = ";")
noEfflux$DrugClass <- trim(noEfflux$DrugClass)
table(noEfflux$DrugClass)
noEfflux <- subset.data.frame(noEfflux, DrugClass != "glycopeptide antibiotic")
noEfflux <- noEfflux %>% mutate(AMRclass = case_when(DrugClass == "aminocoumarin antibiotic" ~ "Aminocoumarin",
                                                     DrugClass == "aminoglycoside antibiotic" ~ "Aminoglycoside",
                                                     DrugClass == "antibacterial free fatty acids" ~ "Antibacterial Free Fatty Acids",
                                                     DrugClass == "bicyclomycin-like antibiotic" ~ "Bicyclomycin-like",
                                                     DrugClass == "carbapenem" ~ "Beta-Lactam",
                                                     DrugClass == "cephalosporin" ~ "Beta-Lactam",
                                                     DrugClass == "cephamycin" ~ "Beta-Lactam",
                                                     DrugClass == "diaminopyrimidine antibiotic" ~ "Diaminopyrimidine",
                                                     DrugClass == "disinfecting agents and antiseptics" ~ "Disinfecting Agents and Antiseptics",
                                                     DrugClass == "fluoroquinolone antibiotic" ~ "Fluoroquinolone",
                                                     DrugClass == "glycopeptide antibiotic" ~ "Glycopeptide",
                                                     DrugClass == "glycylcycline" ~ "Glycylcycline",
                                                     DrugClass == "isoniazid-like antibiotic" ~ "Isoniazid-like",
                                                     DrugClass == "lincosamide antibiotic" ~ "Lincosamide",
                                                     DrugClass == "macrolide antibiotic" ~ "Macrolide",
                                                     DrugClass == "monobactam" ~ "Beta-Lactam",
                                                     DrugClass == "nitrofuran antibiotic" ~ "Nitrofuran",
                                                     DrugClass == "nitroimidazole antibiotic" ~ "Nitroimidazole",
                                                     DrugClass == "nucleoside antibiotic" ~ "Nucleoside Antibiotics",
                                                     DrugClass == "oxazolidinone antibiotic" ~ "Oxazolidinone",
                                                     DrugClass == "penam" ~ "Beta-Lactam",
                                                     DrugClass == "penem" ~ "Beta-Lactam",
                                                     DrugClass == "peptide antibiotic" ~ "Peptide Antibiotics",
                                                     DrugClass == "phenicol antibiotic" ~ "Phenicol",
                                                     DrugClass == "phosphonic acid antibiotic" ~ "Phosphonic Acid",
                                                     DrugClass == "pleuromutilin antibiotic" ~ "Pleuromutilin",
                                                     DrugClass == "rifamycin antibiotic" ~ "Rifamycin",
                                                     DrugClass == "streptogramin antibiotic" ~ "Streptogramin",
                                                     DrugClass == "sulfonamide antibiotic" ~ "Sulfonamide",
                                                     DrugClass == "tetracycline antibiotic" ~ "Tetracycline",))

CardResults.FIN.df<- rbind(noEfflux, Efflux)    
CardResults.FIN.df$Hit <- ifelse((CardResults.FIN.df$PercentCoverage >=70) & (CardResults.FIN.df$AverageMAPQ_CompletelyMappedReads >= 100), 1, 0) # 1 == hit, 0 = no hit
CardResults.FIN.df <- subset.data.frame(CardResults.FIN.df, Hit == 1) # keeping only hits with 75% coverage
CardResults.FIN.df <- merge(meta.df, CardResults.FIN.df, by = "SampleID", all = T)

CardResults.FIN.df<-distinct(CardResults.FIN.df, SampleID, AMRclass, .keep_all= TRUE) # removing any duplicate hits (ie a sample with multiple efflux pumps hits or aminoglycoside hits - so there is only one aminoglycoside count "presnet" for each sample)
CardResults.FIN.df <- CardResults.FIN.df %>% drop_na(AMRclass)
CardResults.FIN.df <-subset.data.frame(CardResults.FIN.df, SkinSite != "Neg")
CardResults.FIN.df <-subset.data.frame(CardResults.FIN.df, SkinSite != "Mock")

CardResults.BodySite.freq <- CardResults.FIN.df %>% group_by(SkinSite) %>% 
  dplyr::count(AMRclass) %>% 
  mutate(freq = n / 34 * 100) # divided by the 34 subjects

CardResults.Subject.freq <- CardResults.FIN.df %>% group_by(SubjectID) %>% 
  dplyr::count(AMRclass) %>% 
  mutate(freq = n / 8 * 100) # divided by the 8 skin sites for each subject

CardResults.Collective.freq <- CardResults.FIN.df %>% group_by(AMRclass) %>% 
  dplyr::count(AMRclass) %>% 
  mutate(freq = n / 272 * 100) # divided by the 8 skin sites for each subject

BodySite.Matrix <- acast(CardResults.BodySite.freq, AMRclass ~ SkinSite, value.var="freq")
BodySite.Matrix[is.na(BodySite.Matrix)] <- 0

pheatmap(BodySite.Matrix, 
         color = c("white","#FFF38F", "#FDEA45" ,"#91B959" , "#248A8D","#344571","#440054"),
         breaks = c(0,1,10, 20, 40,60, 80, 100),
         #annotation_row =  AroANN.prev,
         #annotation_colors = ExtColor,
         border_color = F,
         fontsize_row = 10, fontsize_col = 10)

Subject.Matrix <- acast(CardResults.Subject.freq, AMRclass ~ SubjectID, value.var="freq")
Subject.Matrix[is.na(Subject.Matrix)] <- 0

pheatmap(Subject.Matrix, 
         color = c("white","#FFF38F", "#FDEA45" ,"#91B959" , "#248A8D","#344571","#440054"),
         breaks = c(0,1,10, 20, 40,60, 80, 100),
         border_color = F,
         #annotation_row =  AroANN.prev,
         #annotation_colors = ExtColor,
         fontsize_row = 10, fontsize_col = 10)


# Prevelence frequency for the ISOLATES 
Nudge <- as.data.frame(read_csv("./Nudge_Results_Concatenated.csv"))
Iso.Met <-as.data.frame(read_csv("./IsolateGenomes_Metadata.csv"))# All the isolates 
#IsoCount<- as.data.frame(read.csv("./IsolatePhylumSpeciesCount.csv")) # All the isolates 
DeIso.Meta<- as.data.frame(read.csv("./DeRepicaredIsolatesMetadata.csv")) # the 182 representative isolates 
DeIsoCount <- as.data.frame(read.csv("./DereplicatedIsolateCount.csv")) # the 182 representative isolates 

DeIsolates <- as.list(DeIso.Meta$sample)
Iso.Meta <- DeIso.Meta
Nudge.d <- subset.data.frame(Nudge, Nudge$sample %in% DeIsolates)# subseting the dataframe to only include the 182 representative isolates
write.csv(Nudge.d, "./DereplicatedIsolateSupplementalTable.csv")

Nudge.df <- merge(Nudge.d, Iso.Meta, by = "sample", all = T)
Nudge.df$Hit <- ifelse((Nudge.df$Cut_Off == "Strict") | (Nudge.df$Cut_Off == "Perfect"), "Hit", "Not")
Nudge.df$Hit[is.na(Nudge.df$Hit)] <- "Not"
Nudge.df$Hit90 <-ifelse((Nudge.df$PercentageLengthofReferenceSequence >=90) & (Nudge.df$Best_Identities >= 90), "Hit", "Not")
Nudge.df$Hit90BIN <-ifelse((Nudge.df$PercentageLengthofReferenceSequence >=90) & (Nudge.df$Best_Identities >= 90), 1, 0)
Nudge.90 <- subset.data.frame(Nudge.df, Hit90BIN == 1 )

Nudge.90  <- Nudge.90  %>%  separate_rows(ResistanceMechanism, sep = ";")
Nudge.90$ResistanceMechanism <- trim(Nudge.90$ResistanceMechanism)
table(Nudge.90$ResistanceMechanism)

Efflux <- subset.data.frame(Nudge.90, ResistanceMechanism == "antibiotic efflux" ) # subsetting b/c a lot of the eflux pumps work for multiple antibiotics (and dont want to over count based on how im separating things below)
Efflux<- Efflux %>% mutate(AMRclass = case_when(ResistanceMechanism == "antibiotic efflux" ~ "Efflux"))

noEfflux <- subset.data.frame(Nudge.90, ResistanceMechanism != "antibiotic efflux")
noEfflux <- noEfflux  %>%  separate_rows(DrugClass, sep = ";")
noEfflux$DrugClass <- trim(noEfflux$DrugClass)
noEfflux <- subset.data.frame(noEfflux, DrugClass != "glycopeptide antibiotic")
table(noEfflux$DrugClass)
noEfflux <- noEfflux %>% mutate(AMRclass = case_when(DrugClass == "aminocoumarin antibiotic" ~ "Aminocoumarin",
                                                     DrugClass == "aminoglycoside antibiotic" ~ "Aminoglycoside",
                                                     DrugClass == "antibacterial free fatty acids" ~ "Antibacterial Free Fatty Acids",
                                                     DrugClass == "bicyclomycin-like antibiotic" ~ "Bicyclomycin-like",
                                                     DrugClass == "carbapenem" ~ "Beta-Lactam",
                                                     DrugClass == "cephalosporin" ~ "Beta-Lactam",
                                                     DrugClass == "cephamycin" ~ "Beta-Lactam",
                                                     DrugClass == "diaminopyrimidine antibiotic" ~ "Diaminopyrimidine",
                                                     DrugClass == "disinfecting agents and antiseptics" ~ "Disinfecting Agents and Antiseptics",
                                                     DrugClass == "fluoroquinolone antibiotic" ~ "Fluoroquinolone",
                                                     DrugClass == "fusidane antibiotic" ~ "Fusadine",
                                                     DrugClass == "glycopeptide antibiotic" ~ "Glycopeptide",
                                                     DrugClass == "glycylcycline" ~ "Glycylcycline",
                                                     DrugClass == "isoniazid-like antibiotic" ~ "Isoniazid-like",
                                                     DrugClass == "lincosamide antibiotic" ~ "Lincosamide",
                                                     DrugClass == "macrolide antibiotic" ~ "Macrolide",
                                                     DrugClass == "monobactam" ~ "Beta-Lactam",
                                                     DrugClass == "nitrofuran antibiotic" ~ "Nitrofuran",
                                                     DrugClass == "nitroimidazole antibiotic" ~ "Nitroimidazole",
                                                     DrugClass == "nucleoside antibiotic" ~ "Nucleoside Antibiotics",
                                                     DrugClass == "oxazolidinone antibiotic" ~ "Oxazolidinone",
                                                     DrugClass == "penam" ~ "Beta-Lactam",
                                                     DrugClass == "penem" ~ "Beta-Lactam",
                                                     DrugClass == "peptide antibiotic" ~ "Peptide Antibiotics",
                                                     DrugClass == "phenicol antibiotic" ~ "Phenicol",
                                                     DrugClass == "phosphonic acid antibiotic" ~ "Phosphonic Acid",
                                                     DrugClass == "pleuromutilin antibiotic" ~ "Pleuromutilin",
                                                     DrugClass == "rifamycin antibiotic" ~ "Rifamycin",
                                                     DrugClass == "streptogramin A antibiotic" ~ "Streptogramin A",
                                                     DrugClass == "streptogramin B antibiotic" ~ "Streptogramin B",
                                                     DrugClass == "streptogramin antibiotic" ~ "Streptogramin",
                                                     DrugClass == "sulfonamide antibiotic" ~ "Sulfonamide",
                                                     DrugClass == "tetracycline antibiotic" ~ "Tetracycline",))

ISOResults<- rbind(noEfflux, Efflux)    
ISOResults.FIN.df <- merge(ISOResults, DeIsoCount,by ="Species", all = T)

ISOResults.FIN.df<-distinct(ISOResults.FIN.df, sample, AMRclass, .keep_all= TRUE) # removing any duplicate hits (ie a sample with multiple efflux pumps hits or aminoglycoside hits - so there is only one aminoglycoside count "presnet" for each sample)
ISOResults.FIN.df <- ISOResults.FIN.df %>% drop_na(AMRclass)
ISOResults.Isolate.freq <- ISOResults.FIN.df %>% group_by(Species,SPECIES_TOTAL) %>% 
  dplyr::count(AMRclass) %>% 
  mutate(freq = n / SPECIES_TOTAL * 100) # divided by the number of isoaltes 

Species.Matrix <- acast(ISOResults.Isolate.freq, AMRclass ~ Species, value.var="freq")
Species.Matrix[is.na(Species.Matrix)] <- 0

rownames(DeIsoCount) <-DeIsoCount$Species
IsoCount.matrix<- DeIsoCount[-2]

pheatmap(Species.Matrix, 
         color = c("white","#FFF38F", "#FDEA45" ,"#91B959" , "#248A8D","#344571","#440054"),
         breaks = c(0,1,10, 20, 40,60, 80, 100),
         border_color = F,
         #annotation_row =  AroANN.prev,
         annotation_col = IsoCount.matrix,
         fontsize_row = 10, fontsize_col = 10)
