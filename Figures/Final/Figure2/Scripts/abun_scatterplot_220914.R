data <- read.csv("/Users/shelbysandstrom/Documents/GitHub/Kalan_Lab/scripts/ssandstrom/paper_figures/culturedvmetagenomic/scat_plot.csv")
library(ggplot2)
library(ggbreak)
colors = c("#b1728f","#38761d","#493C61","#517391")
ggplot(data, aes(x=iso_abun, y=met_abun, color = Phylum)) + 
  scale_x_continuous(trans='log10') +
  scale_y_continuous(trans='log10') +
  xlab("Isolate Relative Abundance") + 
  ylab("Metagenomic Relative Abundance") +
  geom_text(label = data$Genus, hjust=0, vjust=0) +
  geom_jitter() + 
  scale_colour_manual(values = colors)

