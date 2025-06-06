#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly=TRUE)

if (!require("pacman")) install.packages("pacman")

pacman::p_load(Maaslin2)

metadata <- read.table(args[1], 
                       sep=',', comment='', head=T)

rownames(metadata) <- metadata[,1]

counts <- read.csv(args[2])

rownames(counts) <- counts[,1]

counts <- subset(counts, select = -Sample_id)

fit_data = Maaslin2(input_data     = counts, 
                    input_metadata = metadata, 
                    min_prevalence = 0.01,
                    min_abundance=50000,
                    normalization  = "TSS",
                    output         = args[3],
                    analysis_method = "LM",
                    max_significance = 0.05,
                    correction = "BH",
                    plot_heatmap = TRUE,
                    plot_scatter = TRUE,
                    fixed_effects  = c("Group"))

