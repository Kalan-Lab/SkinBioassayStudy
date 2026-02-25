data <- read.csv("/Users/thynguyen/Documents/GitHub/SkinBioassayStudy/Figures/Final/Figure2/Data/scat_plot_updated2.csv")
library(ggplot2)
library(ggbreak)
colors = c("#b1728f","#38761d","#493C61","#517391")
data1 <- data %>%
  filter(phylum != "Fungi") 

ggplot(data1, aes(x=iso_abun, y=met_abun, color = phylum)) + 
  scale_x_continuous(trans='log10') +
  scale_y_continuous(trans='log10') +
  xlab("Isolate Relative Abundance") + 
  ylab("Metagenomic Relative Abundance") +
  geom_text(label = data1$genus, hjust=0, vjust=0) +
  geom_jitter() + 
  scale_colour_manual(values = colors)

