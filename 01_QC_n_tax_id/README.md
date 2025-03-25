# Bat Shotgun Metagenomic Flow-work

> This is the repository for supplementary materials for the upcoming publication

## Quality Control 💎 and Taxonomic Identification 🪪

**Files**:
- 📑 [`01_Lab_journal.ipynb`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/01_QC_n_tax_id/01_Lab_journal.ipynb) - laboratory journal with commands to reproduce pipeline
- ⚙️ [`QC_pipeline`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/01_QC_n_tax_id/QC_pipeline) - `snakemake` pipeline to run `fastqc` & `multiqc`
- ⚙️ [`kraken2_pipeline`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/01_QC_n_tax_id/kraken2_pipeline) - `snakemake` pipeline to run `kraken2` against `PlusPF` database
- 📑 [`qc_n_tax_id.yaml`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/01_QC_n_tax_id/qc_n_tax_id.yaml) - conda environment

**Instruction**:
- Create new environment `qc_n_tax_id`
```bash
conda env create -f qc_n_tax_id.yaml
```

### System

This part of work was done on DSTU's server
