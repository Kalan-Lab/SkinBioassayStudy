# Extended Data Figure 3 - BGC Distance Analysis and HAD Enrichment

This folder contains scripts for generating Extended Data Figure 3, which includes multiple panels analyzing biosynthetic gene cluster (BGC) relationships, antibiotic resistance prevalence, and HADA (Haloacid Dehalogenase) enrichment.

## Directory Structure

- **`Extended_Data_Fig_3a/`**: Panel 3a - Distance analysis to closest cataloged GCFs in BiG-FAM using BiG-SLICE.
- **`Extended_Data_Figs_3b_and_4a/`**: Panel 3b - Antibiotic resistance prevalence heatmap amongst isolates and metagenomes.
- **`Extended_Data_Figs_3cd/`**: Panels 3c and 3d - Host-associated domain enrichment analyses.

## Scripts by Panel

### Extended_Data_Fig_3a - Distance to Closest GCFs
- **`autoRunBiGSLICEQuery.py`**: Python script that automates BiG-SLICE queries to find closest GCFs for each BGC from EPIC isolate genomes.
- **`extractDistancesToClosestGCFsInBiGFAM.py`**: Python script that extracts distance metrics to closest GCFs in BiG-FAM database.
- **`getTheLowestMembershipValueAndProcessNames.py`**: Python script that processes membership values and GCF names.
- **`plotDistanceHistogram.R`**: R script that creates histogram visualizations of distance distributions.

### Extended_Data_Figs_3b_and_4a - Antibiotic Resistance Prevalence
- **`Scripts/AntibioticResistancePrevelenceHeatmap.R`**: R script that generates heatmap showing antibiotic resistance gene prevalence across samples

### Extended_Data_Figs_3cd - HADA Enrichment Analysis
- **`plot.R`**: R script that creates visualizations for HADA enrichment analysis
- **`runPyhmmer.py`**: Python script that runs pyHMMER searches to identify HADA proteins
- **`determineIDsOfBGCProteins.py`**: Python script that identifies proteins within BGCs
- **`checkIfHADAreEnrichedInBGCs.py`**: Python script that checks for HADA enrichment in BGCs
- **`getSampleHADProtProportions.py`**: Python script that calculates HADA protein proportions per sample
- **`determineIfDrySiteHaveLessHAD.py`**: Python script that compares HADA levels between dry and moist body sites

## Usage

To regenerate each panel:

1. **Panel 3a**:
   - Run Python scripts to query BiG-SLICE and extract distances.
   - Process results with membership value script.
   - Generate histogram with R script.

2. **Panel 3b**:
   ```r
   source("Extended_Data_Figs_3b_and_4a/Scripts/AntibioticResistancePrevelenceHeatmap.R")
   ```

3. **Panels 3c-3d**:
   - Run pyHMMER searches to identify host-associated domains in predicted proteins of EPIC genomes.
   - Process BGC protein IDs.
   - Calculate enrichment statistics.
   - Generate plots with R script.

## Dependencies

- R packages: `ggplot2`, `pheatmap`, and other visualization packages
- Python packages: `pyhmmer`, `numpy`, `pandas`, and bioinformatics libraries
- External tools: BiG-SLICE, BiG-FAM database access

## Output

Each panel generates:
- **3a**: Histogram plots showing distance distributions to closest GCFs
- **3b**: Heatmap showing antibiotic resistance gene prevalence
- **3c-3d**: Visualizations showing HADA enrichment in BGCs and comparisons between body sites
