# Bat Shotgun Metagenomic Flow-work

> This is the repository for supplementary materials for the upcoming publication

## Metagenome-assembled genomes 🧬 

**Files**:
- 📑 [`03_Lab_journal.ipynb`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/03_Metagenomes/03_Lab_journal.ipynb) - laboratory journal with commands to reproduce pipeline
- ⚙️ [`Assembly_pipeline`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/03_Metagenomes/Assembly_pipeline) - `snakemake` pipeline to run `metaSPAdes` & `metaquast`
- 📁 [`metaquast_reports`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/03_Metagenomes/metaquast_reports) - folder with `metaquast` reports:
  - 📁 `{sample}` - reports are stored in folders by samples (D1-5; P1-P5):
    - 📑 `icarus.html` - `icarus` `metaquast` report
    - 📑 `report.html` - main `metaquast` report
- ⚙️ [`Filtering_pipeline`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/03_Metagenomes/Filtering_pipeline) - `snakemake` pipeline to filter out short sequences from MAGs using [`scripts/filter_MAGs.py`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/03_Metagenomes/scripts/filter_MAGs.py) script
- ⚙️ [`HUMAnN3_pipeline`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/03_Metagenomes/HUMAnN3_pipeline) - `snakemake` pipeline to run `HUMAnN3` on every filtered MAG
- 📁 [`scripts`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/03_Metagenomes/scripts) - folder with miscellaneous scripts used for data analysis:
  - 📝 [`filter_MAGs.py`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/03_Metagenomes/scripts/filter_MAGs.py) - script to filter out sequences shorter than 3500 nucleotides from MAGs
  - 📝 [`abr2tsv.py`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/03_Metagenomes/scripts/abr2tsv.py) - script to convert default merged `ABRicate` output to `.tsv` format
  - 📝 [`abr_tsv2presence.py`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/03_Metagenomes/scripts/abr_tsv2presence.py) - script to convert `ABRicate` results from `%COVERAGE` type to `presence/abscence` type
  - 📝 [`filt_humann3.py`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/03_Metagenomes/scripts/filt_humann3.py) - script to filter out redundant info from `HUMAnN3` outputs
  - 📝 [`transpose_humann.py`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/03_Metagenomes/scripts/transpose_humann.py) - script to transpose `HUMAnN3` output & prepare it for input in `MaAsLin2`
  - 📝 [`MaAsLin2.R`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/03_Metagenomes/scripts/MaAsLin2.R) - script to run `MaAsLin2` on `HUMAnN3` results (it purposely does not uses any normalization method)

**Instruction**:
- Create new environment `metagenomes`
```bash
conda env create -f metagenomes.yaml
```

### System

This part of work was done on DSTU's server

<!---
- 📁 [`ABRicate_results/summary`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/03_Metagenomes/ABRicate_results/summary) - folder with merged `ABRicate` summary outputs:
  - 📁 [`presence`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/03_Metagenomes/ABRicate_results/summary/presence) - in `.tsv` file format with `presence/abscence` type
  - 📁 [`tsv`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/03_Metagenomes/ABRicate_results/summary/tsv) - in `.tsv` file format
  - 📁 [`txt`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/03_Metagenomes/ABRicate_results/summary/txt) - in `.txt` file format
- 📁 [`HUMAnN3_results`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/03_Metagenomes/HUMAnN3_results) - folder with `HUMAnN3` results:
  - 📑 [`HUMAnN3_merged_genefamilies.tsv`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/03_Metagenomes/HUMAnN3_results/HUMAnN3_merged_genefamilies.tsv) - merged output with `gene families` info using `UniRef90` database
  - 📑 [`HUMAnN3_merged_pathabundance.tsv`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/03_Metagenomes/HUMAnN3_results/HUMAnN3_merged_pathabundance.tsv) - merged ouput with `pathway abundance` info
  - 📑 [`genefamilies_filtered.tsv`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/03_Metagenomes/HUMAnN3_results/genefamilies_filtered.tsv) - filtered with [`filt_humann3.py`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/03_Metagenomes/scripts/filt_humann3.py) script gene families table
  - 📑 [genefamilies_filtered_normalized.tsv](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/03_Metagenomes/HUMAnN3_results/genefamilies_filtered_normalized.tsv) - filtered & normalized gene families table
  - 📑 [`pathabundance_filtered.tsv`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/03_Metagenomes/HUMAnN3_results/pathabundance_filtered.tsv) - filtered with [`filt_humann3.py`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/03_Metagenomes/scripts/filt_humann3.py) script pathway abundance table
  - 📑 [genefamilies_filtered_normalized.tsv](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/03_Metagenomes/HUMAnN3_results/genefamilies_filtered_normalized.tsv) - filtered & normalized pathway abundance table
  - 📑 [`pathabundance_transposed.csv`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/03_Metagenomes/HUMAnN3_results/pathabundance_transposed.csv) - transposed, filtered & normalized pathway abundance table ready for input to `MaAsLin2`
- 📁 [`MaAsLin2_on_HUMAnN3_results`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/03_Metagenomes/MaAsLin2_on_HUMAnN3_results) - folder with `MaAsLin2` on `HUMAnN3` results:
  - 📑 [`all_results.tsv`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/03_Metagenomes/MaAsLin2_on_HUMAnN3_results/all_results.tsv) -  `.tsv` file with all results
  - 📑 [`significant_results.tsv`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/03_Metagenomes/MaAsLin2_on_HUMAnN3_results/significant_results.tsv) - `.tsv` file with significant results only
- 📑 [`ABRicate_barplots_journal.R`](ABRicate_barplots_journal.R) - laboratory journal to plot `ABRicate` results as `bar-plots`
- 📑 [`ABRicate_heatmaps_journal.R`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/03_Metagenomes/ABRicate_heatmaps_journal.R) - laboratory journal to plot `ABRicate` results as `heatmaps`
- 📑 [`HUMAnN3_heatmaps_journal.R`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/03_Metagenomes/HUMAnN3_heatmaps_journal.R) - laboratory journal to plot `HUMAnN3` results as `heatmap` (pathway abundance table only)
- 📑 [`mags.yaml`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/02_Diff_analysis/mags.yaml) - conda environment
-->
