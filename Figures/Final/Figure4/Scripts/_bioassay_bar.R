library(ggplot2)
library(reshape2)

data = read.csv("/Users/unguyen2/Documents/GitHub/Kalan_Lab/scripts/ssandstrom/paper_figures/bioassay/stacked_bar_bioassay.csv")
#dm = melt(data)
data$Inhibition <- factor(data$Inhibition,levels=c("None","Partial","Complete"))

colors = c("#dfc6d2","#c89cb0","#b1728f")


ggplot(data, aes(x=Pathogen_Name, y=Count, fill=Inhibition)) +
  geom_bar(stat="identity")+
  facet_grid(~Pathogen_Type, scales="free_x", space = "free_x") +
  #geom_text(aes(y=label_ypos_2,label=Count), vjust=1.6, 
            #color="white", size=2.5)+
  scale_fill_manual(values = colors)+
  theme_minimal() +
  #theme_dark() +
  theme(axis.title.y = element_text(size = 10, face = "bold", color = 'black'),
        legend.title = element_text(size = 10, face = "bold", color = 'black'), 
        #legend.text = element_text(size = 10, color = 'white'), 
        #axis.text.y = element_text(color = 'white', size = 9),
        #axis.title.x = element_text(size = 10, face = "bold", color = 'white'),
        axis.text.x = element_text(size=10,angle = 45, color = 'black',hjust=0.95,vjust=1)
        #plot.background = element_rect(fill = "black"),
        #strip.text = element_text(size = 10, face = "bold",color='white'),
        #legend.background = element_rect(fill = "black")
  )
  

  