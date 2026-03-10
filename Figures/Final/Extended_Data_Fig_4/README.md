# Extended Data Figure 4 - Additional Analyses

This folder contains scripts for generating Extended Data Figure 4, which includes additional analyses complementing the main figures.

## Directory Structure

- **`Extended_Data_Fig_4b/`**: Panel 4b - Histograms informing on value distributions from BiG-MAP analysis
- **`Extended_Data_Fig_4c/`**: Panel 4c - Heatmap and bar plot analyses of GCF detection across metagenomes using BiG-MAP
- **`Extended_Data_Fig_4d/`**: Panel 4d - Rarefaction analysis of GCF discovery based on antiSMASH calling on metagenomic assemblies followed by BiG-SCAPE clustering

## Scripts by Panel

### Extended_Data_Fig_4b - Histograms
- **`plotHistogramsOfData.R`**: R script that generates histogram visualizations of various data distributions

### Extended_Data_Fig_4c - Heatmap and Bar Plots
- **`heatmapAndBarTop.R`**: R script that creates combined heatmap and bar plot visualizations
- **`generateInputForGiantHeatmap.py`**: Python script that processes data to generate input files for large-scale heatmap visualizations
- **`recreateGenusInfoFileForPlot.py`**: Python script that recreates genus information files needed for plotting

### Extended_Data_Fig_4d - Rarefaction of GCF Discovery based on Metagenomic Analysis
- **`runAntiSMASH.py`**: Python script (run externally) used to annotate assembled metagenomes with antiSMASH prior to BiG-SCAPE/BiG-MAP-based rarefaction.
- **`bigscape.cmd`**: Command used to run BiG-SCAPE on antiSMASH results for the metagenomic assemblies.
- **`performRarefaction.py`**: Python script that performs rarefaction analysis across metagenomic assemblies, taking GCF presence/absence and sequencing depth as input.
- **`Input.txt`**: Input file listing samples, sequencing depths, and BiG-MAP GCF counts used by the rarefaction script.
- **`Rarefaction_Results.txt`**: Tab-delimited results with columns such as `BodySite`, `CumulativeDepth`, and `GCFsDiscovered`.
- **`plotRarefaction.R`**: R script that reads `Rarefaction_Results.txt` and generates rarefaction curves showing the number of GCFs discovered as a function of sequencing depth for each body site (output: `Rarefaction_Results_MetagenomeAssembly_AntiSMASH_BiG-SCAPE.pdf`).

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

3. **Panel 4d**:
   - Ensure antiSMASH and BiG-SCAPE have been run on the metagenomic assemblies (see `runAntiSMASH.py` and `bigscape.cmd` for example commands).
   - Generate the rarefaction input table (`Input.txt`) and run the Python rarefaction script:
     ```python
     python performRarefaction.py
     ```
   - Plot the resulting curves:
     ```r
     source("Extended_Data_Fig_4d/plotRarefaction.R")
     ```

## Dependencies

- R packages: `ggplot2`, `pheatmap`, `dplyr`, and other visualization packages
- Python packages: Standard data processing libraries (`pandas`, `numpy`)

## Output

Each panel generates:
- **4b**: Histogram plots showing data distributions
- **4c**: Combined heatmap and bar plot visualizations showing genus-level patterns
- **4d**: Rarefaction curves showing the number of GCFs discovered as a function of sequencing depth for each body site based on metagenomic assemblies and BGC annotations
