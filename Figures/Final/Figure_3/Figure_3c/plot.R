library(ggplot2)

dat <- read.table('Boxplot_Input.txt', header=T, sep='\t')
#Target  Isolate SummmaryScore   NumberTested    IsolateGenus    IsolatePhylum


fills <- c('#b1728f', '#38761d', '#073763', '#493C61')
names(fills) <- c('Actinomycetota', 'Bacillota', 'Pseudomonadota', 'Bacteroidota')

pdf('Boxplot_Summary_Scores.pdf', height=10, width=25)

ggplot(dat, aes(x=reorder(IsolateGenus, SummmaryScore, FUN=median), y=SummmaryScore, fill=IsolatePhylum, color=IsolatePhylum)) + xlab("Genus") + ylab("Summarized Inhibition Score") + geom_jitter(aes(size=NumberTested), alpha=0.3) + geom_boxplot(alpha=0.5, outlier.shape=NA) + theme_classic() + theme(legend.position='bottom') + theme(text = element_text(size=25), axis.text.x = element_text(angle = 60, vjust = 1, hjust=1)) + scale_fill_manual(values=fills) + scale_color_manual(values=fills) + facet_wrap(~Target, ncol=1)

dev.off()
