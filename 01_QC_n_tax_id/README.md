# Bat Shotgun Metagenomic Flow-work

> This is the repository for supplementary materials for the upcoming publication

## Quality Control 💎 and Taxonomic Identification 🪪

**Files**:
- [`01_Lab_journal.ipynb`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/01_QC_n_tax_id/01_Lab_journal.ipynb) - laboratory journal with commands to reproduce pipeline
- [`QC_pipeline`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/01_QC_n_tax_id/QC_pipeline) - `snakemake` pipeline to run `fastqc` & `multiqc`
- [`kraken2_pipeline`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/01_QC_n_tax_id/kraken2_pipeline) - `snakemake` pipeline to run `kraken2` against `PlusPF` database
- [`fastqc_reports`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/01_QC_n_tax_id/fastqc_reports) - folder with `fastqc` reports:
  - `{sample}` - outputs are stored in folders by samples (D1-5; P1-P5):
    - `{sample}_combined_R1_fastqc.html` - `fastqc` report on forward reads
    - `{sample}_combined_R2_fastqc.html}` - `fastqc` report on reverse reads
- [`multiqc_reports`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/01_QC_n_tax_id/multiqc_reports) - folder with `multi` reports:
  - `{sample}` - outputs are stored in folders by samples (D1-5; P1-P5):
    - multiqc_report.html - merged forward & reverse reads `multiqc` report
- [`qc_n_tax_id.yaml`](https://github.com/PopovIILab/BatShotMetaFlow/blob/main/01_QC_n_tax_id/qc_n_tax_id.yaml) - conda environment

**Instruction**:
- Create new environment `qc_n_tax_id`
```bash
conda env create -f qc_n_tax_id.yaml
```

### System

This part of work was done on DSTU's server
