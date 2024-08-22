# Bat Shotgun Metagenomic Flow-work

> This is the repository for supplementary materials for the upcoming publication

## Densoviruses 🦠

**Files**:
- [`04_Lab_journal.ipynb`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/04_Densoviruses/04_Lab_journal.ipynb) - laboratory journal with commands to reproduce pipeline
- [`VirExtr_pipeline`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/04_Densoviruses/VirExtr_pipeline) - `snakemake` pipeline to extract densoviral sequences from MAGs using custom `BLAST` database, [`scripts/extract_seqs.py`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/04_Densoviruses/scripts/extract_seqs.py) script and `VirSorter2`
- [`GA_pipeline`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/04_Densoviruses/GA_pipeline) - `snakemake` pipeline to annotate densoviral genomes using `prokka`

### System
This part of work was done using:
- OS: Ubuntu 22.04 (WSL2 on Windows 11 22H2)
- RAM: 32GB (16 for WSL2)
- CPU: Intel Xeon E5-2670v3
