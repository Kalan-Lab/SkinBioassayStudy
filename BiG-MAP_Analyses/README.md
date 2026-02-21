# BiG-MAP Analyses

This folder contains scripts, commands, and results for **BiG-MAP** analyses. BiG-MAP quantifies the abundance of biosynthetic gene cluster (BGC) families in metagenomic samples by mapping reads to BGCs and reporting coverage and RPKM (reads per kilobase per million) per GCF (Gene Cluster Family) per sample.

## Overview

BiG-MAP uses BiG-SCAPE GCF definitions and antiSMASH GenBank files to profile BGC abundance across skin metagenomes. This directory holds the run command, helper scripts for filtering and mapping GCF IDs, and downstream result tables used in the paper. Additional scripts and data for Extended Data Figure 4 can be found in `Figures/Extended_Data_Fig_4`.

## Files and Scripts

### Command files
- **`bigmap.fam.cmd`**  
  Example command used to run BiG-MAP in family mode. It:
  - antiSMASH output as input (`-D`)
  - Output directory (`-O`)
  - References to BiG-SCAPE program and directory with Pfam-A DB (`-b`, `-pf`)
  - Uses cutoff `-c 0.3` and `-p 50` threads.  
  Paths are environment-specific and must be updated for your setup.

- **`bigmap.map.cmd`**
  Example command used to run BiG-MAP in map mode. It:
  - Info on EPIC metagenomic samples (`-b`) 
  - Read FASTQ files (paired) for EPIC metagenomes (`-I1`/`-I2`) 
  - BiG-MAP.family results directory (`-F`)
  - Output directory (`-O`) 
  - Uses `-th 30` threads

### Python scripts
- **`getGCFidsOfReps.py`**  
  Maps BiG-MAP family representative IDs to independent BiG-SCAPE GCF IDs.  
  - **Input:** BiG-MAP family FASTA file (e.g. BiG-MAP output with rep sequences).  
  - **Usage:** `python getGCFidsOfReps.py <bigmap_family_file>`  
  - **Note:** Script expects BiG-SCAPE clustering at `../BiG-SCAPE_Analysis/Results/network_files/...`; adjust path if your BiG-SCAPE output lives elsewhere.

- **`filterCoreForThoseMeetingFullFilters.py`**  
  Filters “core” BiG-MAP results to retain only (sample, BGC) pairs that also appear in the “full” filtered set, and adds BGC class from an annotation file. Optionally filters by GCF prevalence (e.g. GCFs with ≥5 samples).  
  - **Inputs (positional):**  
    1. Full filtered table  
    2. Core filtered table  
    3. Unfiltered core table  
    4. BGC annotation file (BGC ID → class)  
  - **Output:** TSV to stdout with columns: `sample`, `bgc`, `bgc_class`, `rpkm_norm`, `coverage`, `sample_subject`, `sample_bodysite`.

### Data / results (representative)
- **`GCF_vs_Metagenomes_Full_Filtered.txt`**  
  Full filtered table: sample × BGC (GCF rep) with normalized RPKM, coverage, and sample metadata (subject, body site).

- **`GCF_vs_Metagenomes_Core_Filtered.txt`**  
  Core filtered table: same structure, restricted to core set (and optionally filtered by `filterCoreForThoseMeetingFullFilters.py`).

- **`total_read_counts_per_sample.txt`**  
  Total read counts per metagenomic sample (used for normalization).

- **`Top_Genera_per_Sample.txt`**  
  Top genera per sample (e.g. for context or filtering).

### BiG-MAP output directories
- **`BiG-MAP_Analyse_Full_Results/`**  
  BiG-MAP run output for the “full” analysis (e.g. `tsv-results/`: `all_RPKMs.tsv`, `all_RPKMs_norm.tsv`, `coverage.tsv`, `explore_GCs.tsv`; also `explore_heatmap.eps`).

- **`BiG-MAP_Analyse_Core_Results/`**  
  BiG-MAP run output for the “core” analysis (same TSV and PDF heatmap structure).

## Typical workflow

1. Run BiG-MAP family module using (or adapting) `bigmap.fam.cmd`.
2. Run BiG-MAP map module using (or adapting) `bigmap.map.cmd`.
3. Run BiG-MAP analyze module (or adapting) `bigmap.map.cmd`.
