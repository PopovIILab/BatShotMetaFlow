main_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(main_dir)

if (!require("pacman")) install.packages("pacman")

pacman::p_load(tidyverse, reshape2, patchwork)

df_bar_plot <- read.csv("ABRicate_results/summary/tsv/merged_summary.tsv", sep = "\t") %>%
  filter(SAMPLE != "D4") %>%
  mutate(SAMPLE = str_replace(SAMPLE, "D1", "VM1"),
         SAMPLE = str_replace(SAMPLE, "D2", "VM2"),
         SAMPLE = str_replace(SAMPLE, "D3", "VM3"),
         SAMPLE = str_replace(SAMPLE, "D5", "VM5"),
         SAMPLE = str_replace(SAMPLE, "P1", "NN1"),
         SAMPLE = str_replace(SAMPLE, "P2", "NN2"),
         SAMPLE = str_replace(SAMPLE, "P3", "NN3"),
         SAMPLE = str_replace(SAMPLE, "P4", "NN4"),
         SAMPLE = str_replace(SAMPLE, "P5", "NN5"))

df_bar_plot_long <- melt(df_bar_plot, id.vars = "SAMPLE", variable.name = "database", value.name = "number")

barplot <- df_bar_plot_long %>%
  ggplot(aes(x = SAMPLE, y = number, fill = database)) +
  geom_hline(yintercept = seq(50, 200, by = 50), linetype = "dashed", color = "gray") +
  geom_vline(xintercept = seq(1.5, length(unique(df_bar_plot_long$SAMPLE)) - 0.5, by = 1), linetype = "dashed", color = "black") +
  geom_bar(stat = "identity", position = position_dodge(width = 0.9), color = "black") +
  theme_classic() +
  labs(x = NULL, y = "Genes number") +
  scale_fill_manual(name = "Database",
                    breaks = c("card", "resfinder", "vfdb"),
                    labels = c("CARD", "ResFinder", "VFDB"),
                    values = c("#8DA0CB", '#FC8D62', "#66C2A5")) +
  theme(legend.title = element_text(size = 14),
        legend.text = element_text(size = 14)) +
  geom_text(aes(label = number), position = position_dodge(width = 0.9), vjust = -0.5, size = 3.5) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 250)) +
  theme(axis.ticks.length = unit(0.25, "cm"))

ggsave("images/ABRicate_barplot/ABRicate_barplot.png", plot = barplot, width = 12, height = 6, dpi = 600)
