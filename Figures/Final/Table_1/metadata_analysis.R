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

# 17 participants
#select participants in study
merged_data <- merge(host_ID, 
                     Metadata.ext[, c("Subject_ID", "Gender", "Age", "Race")], 
                     by = "Subject_ID")

# select the specific column
selected_data <- merged_data %>%
  select(Subject_ID, Source_Name, Host_ID, Other_ID, Gender, Age, Race)

# remove duplicates based on Subject_ID
unique_data <- distinct(selected_data, Subject_ID, .keep_all = TRUE)

# split by Gender
split_data <- split(unique_data, unique_data$Gender)

# function to apply to each subset of the data
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

# 34 participants
df_34 <- Metadata.ext %>% 
  select(Subject_ID, Gender, Age, Race) %>%
  distinct(Subject_ID, .keep_all = T)

# Summary table with n values
summary_table <- df_34 %>%
  group_by(Race, Gender) %>%
  summarise(n = n()) %>%
  pivot_wider(names_from = Gender, values_from = n, values_fill = 0)

# Age statistics
age_stats <- df_34 %>%
  filter(!is.na(Age), 
         Gender != "Prefer not to answer") %>%
  mutate(Age = as.numeric(as.character(Age))) %>%
  group_by(Gender) %>%
  dplyr::summarise(
    n = n(),
    min_age = min(Age, na.rm = TRUE),
    max_age = max(Age, na.rm = TRUE),
    median_age = median(Age, na.rm = TRUE)
  ) %>%
  mutate(age_range = paste(min_age, "-", max_age))

age_distribution <- df_34 %>%
  filter(!is.na(Age), 
         Gender != "Prefer not to answer") %>%
  mutate(Age = as.numeric(as.character(Age))) %>%
  group_by(Gender) %>%
  summarise(
    all_ages = sort(Age), 
    n = n()
  )

overall_age_stats <- df_34 %>%
  filter(!is.na(Age), 
         Gender != "Prefer not to answer") %>%
  mutate(Age = as.numeric(as.character(Age))) %>%
  summarise(
    n = n(),
    min_age = min(Age, na.rm = TRUE),
    max_age = max(Age, na.rm = TRUE),
    median_age = median(Age, na.rm = TRUE)
  ) %>%
  mutate(age_range = paste(min_age, "-", max_age))
