library(ggplot2)

dat <- read.table("Metagenome_Mapping_Stats.txt", header=T, sep='\t')

# metagenome      body_site       body_site_type  database        value

png("Bowtie2_Metagenome_to_Isolate_Genomes.png", res=600, units='in', height=3.5, width=7)
ggplot(dat, aes(x=body_site_type, y=value, fill=database)) + geom_boxplot(color='black') + theme_bw() + scale_fill_manual(values=c('#FFFFFF', '#d9d8d7', '#bfbebd', '#737373', '#5e5e5e', '#302f2f')) + xlab("Body site type") + ylab("Bowtie 2 overall alignment rate %")
dev.off()
