# Extended Data Figure 4 - Additional Analyses

This folder contains scripts for generating Extended Data Figure 4, which includes additional analyses complementing the main figures.

## Directory Structure

- **`Extended_Data_Fig_4b/`**: Panel 4b - Histogram visualizations
- **`Extended_Data_Fig_4c/`**: Panel 4c - Heatmap and bar plot analyses

## Scripts by Panel

### Extended_Data_Fig_4b - Histograms
- **`plotHistogramsOfData.R`**: R script that generates histogram visualizations of various data distributions

### Extended_Data_Fig_4c - Heatmap and Bar Plots
- **`heatmapAndBarTop.R`**: R script that creates combined heatmap and bar plot visualizations
- **`generateInputForGiantHeatmap.py`**: Python script that processes data to generate input files for large-scale heatmap visualizations
- **`recreateGenusInfoFileForPlot.py`**: Python script that recreates genus information files needed for plotting

## Usage

To regenerate each panel:

1. **Panel 4b**:
   ```r
   source("Extended_Data_Fig_4b/plotHistogramsOfData.R")
   ```

2. **Panel 4c**:
   - First run Python scripts to process data:
     ```python
     python generateInputForGiantHeatmap.py
     python recreateGenusInfoFileForPlot.py
     ```
   - Then generate visualizations:
     ```r
     source("Extended_Data_Fig_4c/heatmapAndBarTop.R")
     ```

## Dependencies

- R packages: `ggplot2`, `pheatmap`, `dplyr`, and other visualization packages
- Python packages: Standard data processing libraries (`pandas`, `numpy`)

## Output

Each panel generates:
- **4b**: Histogram plots showing data distributions
- **4c**: Combined heatmap and bar plot visualizations showing genus-level patterns
