#https://jkzorz.github.io/2019/06/05/stacked-bar-plots.html
library(ggplot2)

data = read.csv("/Users/unguyen2/Documents/GitHub/Kalan_Lab/scripts/ssandstrom/skin_bioassay_paper_files/fig_4/genomes_per_site_by_genus_220915.csv",header = TRUE)

#color list
colors = c('808080',
           "#b1728f",
           "#c89cb0",
           "#dfc6d2",
           "#efe2e8",
           "#E69138",
           "#edb273",
           "#f5d3af",
           "#fae9d7",
           #"#bc3e47",
           "#d0777e",
           "#e4b1b5",
           "#f1d8da",
           "#CBA92B",
           "#dac26a",
           "#eadcaa",
           "#f4edd4",
           "#493C61",
           "#38761d",
           #"#739f60",
           "#afc8a4",
           "#d7e3d1",
           "#073763",
           "#517391",
           "#9bafc0",
           "#cdd7df")

data$genus <- factor(data$genus, levels = c("Other",
                                            "Cutibacterium",
                                            "Corynebacterium",
                                            "Micrococcus",
                                            "Kocuria",
                                            "Rothia",
                                            "Brevibacterium",
                                            "Gordonia",
                                            "Dermabacter",
                                            "Kytococcus",
                                            "Janibacter",
                                            "Dietzia",
                                            "Microbacterium",
                                            "Brachybacterium",
                                            "Dermacoccus",
                                            "Nesterenkonia",
                                            "Pseudoclavibacter",
                                            "Sphingobacterium",
                                            "Staphylococcus",
                                            "Bacillus",
                                            "Granulicatella",
                                            "Enterococcus",
                                            "Klebsiella",
                                            "Citrobacter",
                                            "Escherichia",
                                            "Enterobacter"))

# reorder factors
data$Body_Site <- factor(data$Body_Site, levels = c("Nares", "Toe web space","Umbilicus","Alar crease","Occiput","Back","Volar forearm","Antecubital fossa"))
#reorder facet_grid
data$Site.Type = factor(data$Site.Type, levels=c("Sebaceous","Moist","Rarely Moist"))
ggplot(data, aes(x = Body_Site, fill = genus, y = rel_abun)) + 
  geom_bar(stat = 'identity',colour = "black") + 
  facet_grid(~Site.Type, scales="free_x", space = "free_x") +
  theme(axis.text.x = element_text(angle = 45, face = "bold",size = 10, colour = "black", hjust = 1), 
        axis.title.y = element_text(size = 16, face = "bold"),
        axis.title.x = element_text(size = 16, face = "bold"),
        legend.title = element_text(size = 16, face = "bold"), 
        legend.text = element_text(size = 10, colour = "black"), 
        axis.text.y = element_text(colour = "black", size = 12, face = "bold"),
        strip.text = element_text(size = 15, face = "bold")) + 
  labs(x = "Body Site", y = "Genome Count", fill = "Genus") + 
  scale_fill_manual(values = colors)

ggsave(file="/Users/shelbysandstrom/Documents/GitHub/Kalan_Lab/scripts/ssandstrom/paper_figures/genomes_per_site_by_genus/genomes_per_site_by_genus.pdf", width=10, height=7, dpi=300)

