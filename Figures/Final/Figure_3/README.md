# Figure 3 - Bioassay Results

This folder contains scripts, data, and figure files for generating Figure 3, which displays bioassay results showing antifungal activity of skin isolates.

## Directory Structure

- **`Scripts/`**: Contains R scripts for generating bioassay visualizations
- **`Data/`**: Contains bioassay data files
- **`Figures/`**: Contains generated figure outputs
- **`Figure_3d/`**: Contains scripts and data specific to panel 3d

## Scripts

### Main Scripts (`Scripts/`)
- **`bioassay_251114_ShortName.R`**: Main script for generating bioassay heatmaps with shortened pathogen names (dated 2025-11-14). This script:
  - Loads bioassay data from CSV files
  - Processes pathogen names and types (Gram-positive, Gram-negative, Fungal)
  - Creates heatmaps showing antifungal activity scores

- **`bioassay_221005.R`**: Earlier version of bioassay visualization script (dated 2022-10-05)
- **`_bioassay_bar.R`**: Script for generating bar plots of bioassay results
- **`Figure3C.R`**: Script specifically for generating panel 3C of average antifungal scores

### Panel 3d Scripts (`Figure_3d/`)
- **`plot.R`**: R script for generating the panel 3d visualization
- **`appendTaxonomyInfo.py`**: Python script that adds taxonomy information to isolate data
- **`calculateIsolateScores.py`**: Python script that calculates antimicrobial scores for isolates

## Data Files

Bioassay data files are located in the `Data/` directory and include:
- Bioassay results with inhibition scores
- Pathogen information and classifications
- Isolate metadata

## Usage

1. Clone this repository
2. Open `Figure_3.Rproj`
3. Install required packages
4. Run the main scripts .R files - all paths use the `here` package and will work automatically from the project root. 

## Dependencies

- R packages: `pheatmap`, `RColorBrewer`, `dplyr`, `readxl`, `ggplot2`, `ggpubr`,`here`, `patchwork`, `tidyverse`, `reshape2`, `tidyr`
- Python packages: Standard libraries plus any data processing libraries as needed

## Output

The scripts generate:
- Heatmaps showing antifungal activity against various pathogens
- Bar plots of bioassay results
- Excel files with processed bioassay data
