library(pheatmap)
library(RColorBrewer)
data = read.csv("/Users/shelbysandstrom/Documents/rgi/staphylococcus_heatmap.csv")
gene <- data$gene
genes <- gene[1:39]
#site <- data$Body.Site
cols = c("#440154FF",'#238A8DFF','#FDE725FF')
heatmap = data[1:39,2:62]
theatmap = as.data.frame(t(heatmap))
colnames(theatmap)=genes

#heatmap
hm = pheatmap(theatmap,color = cols, show_rownames = T,fontsize_col=5,fontsize_row=5,
              show_colnames = T,
              width = 10,
              height = 10,
              cluster_rows = T,
              cluster_cols = T,
              legend_breaks = c(0.33,1,1.66),
              legend_labels=c("No hit","Strict hit","Perfect hit"))
hm
ggsave(file="/Users/shelbysandstrom/Documents/GitHub/Kalan_Lab/scripts/ssandstrom/jupyter/bioassay_heatmap/heatmap_wo_metadata_200225.pdf", width=10, height=7, dpi=300)
