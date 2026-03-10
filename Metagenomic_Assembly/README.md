## Metagenomic Assembly

This folder contains scripts, commands, and summary tables for the **metagenomic assembly and binning** workflow used to generate skin metagenome-assembled genomes (MAGs). The pipeline covers:
- Short-read metagenomic assembly using MetaSPAdes
- Binning and bin refinement using MetaWrap
- Scripts for MAG extraction, quality assessment, taxonomic classification, and consolidation of results into a single table

> [!IMPORTANT]
> Metagenomic assemblies and MAGs can be found in FASTA format on Zenodo: https://zenodo.org/records/18882798

### Directory structure

- `Assembly_Scripts/`: Scripts and notes for assembly, binning, bin refinement, and MAG extraction.
- `Consolidated_Table/`: Scripts and input/output tables for summarizing MAG quality, taxonomy, and similarity to existing genomes.

---

### Assembly_Scripts

- `runMetaSpades.py`  
  Prints shell commands to run **metaSPAdes** for each paired metagenomic sample.
  - **Input:** `FastqPair_Sorted_Processed_Reads/` containing `*_R1.fastq.paired.fq.gz` and matching `*_R2.fastq.paired.fq.gz` files.  
  - **Output:** For each sample, a metaSPAdes assembly directory under `MetaSPAdes_Assembly/<sample>/` with `scaffolds.fasta`.  
  - **Usage (example):**
    ```bash
    cd Assembly_Scripts
    python runMetaSpades.py > metaspades_commands.sh
    bash metaspades_commands.sh
    ```

- `runMetawrap.py`  
  Prints shell commands to run **MetaWRAP** binning and bin refinement on each assembled metagenome.
  - Copies and uncompresses reads into `Uncompressed_and_Renamed_Reads/`
  - Uses `MetaSPAdes_Assembly/<sample>/scaffolds.fasta` as the assembly
  - Runs `metawrap binning` with MaxBin2, MetaBAT2, and CONCOCT
  - Runs `metawrap bin_refinement` with thresholds `-c 50 -x 10`
  - Cleans up temporary renamed reads  
  - **Key directories:**  
    - `Metaspades_MetaWrap_Binning/<sample>/`  
    - `Metaspades_MetaWrap_Refinement/<sample>/`  
  - **Usage (example):**
    ```bash
    cd Assembly_Scripts
    python runMetawrap.py > metawrap_commands.sh
    bash metawrap_commands.sh
    ```

- `extractMagsInFasta.py`  
  Extracts refined MAGs into individual FASTA files.
  - **Inputs:**  
    - `Metaspades_MetaWrap_Refinement/<sample>/metawrap_50_10_bins.contigs` (contig→bin mapping)  
    - `MetaSPAdes_Assembly/<sample>/scaffolds.fasta`  
    - `../Bowtie2_Mapping/MetaInfo.txt` for sample-name mapping  
  - **Output:** One FASTA per MAG under `MetaSPAdes_MegaWRAP_MAGs/` named `<sample>_<bin>.fasta`.  
  - **Usage:**
    ```bash
    cd Assembly_Scripts
    python extractMagsInFasta.py
    ```

- `README.txt`  
  Short note describing that MetaWRAP was run twice and can be slightly non-deterministic.

---

### Consolidated_Table

This folder aggregates multiple QC, taxonomy, and similarity analyses into a single consolidated MAG table.

- `runInfernalAndTrnaScanSE.py`  
  Prints commands to run:
  - **tRNAscan-SE** on each MAG in `MetaSPAdes_MegaWRAP_MAGs/`
  - **INFERNAL cmsearch** with `Ribo_16S_23S_and_5S.cm` to detect rRNAs  
  - **Outputs:**  
    - `tRNAScan-SE_Results/<MAG>.txt`  
    - `Infernal_Results/<MAG>.txt`

- `runGTDBtk.py`  
  Wrapper for **GTDB-Tk v1.7.0 with GTDB R202**.
  - **Inputs:**  
    - A text file listing paths to MAG FASTA files (`ref_list_file`, usually `.fasta.gz`)  
  - **Workflow:**  
    - Copies genomes into `<outdir>/genomes/` as `.fna.gz`  
    - Runs `gtdbtk identify`, `gtdbtk align`, and `gtdbtk classify` into `<outdir>/identify/`, `<outdir>/align/`, and `<outdir>/classify/`  

- `runInfernalAndTrnaScanSE.py` and `runGTDBtk.py` should be run before building the consolidated table.

- `createConsolidatedTableForMAGs.py`  
  Integrates multiple result sources into a single MAG-level table.
  - **Inputs (expected filenames):**  
    - `fastANI_EPIC_MAGs_to_SMGC.txt` – fastANI results of EPIC MAGs vs SMGC genomes  
    - `fastANI_EPIC_MAGs_to_EPIC_Isolates.txt` – fastANI vs EPIC isolate genomes  
    - `CheckM2_Results_quality_report.tsv` – completeness/contamination from CheckM2  
    - `gtdbtk.bac120.summary.tsv` – GTDB-Tk taxonomy results  
    - `AbyssFac_Stats.txt` – assembly metrics (N50, genome size)  
    - `tRNAScan-SE_Results/` – tRNA hits per MAG  
    - `Infernal_Results/` – rRNA hits per MAG  
  - **Output:** A tab-delimited table to stdout with columns including:  
    - sample, MAG quality (low/medium/high)  
    - completeness, contamination  
    - N50 and genome size  
    - distinct tRNAs and rRNAs  
    - novelty flags (potentially novel species, novel and not matching SMGC/EPIC)  
    - whether each MAG matches an EPIC isolate or SMGC genome at >95% ANI and >20% aligned fraction  
    - GTDB taxonomy and closest SMGC/EPIC hits with ANI and alignment fractions  
  - **Usage (example):**
    ```bash
    cd Consolidated_Table
    python createConsolidatedTableForMAGs.py > Consolidated_Species_Representative_MAGs.txt
    ```
---

### Typical workflow

1. **Assemble reads:** Use `runMetaSpades.py` to generate metaSPAdes assemblies for all samples.  
2. **Bin & refine MAGs:** Use `runMetawrap.py` to run MetaWRAP binning and refinement.  
3. **Extract MAG FASTAs:** Run `extractMagsInFasta.py` to write per-MAG FASTA files.  
4. **Run quality and taxonomy tools:**  
   - Run CheckM2 on MAG FASTAs.  
   - Run `runInfernalAndTrnaScanSE.py` for rRNA/tRNA detection.  
   - Run `runGTDBtk.py` to classify MAGs with GTDB-Tk.  
5. **Run fastANI comparisons:** Generate `fastANI_EPIC_MAGs_to_EPIC_Isolates.txt` and `fastANI_EPIC_MAGs_to_SMGC.txt`.  
6. **Create consolidated table:**  
   ```bash
   cd Consolidated_Table
   python createConsolidatedTableForMAGs.py > Consolidated_Species_Representative_MAGs.txt
   ```

---

### Dependencies

- **Assemblies & binning:** `metaSPAdes`, `metawrap`, `unpigz`  
- **MAG extraction & consolidation scripts:** `Biopython`
- **QC and annotation:** `CheckM2`, `tRNAscan-SE`, `INFERNAL` (`cmsearch`), `GTDB-Tk`, `fastANI`  

