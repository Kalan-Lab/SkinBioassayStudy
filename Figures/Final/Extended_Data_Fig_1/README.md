# Extended Data Figure 1 - Culture vs Metagenomic Comparison

This folder contains scripts for generating Extended Data Figure 1, which compares culture-based isolation with metagenomic sequencing approaches (Sylph and Kraken).

## Files

### Scripts
- **`Scripts/Sylph_Kraken_CultureComparison_V1.Rmd`**: R Markdown script that performs comprehensive comparison between:
  - Culture-based isolation methods
  - Sylph taxonomic classification (not shown in final figure)
  - Kraken taxonomic classification
  
  This script:
  - Loads and processes data from multiple sources
  - Performs comparative analyses between methods
  - Generates visualizations showing overlap and differences
  - Creates upset plots and other comparative visualizations (not shown)
  - Produces HTML reports with detailed results

## Usage

To regenerate Extended Data Figure 1:

1. Clone this repository
2. Open `Extended_Data_Fig_1.Rproj`
3. Install required packages
4. Run the main markdown file `Scripts/Sylph_Kraken_CultureComparison_V1.Rmd` - all paths use the `here` package and will work automatically from the project root. 

## Dependencies

- R packages: `tidyverse`, `readxl`, `readr`, `ggplot2`, `dplyr`, `janitor`, `ComplexUpset`, `ggpubr`, `here`

## Output

The script generates an HTML report containing:
- Comparative visualizations between culture, Sylph, and Kraken methods
- Upset plots showing overlaps (not shown)
- Statistical comparisons using Spearman's rank correlation
