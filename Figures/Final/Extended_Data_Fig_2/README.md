# Extended Data Figure 2 - Fungal Bioassay Upset Plot

This folder contains scripts for generating Extended Data Figure 2, which visualizes fungal bioassay results using an upset plot format.

## Files

### Scripts
- **`Scripts/fungal_bioassay_upset_updated.R`**: R script that creates an upset plot visualization for fungal bioassay results. 
This script:
  - Loads fungal bioassay data
  - Processes data for upset plot format
  - Generates visualization showing intersections of antifungal activity patterns

## Usage

1. Clone this repository
2. Open `Extended_Data_Fig_2.Rproj`
3. Install required packages
4. Run the main scripts .R files - all paths use the `here` package and will work automatically from the project root. 

## Dependencies

- R packages: `ComplexUpset`, `ggplot2 (v3.5.2)`, `dplyr`, `tidyverse`, `readxl`, `here`, `extraoperators`

## Output

The script generates upset plot visualizations showing:
- Patterns of antifungal activity across different fungal pathogens
- Intersections between different activity profiles
