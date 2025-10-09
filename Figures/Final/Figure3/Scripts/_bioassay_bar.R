library(ggplot2)
library(reshape2)

#data = read.csv("/Users/thynguyen/Documents/GitHub/SkinBioassayStudy/Figures/Final/Figure4/Data/stacked_bar_bioassay.csv")
#dm = melt(data)
#data$Inhibition <- factor(data$Inhibition,levels=c("None","Partial","Complete"))

data <- read.csv("/Users/thynguyen/Documents/GitHub/SkinBioassayStudy/Figures/Final/Figure3/Data/bioassay_data_new_wide_updated.csv")

data_transformed <- data %>%
  pivot_longer(cols = starts_with("LK"), names_to = "LK", values_to = "Score") %>%
  mutate(Inhibition = case_when(
    Score == -1 ~ "ND",
    Score == 0 ~ "None",
    Score == 1 ~ "Partial",
    Score == 2 ~ "Complete",
    TRUE ~ NA_character_
  )) %>%
  # Group and count
  group_by(Pathogen_Name, Pathogen_Type, Inhibition) %>%
  summarise(Count = n(), .groups = "drop") %>%
  group_by(Pathogen_Name, Pathogen_Type) %>%
  mutate(label_ypos = cumsum(Count) - 0.5 * Count,
         label_ypos = ifelse(Inhibition == "Partial", label_ypos - 280, label_ypos)) %>%
  ungroup()

colors <- c("#dfc6d2","#c89cb0","#b1728f")

data_transformed %>%
  filter(Inhibition != "ND") %>%
  mutate(Inhibition = factor(Inhibition, levels = c("None", "Partial", "Complete"))) %>%
  ggplot(aes(x=Pathogen_Name, y=Count, fill=Inhibition)) +
  geom_bar(stat="identity")+
  facet_grid(~Pathogen_Type, scales="free_x", space = "free_x") +
  geom_text(aes(y=label_ypos,label=Count), vjust=1.6, 
            color="white", size=2.5)+
  scale_fill_manual(values = colors)+
  theme_minimal() +
  #theme_dark() +
  theme(axis.title.y = element_text(size = 10, face = "bold", color = 'black'),
        legend.title = element_text(size = 10, face = "bold", color = 'black'), 
        #legend.text = element_text(size = 10, color = 'white'), 
        #axis.text.y = element_text(color = 'white', size = 9),
        #axis.title.x = element_text(size = 10, face = "bold", color = 'white'),
        axis.text.x = element_text(size=10,angle = 45, color = 'black',hjust=0.95,vjust=1),
        #plot.background = element_rect(fill = "black"),
        strip.text = element_text(size = 10, face = "bold")
        #legend.background = element_rect(fill = "black")
  ) +
  labs(x = "", 
       y = "Number of Isolates")
  

  