#https://jkzorz.github.io/2019/06/05/stacked-bar-plots.html
library(ggplot2)

data <- read.table("Plot_Input.txt",header = TRUE, sep='\t')

#updated color palette 03/07/2023           
colors <- c("#8DD3C7", "#A6DCC2", "#BFE6BE", "#D8F0B9", "#F1F9B5", "#F8F8B6", "#EAE8BF", "#DBD9C8", "#CDCAD0", "#BFBBD9", "#CAAEC5", "#D7A1AE", "#000000", "#84AFCF", "#E59497", "#F28880", "#F18379", "#D68E8F", "#BB99A4", "#96B1BE", "#B2B2A5", "#CDB28C", "#E8B374", "#F8B662", "#E8BF63", "#D8C965", "#C7D267", "#B7DB68", "#BEDB7C", "#CED798", "#DED3B3", "#EED0CE", "#FACDE4", "#F2D0E1", "#EBD2DF", "#E3D5DC", "#DBD8D9", "#D4CCD5", "#CEB8CE", "#C8A5C8", "#C191C2", "#BC82BD", "#BF99BE", "#C3B1C0", "#C6C8C2", "#CAE0C4", "#D2EBBA", "#DDEBA7", "#E8EC94", "#F3EC81", "#FFED6F")

names(colors) <- c ("acyl_amino_acids", "arylpolyene", "betalactone", "blactam", "bottromycin", "butyrolactone", "CDPS", "cyclic-lactone-autoinducer", "ectoine", "epipeptide", "hglE-KS", "hserlactone", "multi-type", "ladderane", "lanthipeptide-class-i", "lanthipeptide-class-ii", "lanthipeptide-class-iii", "lanthipeptide-class-iv", "lanthipeptide-class-v", "LAP", "lassopeptide", "linaridin", "microviridin", "NA", "NAGGN", "NAPAA", "NRPS", "NRPS-like", "nucleoside", "phenazine", "phosphonate", "PKS-like", "proteusin", "ranthipeptide", "RaS-RiPP", "redox-cofactor", "resorcinol", "RiPP-like", "RRE-containing", "sactipeptide", "siderophore", "T1PKS", "T2PKS", "T3PKS", "terpene", "thioamide-NRP", "thioamitides", "thiopeptide", "transAT-PKS", "transAT-PKS-like", "tropodithietic-acid")


mx = ggplot(data, aes(x = Body_Site, fill = Product.Prediction, y = rel_abun)) + 
  geom_bar(stat = 'identity',colour = "black") + 
  facet_grid(~Site.Type, scales="free_x", space = "free_x", labeller=labeller(facet_category = label_wrap_gen(width=10))) +
  theme(axis.text.x = element_text(angle = 45,size = 10, colour = "black", hjust = 1), 
        axis.title.y = element_text(size = 16, face = "bold"), legend.title = element_text(size = 16, face = "bold"), 
        legend.text = element_text(size = 10, colour = "black"), 
        axis.text.y = element_text(colour = "black", size = 12, face = "bold"),
        strip.text = element_text(size = 10, face = "bold")) + 
  labs(x = "", y = "Product Count", fill = "Product Prediction") +
  scale_fill_manual(values = colors)
ggsave(file="bgc_by_site_210129.pdf", width=12, height=7, dpi=300)
