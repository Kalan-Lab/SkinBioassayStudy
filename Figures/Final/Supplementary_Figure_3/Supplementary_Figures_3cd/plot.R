library(ggplot2)

dat <- read.table("HAD_Proportion_by_Site_Type.txt", header=T, sep='\t')

pdf("HAD_Proportion_by_Site_Type.pdf", height=4, width=4)
ggplot(dat, aes(x=site_type, y=had_proportion)) + geom_boxplot(fill='grey', color='black') + theme_bw() + theme(text = element_text(size = 20))
dev.off()
