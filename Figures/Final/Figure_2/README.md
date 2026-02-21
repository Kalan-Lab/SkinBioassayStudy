# Figure 2

This folder contains scripts, data, and figure files for generating Figure 2, which compares cultured isolates with metagenomic data.

## Directory Structure

- **`Scripts/`**: Contains R scripts for generating different panels of Figure 2
- **`Data/`**: Contains input data files
- **`Figures/`**: Contains generated figure outputs
- **`Figure_2c/`**: Contains scripts and data specific to panel 2c
- **`Extra_Figure2/`**: Contains additional figure-related files

## Scripts

### Main Scripts (`Scripts/`)
- **`Figure2A.R`**: Generates panel 2A showing comparison between culture and metagenomic data
- **`Figure2B_CumulativeAbundance.R`**: Creates panel 2B displaying cumulative abundance data
- **`abun_scatterplot_220914.R`**: Generates abundance scatterplots (dated 2022-09-14)
- **`abun_scatterplot_251015.R`**: Generates abundance scatterplots (dated 2025-10-15)
- **`culturedvmetagenomic_220822.R`**: Script comparing cultured isolates versus metagenomic data (dated 2022-08-22)

### Panel 2c Scripts (`Figure_2c/`)
- **`runBowtie2.py`**: Python script that creates Bowtie2 alignment commands for panel 2c analysis.
- **`createBoxPlotInput.py`**: Python script that processes Bowtie2 summary outputs to create input files for boxplot visualization
- **`boxplot.R`**: R script that generates the boxplot for panel 2c

## Usage

1. Navigate to the appropriate subdirectory for the panel you want to regenerate
2. Ensure required data files are present
3. Update file paths in scripts if necessary
4. Run the scripts in order (data processing scripts before plotting scripts)

## Dependencies

- R packages: `tidyverse`, `readxl`, `readr`, `ggplot2`, `dplyr`, `janitor`, `ggpubr`
- Python packages: `bowtie2` (v2.5.4)
