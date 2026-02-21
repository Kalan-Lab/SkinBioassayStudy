# Table 1 - Study Participant Metadata

This folder contains scripts and data files for generating Table 1, which summarizes the demographic and metadata information for study participants.

## Files

### Scripts
- **`metadata_analysis.R`**: Main R script that processes participant metadata and generates summary statistics for Table 1. The script:
  - Loads participant metadata from `Metadata.ext.csv` and host ID information from `host_ID.csv`
  - Merges datasets and filters for study participants
  - Calculates summary statistics including:
    - Age statistics (min, median, max) by gender
    - Participant counts by race and gender
    - Overall demographic distributions
  - Generates tables suitable for inclusion in the manuscript

### Data Files
- **`Metadata.ext.csv`**: Extended metadata file containing participant information including Subject_ID, Gender, Age, Race, and other demographic variables
- **`host_ID.csv`**: Host identification file mapping Subject_ID to Source_Name, Host_ID, and Other_ID

## Usage

To regenerate Table 1:

1. Ensure the data files (`Metadata.ext.csv` and `host_ID.csv`) are in the same directory
2. Update the file paths in `metadata_analysis.R` if necessary (lines 9-10)
3. Run the script:
   ```r
   source("metadata_analysis.R")
   ```

## Output

The script generates summary statistics including:
- Age distributions by gender (min, median, max)
- Participant counts by race and gender
- Overall age statistics for the study cohort
