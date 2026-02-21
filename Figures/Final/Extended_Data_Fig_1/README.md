# Extended Data Figure 1 - Culture vs Metagenomic Comparison

This folder contains scripts for generating Extended Data Figure 1, which compares culture-based isolation with metagenomic sequencing approaches (Sylph and Kraken).

## Files

### Scripts
- **`Scripts/Sylph_Kraken_CultureComparison_V1.Rmd`**: R Markdown script that performs comprehensive comparison between:
  - Culture-based isolation methods
  - Sylph metagenomic analysis
  - Kraken taxonomic classification
  
  This script:
  - Loads and processes data from multiple sources
  - Performs comparative analyses between methods
  - Generates visualizations showing overlap and differences
  - Creates upset plots and other comparative visualizations
  - Produces HTML reports with detailed results

## Usage

To regenerate Extended Data Figure 1:

1. Ensure all required data files are available (check file paths in the script)
2. Update file paths in the R Markdown script if necessary
3. Render the R Markdown file:
   ```r
   rmarkdown::render("Scripts/Sylph_Kraken_CultureComparison_V1.Rmd")
   ```

## Dependencies

- R packages: `tidyverse`, `readxl`, `readr`, `ggplot2`, `dplyr`, `janitor`, `ComplexUpset`, `ggpubr`

## Output

The script generates an HTML report containing:
- Comparative visualizations between culture, Sylph, and Kraken methods
- Upset plots showing overlaps
- Statistical comparisons
- Detailed analysis results
