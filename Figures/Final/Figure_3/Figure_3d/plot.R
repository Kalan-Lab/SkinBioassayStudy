library(ggplot2)

dat <- read.table('Boxplot_Input_with_Sample_Size.txt', header=T, sep='\t')
#Target  Isolate SummmaryScore   NumberTested    IsolateGenus    IsolatePhylum

fills <- c('#b1728f', '#38761d', '#073763', '#493C61')
names(fills) <- c('Actinomycetota', 'Bacillota', 'Pseudomonadota', 'Bacteroidota')

pdf('Boxplot_Summary_Scores.pdf', height=15, width=22.5)

ggplot(dat, aes(x=reorder(IsolateGenus_with_SampleSize, SummmaryScore, FUN=median), y=SummmaryScore, fill=IsolatePhylum, color=IsolatePhylum)) + xlab("Genus") + ylab("Summarized Inhibition Score") + geom_jitter(alpha=0.3, size=3) + geom_boxplot(alpha=0.5, outlier.shape=NA) + theme_classic() + theme(legend.position='bottom') + theme(text = element_text(size=21), axis.text.x = element_text(angle = 70, vjust = 1, hjust=1)) + scale_fill_manual(values=fills) + scale_color_manual(values=fills) + facet_wrap(~Target, ncol=1)

dev.off()
