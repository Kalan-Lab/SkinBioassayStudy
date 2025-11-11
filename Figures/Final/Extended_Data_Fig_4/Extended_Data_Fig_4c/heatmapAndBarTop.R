library(viridis)
library(ggplot2)
library(cowplot)

brack.dat <- read.table('Top_Genera_per_Sample.txt', header=T, sep='\t')
#Sample  SampleSubject   SampleBodySite  Taxa    Estimated_Reads

bgc.dat <- read.table('Input_for_Heatmap_Figure.txt', header=T, sep='\t')
#sample  bgc_class       abundance       abundance_normalized    sample_subject  sample_bodysite

tax.colors <- c('#dfc6d2', '#c89cb0', '#b1728f', '#38761d', '#828382')

names(tax.colors) <- c('Micrococcus', 'Corynebacterium', 'Cutibacterium', 'Staphylococcus', 'Other')

pdf("BiG-MAP_Core_NormRPKM_Core_Kalan_Metagenomes.pdf", height=17, width=15)
g1 <- ggplot(bgc.dat, aes(x=sample_subject, y=bgc, fill=rpkm_norm)) + geom_tile() + theme_classic() + scale_fill_viridis(option="magma", na.value='grey') + facet_grid(bgc_class~sample_bodysite, scale='free', space='free') + theme(legend.position="bottom", axis.text.x=element_blank(), axis.text.y=element_blank()) + xlab("Metagenomic Samples") + ylab("BGC Classes") + theme(strip.text.y.right = element_text(angle = 0))
print(g1)
#g2 <- ggplot(brack.dat, aes(x=SampleSubject, y=Estimated_Reads, fill=Taxa)) + geom_bar(stat='identity') + theme_classic() + facet_wrap(~SampleBodySite, ncol=9, scale='free_x') + ylab("Bracken Breakdown") + theme(axis.text.x=element_blank()) + scale_fill_manual(values=tax.colors)+ theme(legend.position="top") 
#print(g1)
#plot_grid(g2, g1, rel_heights=c(0.15, 0.7), align='v', axis='lr', ncol=1)
dev.off()
