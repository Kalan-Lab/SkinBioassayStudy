#load packages
library(tidyverse)
library(ggplot2)
library(readr)
#install.packages("dplyr")
library(dplyr)

#import data
Metadata.ext <- read_csv("~/Documents/GitHub/Kalan_Lab/scripts/ssandstrom/skin_bioassay_paper_files/metadata/Metadata.ext.csv")
host_ID <- read_csv("~/Documents/GitHub/Kalan_Lab/scripts/ssandstrom/skin_bioassay_paper_files/metadata/host_ID.csv")

#change column name
names(Metadata.ext)[names(Metadata.ext) == "SubjectID"] <- "Subject_ID"

#select participants in study
merged_data <- merge(host_ID, 
                     Metadata.ext[, c("Subject_ID", "Gender", "Age", "Race")], 
                     by = "Subject_ID")

# Select the columns you are interested in
selected_data <- merged_data %>%
  select(Subject_ID, Source_Name, Host_ID, Other_ID, Gender, Age, Race)

# Remove duplicates based on a specific variable, assuming Subject_ID is unique
unique_data <- distinct(selected_data, Host_ID, .keep_all = TRUE)

# Now let's split the data frame by Gender
split_data <- split(unique_data, unique_data$Gender)

# Function to apply to each subset of the data
summarise_age <- function(df) {
  return(c(
    min_age = min(df$Age, na.rm = TRUE),
    median_age = median(df$Age, na.rm = TRUE),
    max_age = max(df$Age, na.rm = TRUE),
    count = length(na.omit(df$Age))
  ))
}

# Apply the function to each subset and bind the result into a data frame
summary_by_gender <- do.call(rbind, lapply(split_data, summarise_age))

# Convert row names to a column if needed
summary_by_gender <- data.frame(Gender = row.names(summary_by_gender), summary_by_gender, row.names = NULL)

#summary of age, gives min, media, max
summary_age <- summary(unique_data$Age)
print(summary_age)

