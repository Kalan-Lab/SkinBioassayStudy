library(ggplot2)

dat <- read.table("Rarefaction_Results.With_Permutations.txt", header=T, sep='\t')
# BodySite        CumulativeDepth GCFsDiscovered

colors <- c("#D53E4F", "#F46D43", "#FDAE61", "#FEE08B", "#E6F598", "#ABDDA4", "#66C2A5", "#3288BD")
names(colors) <- c ("Moist_Na", "Moist_Tw", "Moist_Um", "Rarely_Moist_Af", "Rarely_Moist_Vf", "Sebaceous_Al", "Sebaceous_Ba", "Sebaceous_Oc")

pdf("Rarefaction_Results_with_Permutation.pdf", height=5, width=20)
ggplot(dat, aes(x=CumulativeDepth, y=GCFsDiscovered, color=BodySite, fill=BodySite)) + geom_boxplot(alpha=0.5, aes(weight=1)) + theme_bw() + scale_color_manual(values=colors) + scale_fill_manual(values=colors) + xlab('Sequencing Depth') + ylab('Number of GCFs Discovered') + facet_grid(.~BodySite, space='free_x', scales='free_x') + theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))
dev.off()
