data <- read.csv("/Users/thynguyen/Documents/GitHub/SkinBioassayStudy/Figures/Final/Figure2/Data/scat_plot_updated1.csv")
library(ggplot2)
library(ggbreak)
colors = c("#b1728f","#38761d","#493C61","#517391")
ggplot(data, aes(x=iso_abun, y=met_abun, color = phylum)) + 
  scale_x_continuous(trans='log10') +
  scale_y_continuous(trans='log10') +
  xlab("Isolate Relative Abundance") + 
  ylab("Metagenomic Relative Abundance") +
  geom_text(label = data$genus, hjust=0, vjust=0) +
  geom_jitter() + 
  scale_colour_manual(values = colors) +
  geom_smooth(method = "lm", color = "black", linetype = "dashed", se = TRUE, alpha = 0.2) +
  stat_cor(
    method = "spearman",
    label.x.npc = 0.1,  
    label.y.npc = 1, 
    size = 5,   
    color = "black" 
  )

