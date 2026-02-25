# Figure 2

This folder contains scripts, data, and figure files for generating Figure 2, which compares cultured isolates with metagenomic data.

## Directory Structure

- **`Scripts/`**: Contains R scripts for generating different panels of Figure 2
- **`Data/`**: Contains input data files
- **`Figures/`**: Contains generated figure outputs
- **`Figure_2c/`**: Contains scripts and data specific to panel 2c
- **`Extra_Figure2/`**: Contains additional figure-related files and scripts that are not included in the final figure

## Scripts

### Main Scripts (`Scripts/`)
- **`Figure2A.R`**: Generates pie charts by body sites in panel 2A showing distribution of genera in culture data
- **`Figure2B_CumulativeAbundance.R`**: Creates panel 2B displaying cumulative abundance data in comparison between culture and metagenomic data

### Panel 2c Scripts (`Figure_2c/`)
- **`runBowtie2.py`**: Python script that creates Bowtie2 alignment commands for panel 2c analysis.
- **`createBoxPlotInput.py`**: Python script that processes Bowtie2 summary outputs to create input files for boxplot visualization
- **`boxplot.R`**: R script that generates the boxplot for panel 2c

## Usage

1. Clone this repository
2. Open `Figure_2.Rproj`
3. Install required packages
4. Run the main scripts .R files - all paths use the `here` package and will work automatically from the project root. 

## Large Data Files
The following file is compressed due to GitHub's file size limit: `Data/Kraken_RelAbun_Species.csv.gz`

Before running `Figure2B_CumulativeAbundance.R`, unzip this file using `gunzip`. 

## Note
- Figure 2A: the final figure was created in BioRender by exporting R output and mapping it on a human body graphic. 

## Dependencies

- R packages: `tidyverse`, `readxl`, `readr`, `ggplot2`, `dplyr`, `janitor`, `ggpubr`, `ggrepel`, `ggbreak`, `RColorBrewer`,`here`
- Python packages: `bowtie2` (v2.5.4)
