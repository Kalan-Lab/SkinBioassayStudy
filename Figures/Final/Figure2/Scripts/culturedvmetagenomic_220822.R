library(ggplot2)
library(reshape)
#https://www.color-hex.com/color/27408b
#https://docs.google.com/spreadsheets/d/1HAW4JoB0Ug6E0jn2avPh8qDRNyBXBX5x-D6ApyCfYZo/edit#gid=0

colors = c('808080',
           "#b1728f","#c89cb0","#dfc6d2","#efe2e8",
           "#E69138","#edb273","#f5d3af","#fae9d7",
           "#bc3e47","#d0777e","#e4b1b5","#f1d8da",
           "#CBA92B","#dac26a","#eadcaa","#f4edd4",
           "#493C61","#38761d","#739f60","#afc8a4",
           "#d7e3d1","#073763","#517391","#9bafc0",
           "#cdd7df")

data= read.csv("/Users/shelbysandstrom/Documents/GitHub/Kalan_Lab/scripts/ssandstrom/paper_figures/culturedvmetagenomic/metagenomic_data_cleaning/collapsed.csv",header=TRUE)
data$genus <- factor(data$genus, levels = c("Other",
                                            "Cutibacterium","Corynebacterium",
                                            "Micrococcus","Kocuria","Rothia",
                                            "Brevibacterium","Gordonia",
                                            "Dermabacter","Kytococcus",
                                            "Janibacter","Dietzia",
                                            "Microbacterium","Brachybacterium",
                                            "Dermacoccus","Nesterenkonia",
                                            "Pseudoclavibacter","Sphingobacterium",
                                            "Staphylococcus","Bacillus","Granulicatella",
                                            "Enterococcus","Klebsiella","Citrobacter",
                                            "Escherichia","Enterobacter"
                                            ))

data$body_site <- factor(data$body_site, levels = c("Al","Ba","Oc",
                                                    "Na","Um","Tw","Vf","Af"
                                                    
))
ggplot(data, aes(x = dataset, fill = genus, y = rel_abun)) +
  ylab("Relative Abundance") +
  labs(fill="Genus") +
  geom_bar(stat = 'identity', show.legend = FALSE) +
  facet_wrap(~body_site, scales='free') +
  scale_x_discrete(labels= c("C","M")) +
  theme(axis.title.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y = element_text(size = 10, face = "bold"),
        legend.title = element_text(size = 10, face = "bold"), 
        legend.text = element_text(size = 7, colour = "black"),
        axis.text.y = element_text(colour = "black", size = 9)) +
  scale_fill_manual(values = colors)
ggsave("/Users/shelbysandstrom/Documents/GitHub/Kalan_Lab/scripts/ssandstrom/paper_figures/culturedvmetagenomic/culturedvmetgenomic_210316.pdf", width=15, height=10, dpi=300)  
