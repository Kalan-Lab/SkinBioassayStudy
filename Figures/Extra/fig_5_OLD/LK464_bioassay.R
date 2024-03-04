---
title: "LK469 heatmap"
output: html_document
---

#loading packages
library(pheatmap)
library(RColorBrewer)
library(dplyr)

data = read.csv("/Users/unguyen2/Documents/GitHub/Kalan_Lab/scripts/ssandstrom/skin_bioassay_paper_files/fig_3/bioassay_data_new_wide.csv")
#genera <- data$Genus
#site <- data$Body.Site

data = data[!duplicated(data$Pathogen_Name),]
paths <- data$Pathogen_Name
paths1 <- c("Bacillus cereus ", "Bacillus subtilis ",
            "Enterococcus faecalis ", "Micrococcus luteus ",
            "Mycobacterium smegmatis ", "Norcardia corynebacteroides ",
            "Staphylococcus aureus", "Staphylococcus epidermidis ",
            "Acinetobacter baumannii ", "Citrobacter freundii ",
            "Enterobacter cloacae ", "Escherichia coli ",
            "Klebsiella oxytoca ", "Proteus vulgaris ",
            "Pseudomonas aeruginosa (PAO1)", "Pseudomonas aeruginosa 27873",
            "Serratia marcescens 8055", "Aspergillus flavus ",
            "Candida albicans (K1)", "Candida sp. ",
            "Cryptococcus neoformans", "Trichosporon asahii ")
data$Pathogen_Name <- factor(data$Pathogen_Name, levels = paths1)
path_type <- c("Gram-positive", "Gram-negative", "Fungal")
data$Pathogen_Type <- factor(data$Pathogen_Type, levels = path_type)
#cols = c("#D3D3D3",'#ffd5e1','#e79bb2','#cc6183')
heatmap = data[ ,c("LK464")]
theatmap = as.data.frame(t(heatmap))
colnames(theatmap)=paths
theatmap1 <- theatmap[, paths1]

#color lists
ann_colors = list(Pathogen_Type = c("Gram-positive" = "#FF0000","Gram-negative" = "#0000FF", "Fungal" = "#008000"),
                  Genus = c("Cutibacterium"="#b1728f",
                            "Corynebacterium"="#c89cb0",
                            "Micrococcus"="#dfc6d2",
                            "Kocuria"="#efe2e8",
                            "Rothia"="#E69138",
                            "Brevibacterium"="#edb273",
                            "Gordonia"="#f5d3af",
                            "Dermabacter"="#fae9d7",
                            "Kytococcus"="#bc3e47",
                            "Janibacter"="#d0777e",
                            "Dietzia"="#e4b1b5",
                            "Microbacterium"="#f1d8da",
                            "Brachybacterium"="#CBA92B",
                            "Dermacoccus"="#dac26a",
                            "Nesterenkonia"="#eadcaa",
                            "Pseudoclavibacter"="#f4edd4",
                            "Sphingobacterium"="#493C61",
                            "Staphylococcus"="#38761d",
                            "Bacillus"="#739f60",
                            "Granulicatella"="#afc8a4",
                            "Enterococcus"="#d7e3d1",
                            "Klebsiella"="#073763",
                            "Citrobacter"="#517391",
                            "Escherichia"="#9bafc0",
                            "Enterobacter"="#cdd7df",
                            "Other" = "808080"),
                  Body_Site = c("Nares"="#D53E4F",
                                "Toe web space"="#F46D43",
                                "Umbilicus"="#FDAE61",
                                "Antecubital fossa"="#FEE08B",
                                "Volar forearm"="#E6F598",
                                "Alar crease"="#ABDDA4",
                                "Back"="#66C2A5",
                                "Occiput"="#3288BD"))


#col annotations for site
annotation_col = data.frame(Pathogen_Type = data$Pathogen_Type, Pathogen_Name = data$Pathogen_Name)
rownames(annotation_col) = annotation_col$Pathogen_Name
annotation_col <- select(annotation_col, -2)

hm = pheatmap(theatmap1, show_rownames = F,fontsize_col=14,
              annotation_col = annotation_col,
              annotation_row = annotation_rows,
              annotation_colors = ann_colors,
              color = c("#808080","#e6d8df","#b48a9f","#833d60"),
              show_colnames = T,
              width = 10,
              height = 10,
              cluster_rows = F,
              cluster_cols = FALSE,
              angle_col = 90,
              legend_breaks = c(-.66,.15,.85,1.66),
              legend_labels=c("no data","no inhibition","zone of inhibition","full inhibition"),annotation_legend = T)

