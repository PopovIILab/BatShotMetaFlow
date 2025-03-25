main_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(main_dir)

if (!require("pacman"))
  install.packages("pacman")

pacman::p_load(tidyverse, reshape2, ggtext)

df_heatmap <- read.csv("HUMAnN3_results/pathabundance_filtered_normalized.tsv",
                       sep = "\t")

df_heatmap_long <- melt(
  df_heatmap,
  id.vars = "Pathway",
  variable.name = "Sample",
  value.name = "Abundance"
) %>%
  mutate(
    Sample = str_replace(Sample, "D1", "VM1"),
    Sample = str_replace(Sample, "D2", "VM2"),
    Sample = str_replace(Sample, "D3", "VM3"),
    Sample = str_replace(Sample, "D5", "VM5"),
    Sample = str_replace(Sample, "P1", "NN1"),
    Sample = str_replace(Sample, "P2", "NN2"),
    Sample = str_replace(Sample, "P3", "NN3"),
    Sample = str_replace(Sample, "P4", "NN4"),
    Sample = str_replace(Sample, "P5", "NN5")
  ) %>%
  mutate(
    Pathway = case_when(
      Pathway == "PWY4LZ-257: superpathway of fermentation (Chlamydomonas reinhardtii)" ~
        "PWY4LZ-257: superpathway of fermentation (*Chlamydomonas reinhardtii*)",
      TRUE ~ Pathway
    )
  ) %>%
  filter(!Sample %in% c("NN3", "VM3"))

heatmap <- ggplot(df_heatmap_long, aes(x = Sample, y = Pathway, fill = Abundance)) +
  geom_tile(color = "black", linewidth = 0.25) +
  scale_fill_gradientn(
    colors = c(
      "white",
      "#1BB6AFFF",
      "#088BBEFF",
      "#172869FF",
      "#F4B95AFF",
      "#FCA315FF",
      "#EF7C12FF"
    ),
    name = "Relative abundance"
  ) +
  theme_classic() +
  labs(x = NULL, y = NULL) +
  theme(
    axis.line = element_blank(),
    axis.text.y = element_markdown(size = 10, hjust = 1),
    legend.title = element_text(size = 16),
    legend.text = element_text(size = 20),
    legend.key.height = unit(50, "pt")
  )

ggsave(
  "images/RA_HUMAnN3.png",
  plot = heatmap,
  width = 12,
  height = 10,
  dpi = 600
)
