# Load library
library(ggplot2)
library(dplyr)

color <- c("#355070", "#6D597A" ,"#B56576", "#E56B6F", "#EAAC8B", "#F1E9DA")

# Create the data frame
data <- data.frame(
  Sample = factor(rep(c("Helcobacillus massiliensis LK130", "Microbacterium sp. LK369", "Micrococcus luteus LK1117"), each=3)),
  Dose = factor(rep(c("0", "200", "400"), 3), levels=c("0", "200", "400")),
  Starting = rep(c(4.38, #LK130
                   4.12, #LK369
                   4.23), #LK1117
                 each=3),
  Change = c(0.84, -0.28, -0.39, # LK130
             0.97, -0.75, -1.25, # LK369
             1.21, -0.17, -0.34), # LK1117
  Ending = c(5.22, 4.10, 3.99, # LK130
             5.09, 3.37, 2.87, # LK369
             5.44, 3.48, 2.98) #LK1117
)

data %>%
  mutate(Sample = factor(Sample, levels = c("Micrococcus luteus LK1117", "Microbacterium sp. LK369", "Helcobacillus massiliensis LK130"))) %>%
  ggplot(aes(x=Dose, y=Ending)) +
  geom_bar(stat="identity", fill="#355070") +
  geom_hline(data=data.frame(Sample=c("Micrococcus luteus LK1117", "Microbacterium sp. LK369", "Helcobacillus massiliensis LK130"), yint=c(4.23, 4.12, 4.38)),
             aes(yintercept=yint), linetype="dashed", color="#E56B6F") +
  labs(x="Active fraction (uL)", y="Log10 CFU/mL") +
  facet_wrap(~Sample) +
  theme_classic(base_size = 18) +
  ylim(0, max(data$Ending) + 0.5) +
  theme(strip.text = element_text(face = "bold.italic"))


data %>%
  mutate(Sample = factor(Sample, levels = c("Micrococcus luteus LK1117", "Microbacterium sp. LK369", "Helcobacillus massiliensis LK130"))) %>%
  ggplot(aes(x=Dose, y=Change, fill = Dose)) +
  geom_bar(stat="identity") +
  scale_fill_manual(values = c("#dddddd", "#777777", "#222222")) +
  geom_hline(yintercept=0, linetype="solid", color="black") + 
  labs(x="Active fraction (uL)", y="Change in Log10 CFU/kidney") +
  facet_wrap(~Sample) +
  theme_classic(base_size = 18) +
  #ylim(-0.5, 0.84) +
  theme(strip.text = element_text(face = "bold.italic"),
        axis.text.x = element_text(size = 18),
        axis.text.y = element_text(size = 18),
        legend.position = "none")

