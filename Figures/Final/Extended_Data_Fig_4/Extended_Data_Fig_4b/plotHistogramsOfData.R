library(ggplot2)
library(RColorBrewer)
library(cowplot)

dat.full <- read.table('Tabulated_Full_Analyse_Results.txt', header=T, sep='\t')
dat.core <- read.table('Tabulated_Core_Analyse_Results.txt', header=T, sep='\t')

dat.full <- dat.full[dat.full$coverage > 0.0,]
dat.full <- dat.full[dat.full$rpkm_norm > 0.0,]
dat.core <- dat.core[dat.core$coverage > 0.0,]
dat.core <- dat.core[dat.core$rpkm_norm > 0.0,]

pdf('Parameter_Selection_for_BiG-MAP_for_legend.pdf', height=5, width=10)
g1 <- ggplot(dat.full, aes(x=rpkm_norm, fill=sample_bodysite)) + geom_histogram(color='black', show.legend=F) + theme_classic() + scale_x_log10() + ggtitle("Full - RPKM normalized (log-scale)") + scale_fill_brewer(palette='Spectral') + xlab('') + theme(legend.position='bottom')
g2 <- ggplot(dat.full, aes(x=coverage, fill=sample_bodysite)) + geom_histogram(color='black', show.legend=F) + theme_classic() + ggtitle("Full - Coverage") + scale_fill_brewer(palette='Spectral') + xlab('')
g3 <- ggplot(dat.core, aes(x=rpkm_norm, fill=sample_bodysite)) + geom_histogram(color='black', show.legend=F) + theme_classic() + scale_x_log10() + ggtitle("Core - RPKM normalized (log-scale)") + scale_fill_brewer(palette='Spectral') + xlab('')
g4 <- ggplot(dat.core, aes(x=coverage, fill=sample_bodysite)) + geom_histogram(color='black', show.legend=F) + theme_classic() + ggtitle("Core - Coverage") + scale_fill_brewer(palette='Spectral') + xlab('')
#print(g1)
plot_grid(g1, g2, g3, g4, ncol=2)
dev.off()
