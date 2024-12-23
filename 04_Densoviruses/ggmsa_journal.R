main_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(main_dir)

#if (!requireNamespace("devtools", quietly=TRUE))
#install.packages("devtools")
#devtools::install_github("YuLab-SMU/ggmsa")


library(ggmsa)
library(ggplot2)
library(ggplotify)
library(cowplot)

protein_sequences <- 'phylogenomics/trimmed_MSAs/IG/trimmed_family1_renamed.seq.aln'

plot_1 <- ggmsa(
  protein_sequences,
  start = 1,
  end = 100,
  char_width = 0.5,
  seq_name = T
) + geom_seqlogo() + geom_msaBar()
plot_2 <- ggmsa(
  protein_sequences,
  start = 101,
  end = 213,
  char_width = 0.5,
  seq_name = T
) + geom_seqlogo() + geom_msaBar()

p1 <- as.grob(plot_1)
p2 <- as.grob(plot_2)

combined <- plot_grid(p1, p2, ncol = 1, labels = LETTERS[1:2])

ggsave(
  "images/SP2_MSA.png",
  plot = combined,
  width = 25,
  height = 10,
  dpi = 600
)
