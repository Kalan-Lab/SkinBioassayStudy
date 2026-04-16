library(ggplot2)

dat <- read.table("Distance_to_Closest_Matching_GCFs.txt", header=T, sep='\t')

pdf("Distance_to_Closest_BiG-FAM_GCF.pdf", height=3, width=7)
ggplot(dat, aes(x=dist, fill=group)) + geom_histogram(color='black') + theme_bw() + scale_fill_manual(values=c('#7a1a1b', '#de8b26'))
dev.off()
