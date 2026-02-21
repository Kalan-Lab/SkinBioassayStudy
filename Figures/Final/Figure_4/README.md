# Figure 4 - BGC Analysis and Rarefaction

This folder contains scripts and data for generating Figure 4, which analyzes biosynthetic gene cluster (BGC) diversity, relationships, and rarefaction curves.

## Directory Structure

- **`Figure_4a/`**: Panel 4a - BGCome size vs antifungal score analysis
- **`Figure_4b/`**: Panel 4b - Phylogenetic tree with BGC tracks
- **`Figure_4c/`**: Panel 4c - Network analysis of GCF relationships
- **`Figure_4d/`**: Panel 4d - Rarefaction analysis

## Scripts by Panel

### Figure_4a - BGCome Size vs Antifungal Score
- **`plot.R`**: R script that creates scatterplot showing relationship between BGCome size and mean antifungal scores
- **`determineIputForBGComeSizeVsAntifungalVsRelabundacePlot.py`**: Python script that processes data to create input files for the plot

**Input files:**
- `BGCome_Size_vs_Antifungal_Score.txt`: Main data file with genus-level BGCome sizes and antifungal scores
- `antifungal_scores.txt`: Antifungal activity scores
- `Genus_Abundance_and_Prevalence.txt`: Genus abundance and prevalence data
- `BGC_Centric_View.txt`: BGC-centric view of the data

### Figure_4b - Phylogenetic Tree with BGC Tracks
- **`createTrackForBGCs.py`**: Python script that creates iTOL track files for visualizing BGCs on the phylogenetic tree
- **`createPiechartForSBCCAndEpic.py`**: Python script that generates pie chart data for SBCC and Epic classifications

**Input files:**
- `Dereplication_Results_99.txt`: Dereplication results at 99% identity
- `BGC_Centric_View.txt`: BGC-centric view
- `GToTree_Results/`: Directory containing phylogenetic tree results from GToTree
- `SahebKashaf_2022_TableS4.txt`: Reference table from SahebKashaf et al. 2022
- `Dataset.iTol.txt`: iTOL dataset file
- `Color_Mapping.txt`: Color mapping for visualization

### Figure_4c - Network Analysis
- **`igraph.R`**: R script that creates network visualization using igraph
- **`createIgraphInputs.py`**: Python script that processes data to create input files for igraph network analysis

**Input files:**
- `edges.txt`: Edge list for network
- `nodes.txt`: Node list for network
- `mix_clustering_c0.30.tsv`: Clustering results
- `Dereplication_Results_99.txt`: Dereplication results
- `LK_GCFs.txt`: GCF information
- `GCF_Centric_View.txt`: GCF-centric view
- `BGC_Centric_View.txt`: BGC-centric view
- `All_BGC_Genbanks.txt`: All BGC GenBank information
- `pie.txt`: Pie chart data

### Figure_4d - Rarefaction Analysis
- **`plotRarefaction.R`**: R script that creates rarefaction curves
- **`plotRarefactionPermutation.R`**: R script for rarefaction with permutation analysis
- **`performRarefaction.py`**: Python script that performs rarefaction analysis
- **`performRarefactionUsingPermutation.py`**: Python script for rarefaction with permutations
- **`getRarefactionInputs.py`**: Python script that prepares input data for rarefaction

**Input files:**
- `Input.txt`: Input data for rarefaction
- `bodysite.txt`: Body site information
- `Rarefaction_Results.txt`: Standard rarefaction results
- `Rarefaction_Results.With_Permutations.txt`: Rarefaction results with permutations

## Usage

To regenerate each panel:

1. Navigate to the specific panel directory (e.g., `Figure_4a/`)
2. Ensure all required input files are present
3. Run data processing scripts first (Python scripts), then plotting scripts (R scripts)
4. Check output file paths in scripts and adjust if necessary

## Output

Each panel generates:
- **4a**: PDF scatterplot (`BGCome_Size_vs_Antifungal_Score.pdf`)
- **4b**: iTOL track files and phylogenetic tree visualizations
- **4c**: Network visualization files
- **4d**: PDF rarefaction curves (`Rarefaction_Results.pdf`)
