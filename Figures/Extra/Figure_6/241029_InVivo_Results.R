# Load library
library(ggplot2)

color <- c("#355070", "#6D597A" ,"#B56576", "#E56B6F", "#EAAC8B", "#F1E9DA")

# Create the data frame
data <- data.frame(
  Dose = factor(c("High", "Low", "Control"), levels=c("High", "Low", "Control")),
  Starting = c(4.38, 4.38, 4.38),
  Change = c(-0.39, -0.28, 0.84),
  Ending = c(3.99, 4.10, 5.22)
)

# Update data frame
data <- data.frame(
  Sample = factor(rep(c("Helcobacillus massiliensis LK130", "Microbacterium sp. LK369"), each=3)),
  Dose = factor(rep(c("High", "Low", "Control"), 2), levels=c("High", "Low", "Control")),
  Change = c(-0.39, -0.28, 0.84, # LK130
             -1.25, -0.75, 1.21), # LK369 
  Ending = c(3.99, 4.10, 5.22, 
             2.98, 3.48, 5.44)
  )
# V2 of data frame
data <- data.frame(
  Sample = factor(rep(c("Helcobacillus massiliensis LK130", "Microbacterium sp. LK369", "Micrococcus luteus LK1117"), each=3)),
  Dose = factor(rep(c("0", "200", "400"), 3), levels=c("0", "200", "400")),
  Starting = rep(c(4.38, #LK130
                   5.92, #LK369
                   4.23), #LK1117
                 each=3),
  Change = c(0.84, -0.28, -0.39, # LK130
             0, -0.75, -1.25, # LK369 need to get the no treatment control
             1.21, -0.17, -0.34), # LK1117
  Ending = c(5.22, 4.10, 3.99, # LK130
             0, 5.17, 4.67, # LK369
             5.44, 3.48, 2.98) #LK1117
)

ggplot(data, aes(x=Dose, y=Ending)) +
  geom_bar(stat="identity", fill="#355070") +
  geom_hline(data=data.frame(Sample=c("Helcobacillus massiliensis LK130", "Microbacterium sp. LK369", "Micrococcus luteus LK1117"), yint=c(4.38, 5.92, 4.23)),
             aes(yintercept=yint), linetype="dashed", color="#E56B6F") +
  labs(x="Active fraction (uL)", y="Log10 CFU/mL") +
  facet_wrap(~Sample) +
  theme_classic(base_size = 18) +
  ylim(0, max(data$Ending) + 0.5) +
  theme(strip.text = element_text(face = "bold.italic"))


ggplot(data, aes(x=Dose, y=Change, fill = Dose)) +
  geom_bar(stat="identity") +
  scale_fill_manual(values = c("#355070", "#B56576", "#EAAC8B")) +
  geom_hline(yintercept=0, linetype="solid", color="black") + 
  labs(x="Active fraction (uL)", y="Change in Log10 CFU/mL") +
  facet_wrap(~Sample) +
  theme_classic(base_size = 18) +
  #ylim(-0.5, 0.84) +
  theme(strip.text = element_text(face = "bold.italic"), 
        legend.position = "none")
