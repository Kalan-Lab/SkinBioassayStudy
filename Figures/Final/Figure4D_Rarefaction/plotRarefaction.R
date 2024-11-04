library(ggplot2)

dat <- read.table("Rarefaction_Results.txt", header=T, sep='\t')
# BodySite        CumulativeDepth GCFsDiscovered

colors <- c("#D53E4F", "#F46D43", "#FDAE61", "#FEE08B", "#E6F598", "#ABDDA4", "#66C2A5", "#3288BD")
names(colors) <- c ("Moist_Na", "Moist_Tw", "Moist_Um", "Rarely_Moist_Af", "Rarely_Moist_Vf", "Sebaceous_Al", "Sebaceous_Ba", "Sebaceous_Oc")

pdf("Rarefaction_Results.pdf", height=3, width=5)
ggplot(dat, aes(x=CumulativeDepth, y=GCFsDiscovered, color=BodySite)) + geom_line() + geom_point() + theme_bw() + scale_color_manual(values=colors) + xlab('Sequencing Depth') + ylab('Number of GCFs Discovered')
dev.off()
