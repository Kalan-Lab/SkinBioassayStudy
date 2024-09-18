library(igraph)

# set seed for reproducability
set.seed(12345)

nodes.dat <- read.table("nodes.txt", header=T, sep='\t')
edges.dat <- as.data.frame(read.table("edges.txt", header=T, sep='\t'))
cat.dat <- as.list(read.table("pie.txt", header=T, sep='\t', row.names=1))

gcf.cols <- list(c('#b02c3b', '#376bab', '#e0a734'))

g <- graph_from_data_frame(edges.dat, directed=F, vertices=nodes.dat)
layout <- layout_nicely(g, weights=E(g)$weight/30)

pdf("Network.pdf", height=10, width=10) 
par(bg="white")

plot(g, layout=layout, vertex.shape='pie', vertex.pie.color=gcf.cols, vertex.pie=cat.dat, vertex.frame.color=NA, vertex.size=(2*V(g)$num_samples), edge.color='grey', edge.width=E(g)$weight/2, vertex.label=NA)#V(g)$label)

dev.off()

