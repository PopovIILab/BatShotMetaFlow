# Bat Shotgun Metagenomic Flow-work

> This is the repository for supplementary materials for the upcoming publication

## Differential analysis 📊

**Files**:
- 📑 [`02_Lab_journal.ipynb`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/02_Diff_analysis/02_Lab_journal.ipynb) - laboratory journal with commands to reproduce pipeline
- 📁 [`data`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/02_Diff_analysis/data) - folder with `kreport` files obtained from the [taxonomic identification](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/01_QC_n_tax_id) step
  - 📁 [`kreports`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/02_Diff_analysis/data/kreports) - folder with original `kreport` files
  - 📁 [`mpa`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/02_Diff_analysis/data/mpa) - folder with `kreport` files converted to `mpa` format using `KrakenTools`
  - 📑 [`COMBINED.txt`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/02_Diff_analysis/data/COMBINED.txt) - combined `mpa` file
- 📁 [`counts`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/02_Diff_analysis/counts) - folder with counts parsed from the combined `mpa` file:
  - 📁 [`csv`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/02_Diff_analysis/counts/csv) - folder with counts from _species_ to _phylum_ levels in `.csv` file format
  - 📁 [`txt`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/02_Diff_analysis/counts/txt) - folder with counts from _species_ to _phylum_ levels in `.txt` file format 
- 📁 [`scripts`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/02_Diff_analysis/scripts) - folder with miscellaneous scripts used for data analysis:
  - 📝 [`rename_files.py`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/02_Diff_analysis/scripts/rename_files.py) - script to delete `_kraken_report` files name for convenient data parsing further
  - 📝 [`run_kreport2mpa.sh`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/02_Diff_analysis/scripts/run_kreport2mpa.sh) - script to wrap `KrakenTools` function `kreport2mpa` into the cycle to run it on all files in one touch
  - 📝 [`processing_script.py`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/02_Diff_analysis/scripts/processing_script.py) - script to return the 1st row from [`COMBINED.txt`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/02_Diff_analysis/data/COMBINED.txt) file to [`counts.txt`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/02_Diff_analysis/counts/txt) files & to delete '[X]__' and '_' from organisms names
  - 📝 [`convert2csv.py`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/02_Diff_analysis/scripts/convert2csv.py) - script to convert [`counts.txt`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/02_Diff_analysis/counts/txt) files to [`counts.csv`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/02_Diff_analysis/counts/csv) format
  - 📝 [`MaAsLin2.R`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/02_Diff_analysis/scripts/MaAsLin2.R) - script to run `MaAsLin2`
  - 📝 [`Alpha_div_calculations.R`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/02_Diff_analysis/scripts/Alpha_div_calculations.R) - script to calculate α-diversity
- 📑 [`Volcano_plots_journal.R`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/02_Diff_analysis/Volcano_plots_journal.R) - laboratory journal to plot `MaAsLin2` results as a `volcano-plot`
- 📑 [`Bar_plots_journal.R`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/02_Diff_analysis/Bar_plots_journal.R) - laboratory journal to plot `bar-plots` with relative microbial abundance
- 📑 [`Alpha_Beta_div_journal.R`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/02_Diff_analysis/Alpha_Beta_div_journal.R) - laboratory journal to plot α-diversity metrics as `box-plot`s and β-diversity metrics as `PCoA` plots
- 📁 [`Alpha_div`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/02_Diff_analysis/Alpha_div) - folder with α-diversity calculations results:
  - 📑 [`alpha_div_cult.csv`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/02_Diff_analysis/Alpha_div/alpha_div_cult.csv) - α-diversity calculations results
- 📁 [`MaAsLin2_results`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/02_Diff_analysis/MaAsLin2_results) - folder with `MaAsLin2` results:
  - 📁 [`species`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/02_Diff_analysis/MaAsLin2_results/species) - on _species_ level
  - 📁 [`genus`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/02_Diff_analysis/MaAsLin2_results/genus) - on _genus_ level
  - 📁 [`family`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/02_Diff_analysis/MaAsLin2_results/family) - on _family_ level
  - 📁 [`order`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/02_Diff_analysis/MaAsLin2_results/order) - on _order_ level
  - 📁 [`class`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/02_Diff_analysis/MaAsLin2_results/class) - on _class_ level
  - 📁 [`phylum`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/02_Diff_analysis/MaAsLin2_results/phylum) - on _phylum_ level
- 📑 [`diff_an.yaml`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/02_Diff_analysis/diff_an.yaml) - conda environment

**Instruction**:
- Create new environment `diff_an`
```bash
conda env create -f diff_an.yaml
```

### System

This part of work was done using:
- OS: Ubuntu 22.04 (WSL2 on Windows 11 22H2)
- RAM: 32GB (16 for WSL2)
- CPU: Intel Xeon E5-2670v3
