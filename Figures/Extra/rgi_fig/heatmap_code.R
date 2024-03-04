library(pheatmap)
library(RColorBrewer)
data = read.csv("/Users/shelbysandstrom/Documents/rgi/210603_heatmap_meta_red.csv")
Gene <- data$gene
#site <- data$Body.Site
cols = c("#440154FF",'#238A8DFF','#FDE725FF')
heatmap = data[c(2:200)]
theatmap = as.data.frame(t(heatmap))
colnames(theatmap)=Gene

#col annotations for site
#annotation_col = data.frame(Taxonomic_ID = genus)
#rownames(annotation_col) = LK

#row annotaions body_site
annotation_row = read.csv('/Users/shelbysandstrom/Documents/rgi/row_annoation_red.csv')
strains <- annotation_row$gene
genus <- annotation_row$Taxonomic_ID
rownames(annotation_row) = strains
annotation_rows = data.frame(Genus=genus)
rownames(annotation_rows) = strains

#color lists
ann_colors = list(Genus = c('Aerococcus'='#972a5a','Aestuariimicrobium'='#b6698b','Anthrobacter'='#d5a9bd',
                            'Bacillus'='#ead4de','Brachybacterium'='#3c1361','Brevibacterium'='#775293',
                            'Cellulosimicrobium'='#b294c7','Citrobacter'='#f0dbfe','Corynebacterium'='#FF8C00',
                            'Dermabacter'='#ffae4c','Dermacoccus'='#ffd199','Dietzia'='#ffe8cc',
                            'Enterobacter'='#156b6b','Escherichia'='#5B9797','Gordonia'='#A1C3C3',
                            'Granulicatella'='#D0E1E1','Helcobacillus'='#27408b','Helcococcus'='#6779ad',
                            'Janibacter'='#a8b2d0','Klebsiella'='#d3d8e7','Kocuria'='#da5886',
                            'Lysinibacillus'='#e58aaa','Microbacterium'='#f0bcce','Micrococcus'='#f7dde6',
                            'Micromonospora'='#4b894b','Morganella'='#81ac81','Nesterenkonia'='#b7cfb7',
                            'Oceanobacillus'='#dbe7db','Paenibacillus'='#ad7263','Propionibacterium'='#C59C91',
                            'Raoultella'='#DEC6C0','Serratia'='#EEE2DF',
                            'Sphingobacterium'='#000000','Staphylococcus'='#2F4F4F','Zimmermannella'='#778899'))

#heatmap
hm = pheatmap(theatmap,color = cols, show_rownames = F,fontsize_col=5,fontsize_row=5,
              #annotation_col = annotation_col,
              annotation_row = annotation_rows,
              annotation_colors = ann_colors,
              show_colnames = T,
              width = 10,
              height = 10,
              cluster_rows = T,
              cluster_cols = T,
              legend_breaks = c(0.33,1,1.66),
              legend_labels=c("No hit","Strict hit","Perfect hit"),annotation_legend = T)
hm
ggsave(file="/Users/shelbysandstrom/Documents/GitHub/Kalan_Lab/scripts/ssandstrom/jupyter/bioassay_heatmap/heatmap_wo_metadata_200225.pdf", width=10, height=7, dpi=300)
