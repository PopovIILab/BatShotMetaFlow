main_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(main_dir)

if (!require("pacman"))
  install.packages("pacman")

pacman::p_load(ggplot2, patchwork, magick, cowplot)

img_heatmap <- image_read("images/fastANI_heatmap_x90.png") %>%
  image_trim()

heatmap <- ggdraw() + draw_image(img_heatmap)

img_synteny <- image_read("images/synteny_plot.png") %>%
  image_trim()

synteny <- ggdraw() + draw_image(img_synteny)

womdo_combo_genomics <- (heatmap | synteny) +
  plot_layout(heights = c(1)) +
  plot_annotation(tag_levels = "A") &
  theme(plot.tag = element_text(face = "plain"))

ggsave(
  "images/womdo_combo_genomics.png",
  plot = womdo_combo_genomics,
  width = 13.5,
  height = 6.5,
  dpi = 600
)
