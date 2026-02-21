# Figure 5 - Novel Species Analysis

This folder contains scripts, data, and figure files for generating Figure 5, which analyzes novel species identified in the study, including their bioassay results, abundance, and SRA metadata.

## Directory Structure

- **`Scripts/`**: Contains R Markdown scripts for generating different aspects of Figure 5
- **`Data/`**: Contains data files including SRA metadata for novel species
- **`Figures/`**: Contains generated figure outputs (Adobe Illustrator files)
- **`Figure_5def/`**: Contains GECCO progress logs for different species
- **`Figure_5DEF_New/`**: Contains updated progress logs

## Scripts

### Main Scripts (`Scripts/`)
- **`novel_species_bioassay.Rmd`**: R Markdown script that analyzes and visualizes bioassay results for novel species. This script:
  - Loads bioassay data for novel species
  - Calculates summarized inhibition scores
  - Generates heatmaps and boxplots showing antifungal activity
  - Creates visualizations comparing novel species bioassay performance

- **`novel_species_abon.Rmd`**: R Markdown script that analyzes abundance data for novel species
- **`novel_species_SRA.Rmd`**: R Markdown script that processes and visualizes SRA (Sequence Read Archive) metadata for novel species

## Data Files

### Novel Species BranchWater Results (`Data/novel_species_SRA_results/`)
- **`LK960_SRAmetadata.csv`**: SRA metadata for Kocuria sp. LK960
- **`LK952_SRAmetadata.csv`**: SRA metadata for Corynebacterium sp. LK952
- **`LK1337_SRAmetadata.csv`**: SRA metadata for Brevibacterium sp. LK1337
- **`LK1188_SRAmetadata.csv`**: SRA metadata for Aestuariimicrobium sp. LK1188

### Novel Species ABON based Assessment of BGC Novelty

Files in `Figure_5DEF/` are progress logs and ABON resulting spreadsheets. ABON is a program from the zol suite.

## Figures

- **`Figures/Figure5.ai`**: Adobe Illustrator file for Figure 5
- **`Figures/Figure5-1.ai`**: Alternative version of Figure 5
- **`Figures/Figure5-1-Updated.ai`**: Updated version of Figure 5-1

## Novel Species Analyzed

1. **Kocuria sp. LK960**
2. **Corynebacterium sp. LK952**
3. **Brevibacterium sp. LK1337**
4. **Aestuariimicrobium sp. LK1188**

## Usage

To regenerate Figure 5 components:

1. **Bioassay Analysis**:
   ```r
   rmarkdown::render("Scripts/novel_species_bioassay.Rmd")
   ```

2. **Abundance Analysis**:
   ```r
   rmarkdown::render("Scripts/novel_species_abon.Rmd")
   ```

3. **SRA Metadata Analysis**:
   ```r
   rmarkdown::render("Scripts/novel_species_SRA.Rmd")
   ```

Note: Update file paths in the R Markdown scripts to match your local directory structure.

## Dependencies

- R packages: `ggplot2`, `readxl`, `dplyr`, `tidyverse`, `pheatmap`, `pals`, `RColorBrewer`
- R Markdown for generating HTML reports

## Output

The scripts generate:
- HTML reports with bioassay visualizations
- Heatmaps showing antifungal activity
- Boxplots comparing novel species performance
- SRA metadata summaries and visualizations
