main_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(main_dir)

if (!require("pacman"))
  install.packages("pacman")

pacman::p_load(tidyverse, ggtext, ggrepel)

DAA_pathways <- read.csv("MaAsLin2_on_HUMAnN3_results/all_results.tsv", sep = "\t")

DAA_pathways$diffabund <- "NO"
DAA_pathways$diffabund[DAA_pathways$coef > 1 &
                         DAA_pathways$qval < 0.05 &
                         DAA_pathways$metadata == "Group"] <- "NN_plus"
DAA_pathways$diffabund[DAA_pathways$coef < -1 &
                         DAA_pathways$qval < 0.05 &
                         DAA_pathways$metadata == "Group"] <- "NN_minus"
DAA_pathways$feature[DAA_pathways$diffabund == "NO"] <- NA
DAA_pathways$label <- NA
top_red <- DAA_pathways[DAA_pathways$coef < -1 &
                          DAA_pathways$qval < 0.05 & DAA_pathways$metadata == "Group", ]
top_red <- top_red[order(top_red$qval), ][1:5, ]
DAA_pathways$label[DAA_pathways$feature %in% top_red$feature] <- DAA_pathways$feature[DAA_pathways$feature %in% top_red$feature]
DAA_pathways$label[DAA_pathways$coef > 1 &
                     DAA_pathways$qval < 0.05 &
                     DAA_pathways$metadata == "Group"] <- DAA_pathways$feature[DAA_pathways$coef > 1 &
                                                                                 DAA_pathways$qval < 0.05 & DAA_pathways$metadata == "Group"]

volcano_plot <- ggplot(data = DAA_pathways, aes(
  x = coef,
  y = -log10(qval),
  label = feature,
  col = diffabund
)) +
  geom_point(size = 2) +
  theme_bw() +
  geom_vline(xintercept = c(-1, 1),
             col = "gray",
             linetype = 'dashed') +
  geom_hline(
    yintercept = c(-log10(0.05)),
    col = "gray",
    linetype = 'dashed'
  ) +
  geom_text_repel(
    data = subset(DAA_pathways, !is.na(label)),
    aes(label = label),
    size = 2,
    box.padding = 1,
    point.padding = 0.5,
    max.overlaps = 10,
    nudge_x = 2,
    nudge_y = 3,
    force = 10
  ) +
  scale_color_manual(
    name = NULL,
    values = c("grey"),
    labels = c("<strong>Not significant:</strong><br>q-value>0.05")
  ) +
  labs(x = "Log2fc") +
  theme(
    plot.title = element_text(size = 22),
    legend.text = element_markdown(size = 14),
    plot.caption = element_text(size = 22),
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16, vjust = 0)
  ) +
  guides(colour = guide_legend(override.aes = list(size = 3.5)))

ggsave(
  "images/volcano_plots/volcano_plot.png",
  plot = volcano_plot,
  width = 10,
  height = 6,
  dpi = 600
)
