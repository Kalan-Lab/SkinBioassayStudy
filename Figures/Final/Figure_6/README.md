# Figure 6 - In Vivo Results

This folder contains scripts and figure files for generating Figure 6, which displays in vivo antifungal activity results from mouse model experiments.

## Files

### Scripts
- **`Figure6.R`**: Main R script that generates Figure 6 visualizations. This script:
  - Creates bar plots showing Log10 CFU/mL results for three bacterial isolates:
    - Helcobacillus massiliensis LK130
    - Microbacterium sp. LK369
    - Micrococcus luteus LK1117
  - Displays results at different doses (0, 200, 400 uL active fraction)
  - Includes positive control data (Fluconazole, Amphotericin B, Micafungin)
  - Generates multi-panel figure using `patchwork` package

- **`241029_InVivo_Results.R`**: Alternative script for in vivo results analysis (dated 2024-10-29)

### Figure Files
- **`Figure6.ai`**: Adobe Illustrator file containing the final version of Figure 6
- **`Figure6-Updated.ai`**: Updated version of Figure 6

## Data Structure

The script uses hardcoded data for:
- **Test isolates**: Three bacterial species tested at three dose levels
- **Positive controls**: Three antifungal drugs (Fluconazole, Amphotericin B, Micafungin) with three replicates each

## Usage

To regenerate Figure 6:

1. Load required R packages:
   ```r
   library(ggplot2)
   library(dplyr)
   library(patchwork)
   library(stringr)
   ```

2. Run the script:
   ```r
   source("Figure6.R")
   ```

The script will generate a multi-panel figure showing:
- Panel 1-3: Bar plots for each test isolate showing change in Log10 CFU/kidney
- Panel 4: Positive control results with error bars

## Dependencies

- R packages: `ggplot2`, `dplyr`, `patchwork`, `stringr`

## Output

The script generates a combined plot showing:
- Individual isolate responses to different doses
- Comparison with positive controls
- Statistical summaries (mean, SE) for positive controls
