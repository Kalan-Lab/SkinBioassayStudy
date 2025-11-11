library(ggplot2)
library(ggrepel)

dat <- read.table("BGCome_Size_vs_Antifungal_Score.txt", sep="\t", header=T)
# genus   mean_antifungal_score   isolate_count   avg_rel_abd     avg_bgcome_size

coloring <- c('#a578ab', '#869e9c', '#a3a0a0')
names(coloring) <- c('prev_and_abd', 'prev', 'other')

pdf("BGCome_Size_vs_Antifungal_Score.pdf", height=5, width=7)
ggplot(dat, aes(y=mean_antifungal_score, x=avg_bgcome_size, label=label)) + geom_point(aes(size=isolate_count, color=coloring)) + scale_color_manual(values=coloring)  + theme_bw() + xlab("Mean BGC-ome Size (bp)") + ylab("Mean Fungal Antagonism Score") + theme(text = element_text(size=20)) #+ geom_text_repel(aes(color=coloring)
dev.off()
