# Bat Shotgun Metagenomic Flow-work

> This is the repository for supplementary materials for the upcoming publication

## Densoviruses 🦠

**Files**:
- 📑 [`04_Lab_journal.ipynb`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/04_Densoviruses/04_Lab_journal.ipynb) - laboratory journal with commands to reproduce pipeline
- ⚙️ [`VirExtr_pipeline`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/04_Densoviruses/VirExtr_pipeline) - `snakemake` pipeline to extract densoviral sequences from MAGs using custom `BLAST` database, [`scripts/extract_seqs.py`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/04_Densoviruses/scripts/extract_seqs.py) script and `VirSorter2`
- ⚙️ [`GA_pipeline`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/04_Densoviruses/GA_pipeline) - `snakemake` pipeline to annotate densoviral genomes using `prokka`
- 📁 [`scripts`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/04_Densoviruses/scripts) - folder with miscellaneous scripts used for data analysis:
  - 📝 [`extract_seqs.py`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/04_Densoviruses/scripts/extract_seqs.py) - script to extract longest alignment sequences according to `BLAST` results from filtered MAGs
  - 📝 [`rename_seqs.py`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/04_Densoviruses/scripts/rename_seqs.py) - script to rename sequences from `>NODE_632_length_4705_cov_657475.178280` to `Densovirinae_sp._isolate_RBHC_VM_#` etc.
  - 📝 [`add_space_gbk.py`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/04_Densoviruses/scripts/add_space_gbk.py) - script that fixes `prokka` output by adding space between seq name and seq length making it eligable for input in `Proksee`
  - 📝 [`midpoint_root.py`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/04_Densoviruses/scripts/midpoint_root.py) - script to root phylogenetic tree at mid point
- 📁 [`BLAST_vs_Densoviruses`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/04_Densoviruses/BLAST_vs_densovirus) - folder with `BLAST` outputs of running filtered MAGs against custom `BLAST` database containing densoviruses complete genomes from `RefSeq`
- 📁 [`VirSorter2_results`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/04_Densoviruses/VirSorter2_results) - folder with results of running `VirSorter2` on extracted from MAGs densoviral genomes:
  - 📁 `{sample}` - results are stored in folders by samples (D1-5; P1-P5):
    - 📑 `final-viral-boundary.tsv`
    - 📑 `final-viral-score.tsv`
- 📁 [`prokka_results`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/04_Densoviruses/prokka_results) - folder with results of running `prokka` on extracted from MAGs densoviral genomes:
  - 📁 `annotated_densovirus_{sample}` - results are stored in folders by samples (D1-5; P1-P5):
    - 📑 `Densovirus_{sample}_annot.tsv` - table of genes and CDS
- 📁 [`ANI`](https://github.com/PopovIILab/BatShotMetaFlow/tree/main/04_Densoviruses/ANI) - folder with results of extracted from MAGs densoviral genomes comparison using `fastANI`:
  - 📑 [`fastani.out`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/04_Densoviruses/ANI/fastani.out)
  - 📑 [`fastani.out.matrix`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/04_Densoviruses/ANI/fastani.out.matrix)
  - 📑 [`querylist.txt`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/04_Densoviruses/ANI/querylist.txt) - `fastANI` input file
  - 📑 [`reflist.txt`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/04_Densoviruses/ANI/reflist.txt) - `fastANI` input file
- 📑 [`denso.yaml`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/04_Densoviruses/denso.yaml) - conda environment
- 📑 [`vs2.yaml`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/04_Densoviruses/vs2.yaml) - conda environment

**Instruction**:
- Create new environment `denso`
```bash
conda env create -f denso.yaml
```
- Create new environment `vs2`
```bash
conda env create -f vs2.yaml
```
For running lab journal use `denso.yaml` environment. `vs2.yaml` environment will be automatically used when running [`VirExtr_pipeline`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/04_Densoviruses/VirExtr_pipeline) snakemake pipeline

### System
This part of work was done using:
- OS: Ubuntu 22.04 (WSL2 on Windows 11 22H2)
- RAM: 32GB (16 for WSL2)
- CPU: Intel Xeon E5-2670v3
