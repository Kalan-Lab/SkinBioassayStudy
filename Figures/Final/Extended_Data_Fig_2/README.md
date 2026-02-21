# Extended Data Figure 2 - Fungal Bioassay Upset Plot

This folder contains scripts for generating Extended Data Figure 2, which visualizes fungal bioassay results using an upset plot format.

## Files

### Scripts
- **`Scripts/fungal_bioassay_upset_updated.R`**: R script that creates an upset plot visualization for fungal bioassay results. This script:
  - Loads fungal bioassay data
  - Processes data for upset plot format
  - Generates visualization showing intersections of antifungal activity patterns
  - Creates publication-ready figures

## Usage

To regenerate Extended Data Figure 2:

1. Ensure the required data files are available
2. Update file paths in the script if necessary
3. Load required R packages (check script for dependencies)
4. Run the script:
   ```r
   source("Scripts/fungal_bioassay_upset_updated.R")
   ```

## Dependencies

- R packages: Check the script for specific package requirements (likely includes `ComplexUpset`, `ggplot2`, `dplyr`, and related packages)

## Output

The script generates upset plot visualizations showing:
- Patterns of antifungal activity across different fungal pathogens
- Intersections between different activity profiles
- Publication-ready figure outputs
