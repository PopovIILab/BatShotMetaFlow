main_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(main_dir)

if (!require("pacman"))
  install.packages("pacman")

pacman::p_load(tidyverse, reshape2, patchwork, ggtext, ggVennDiagram)

df_bar_plot <- read.csv("ABRicate_results/summary/tsv/merged_summary.tsv", sep = "\t") %>%
  filter(SAMPLE != "D4") %>%
  mutate(
    SAMPLE = str_replace(SAMPLE, "D1", "VM1"),
    SAMPLE = str_replace(SAMPLE, "D2", "VM2"),
    SAMPLE = str_replace(SAMPLE, "D3", "VM3"),
    SAMPLE = str_replace(SAMPLE, "D5", "VM5"),
    SAMPLE = str_replace(SAMPLE, "P1", "NN1"),
    SAMPLE = str_replace(SAMPLE, "P2", "NN2"),
    SAMPLE = str_replace(SAMPLE, "P3", "NN3"),
    SAMPLE = str_replace(SAMPLE, "P4", "NN4"),
    SAMPLE = str_replace(SAMPLE, "P5", "NN5")
  )

df_bar_plot_long <- melt(
  df_bar_plot,
  id.vars = "SAMPLE",
  variable.name = "database",
  value.name = "number"
)

barplot <- df_bar_plot_long %>%
  ggplot(aes(x = SAMPLE, y = number, fill = database)) +
  geom_hline(
    yintercept = seq(50, 200, by = 50),
    linetype = "dashed",
    color = "gray"
  ) +
  geom_vline(
    xintercept = seq(1.5, length(unique(
      df_bar_plot_long$SAMPLE
    )) - 0.5, by = 1),
    linetype = "dashed",
    color = "black"
  ) +
  geom_bar(
    stat = "identity",
    position = position_dodge(width = 0.9),
    color = "black"
  ) +
  theme_classic() +
  labs(x = NULL, y = "Genes number") +
  scale_fill_manual(
    name = "Database",
    breaks = c("card", "resfinder", "vfdb"),
    labels = c("CARD", "ResFinder", "VFDB"),
    values = c("#8DA0CB", '#FC8D62', "#66C2A5")
  ) +
  theme(legend.title = element_text(size = 14),
        legend.text = element_text(size = 14)) +
  geom_text(
    aes(label = number),
    position = position_dodge(width = 0.9),
    vjust = -0.5,
    size = 3.5
  ) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 250)) +
  theme(axis.ticks.length = unit(0.25, "cm"))

ggsave(
  "images/ABRicate_barplot.png",
  plot = barplot,
  width = 12,
  height = 6,
  dpi = 600
)

transform_colnames <- function(colnames) {
  colnames %>%
    gsub("_", " ", .) %>%
    gsub("Klebsiella pneumoniae", "*Klebsiella pneumoniae*", .) %>%
    gsub("Pseudomonas aeruginosa", "*Pseudomonas aeruginosa*", .) %>%
    gsub("Enterobacter cloacae", "*Enterobacter cloacae*", .) %>%
    gsub("Escherichia coli", "*Escherichia coli*", .)
}

########
# CARD #
########

df_card <- read.csv(
  "ABRicate_results/summary/presence/card_presence.tsv",
  sep = "\t",
  check.names = FALSE
) %>%
  filter(SAMPLE != "D4") %>%
  mutate(
    SAMPLE = str_replace(SAMPLE, "D1", "VM1"),
    SAMPLE = str_replace(SAMPLE, "D2", "VM2"),
    SAMPLE = str_replace(SAMPLE, "D3", "VM3"),
    SAMPLE = str_replace(SAMPLE, "D5", "VM5"),
    SAMPLE = str_replace(SAMPLE, "P1", "NN1"),
    SAMPLE = str_replace(SAMPLE, "P2", "NN2"),
    SAMPLE = str_replace(SAMPLE, "P3", "NN3"),
    SAMPLE = str_replace(SAMPLE, "P4", "NN4"),
    SAMPLE = str_replace(SAMPLE, "P5", "NN5")
  )

colnames(df_card) <- transform_colnames(colnames(df_card))

df_card_long <- melt(
  df_card,
  id.vars = "SAMPLE",
  variable.name = "ARG",
  value.name = "presence"
) %>%
  filter(ARG != "NUM FOUND")

heatmap_card <- ggplot(df_card_long, aes(x = SAMPLE, y = ARG, fill = presence)) +
  geom_tile(color = "black",
            linewidth = 0.25,
            show.legend = FALSE) +
  scale_fill_manual(#name = "ARG presence",
    breaks = c("plus", "minus"),
    #labels = c("Present", "Absent"),
    values = c("#8DA0CB", "white")) +
  theme_classic() +
  labs(x = NULL, y = NULL) +
  theme(axis.line = element_blank(), axis.text = element_markdown())
#axis.text.x = element_text(size=18, angle=35, hjust=1)

ggsave(
  "images/ABRicate_heatmap_card.png",
  plot = heatmap_card,
  width = 6,
  height = 16,
  dpi = 600
)

#############
# RESFINDER #
#############

df_resfinder <- read.csv(
  "ABRicate_results/summary/presence/resfinder_presence.tsv",
  sep = "\t",
  check.names = FALSE
) %>%
  filter(SAMPLE != "D4") %>%
  mutate(
    SAMPLE = str_replace(SAMPLE, "D1", "VM1"),
    SAMPLE = str_replace(SAMPLE, "D2", "VM2"),
    SAMPLE = str_replace(SAMPLE, "D3", "VM3"),
    SAMPLE = str_replace(SAMPLE, "D5", "VM5"),
    SAMPLE = str_replace(SAMPLE, "P1", "NN1"),
    SAMPLE = str_replace(SAMPLE, "P2", "NN2"),
    SAMPLE = str_replace(SAMPLE, "P3", "NN3"),
    SAMPLE = str_replace(SAMPLE, "P4", "NN4"),
    SAMPLE = str_replace(SAMPLE, "P5", "NN5")
  )

colnames(df_resfinder) <- transform_colnames(colnames(df_resfinder))

df_resfinder_long <- melt(
  df_resfinder,
  id.vars = "SAMPLE",
  variable.name = "ARG",
  value.name = "presence"
) %>%
  filter(ARG != "NUM FOUND")

df_resfinder_long <- df_resfinder_long %>%
  mutate(ARG = word(ARG, 1))

heatmap_resfinder <- ggplot(df_resfinder_long, aes(x = SAMPLE, y = ARG, fill = presence)) +
  geom_tile(color = "black",
            linewidth = 0.25,
            show.legend = FALSE) +
  scale_fill_manual(#name = "ARG presence",
    breaks = c("plus", "minus"),
    #labels = c("Present", "Absent"),
    values = c("#FC8D62", "white")) +
  theme_classic() +
  labs(x = NULL, y = NULL) +
  theme(axis.line = element_blank(), axis.text = element_markdown())
#axis.text.x = element_text(size=18, angle=35, hjust=1)

ggsave(
  "images/ABRicate_heatmap_resfinder.png",
  plot = heatmap_resfinder,
  width = 6,
  height = 8,
  dpi = 600
)

########
# VFDB #
########

df_vfdb <- read.csv(
  "ABRicate_results/summary/presence/vfdb_presence.tsv",
  sep = "\t",
  check.names = FALSE
) %>%
  filter(SAMPLE != "D4") %>%
  filter(SAMPLE != "P3") %>%
  mutate(
    SAMPLE = str_replace(SAMPLE, "D1", "VM1"),
    SAMPLE = str_replace(SAMPLE, "D2", "VM2"),
    SAMPLE = str_replace(SAMPLE, "D3", "VM3"),
    SAMPLE = str_replace(SAMPLE, "D5", "VM5"),
    SAMPLE = str_replace(SAMPLE, "P1", "NN1"),
    SAMPLE = str_replace(SAMPLE, "P2", "NN2"),
    SAMPLE = str_replace(SAMPLE, "P3", "NN3"),
    SAMPLE = str_replace(SAMPLE, "P4", "NN4"),
    SAMPLE = str_replace(SAMPLE, "P5", "NN5")
  )

df_vfdb <- df_vfdb %>%
  select(-"NUM_FOUND")

colnames(df_vfdb) <- transform_colnames(colnames(df_vfdb))

# Extract the SAMPLE column
SAMPLE <- df_vfdb[, "SAMPLE"]

# Remove the SAMPLE column from the dataframe
df_vfdb_no_sample <- df_vfdb[, -1]

# Number of columns to include in each part
n_col_part1 <- 105
n_col_part2 <- 105
n_col_part3 <- 104

# Split the dataframe into three parts
df_vfdb_part1 <- cbind(SAMPLE, df_vfdb_no_sample[, 1:n_col_part1])
df_vfdb_part2 <- cbind(SAMPLE, df_vfdb_no_sample[, (n_col_part1 + 1):(n_col_part1 + n_col_part2)])
df_vfdb_part3 <- cbind(SAMPLE, df_vfdb_no_sample[, (n_col_part1 + n_col_part2 + 1):(n_col_part1 + n_col_part2 + n_col_part3)])

# VFDB: PART 1 #

df_vfdb_part1_long <- melt(
  df_vfdb_part1,
  id.vars = "SAMPLE",
  variable.name = "ARG",
  value.name = "presence"
)

heatmap_vfdb_part1 <- ggplot(df_vfdb_part1_long, aes(x = SAMPLE, y = ARG, fill = presence)) +
  geom_tile(color = "black",
            linewidth = 0.25,
            show.legend = FALSE) +
  scale_fill_manual(#name = "ARG presence",
    breaks = c("plus", "minus"),
    #labels = c("Present", "Absent"),
    values = c("#66C2A5", "white")) +
  theme_classic() +
  labs(x = NULL, y = NULL) +
  theme(axis.line = element_blank(), axis.text = element_markdown())
#axis.text.x = element_text(size=18, angle=35, hjust=1)

# VFDB: PART 2 #

df_vfdb_part2_long <- melt(
  df_vfdb_part2,
  id.vars = "SAMPLE",
  variable.name = "ARG",
  value.name = "presence"
)

heatmap_vfdb_part2 <- ggplot(df_vfdb_part2_long, aes(x = SAMPLE, y = ARG, fill = presence)) +
  geom_tile(color = "black",
            linewidth = 0.25,
            show.legend = FALSE) +
  scale_fill_manual(#name = "ARG presence",
    breaks = c("plus", "minus"),
    #labels = c("Present", "Absent"),
    values = c("#66C2A5", "white")) +
  theme_classic() +
  labs(x = NULL, y = NULL) +
  theme(axis.line = element_blank(), axis.text = element_markdown())
#axis.text.x = element_text(size=18, angle=35, hjust=1)

# VFDB: PART 3 #

df_vfdb_part3_long <- melt(
  df_vfdb_part3,
  id.vars = "SAMPLE",
  variable.name = "ARG",
  value.name = "presence"
)

heatmap_vfdb_part3 <- ggplot(df_vfdb_part3_long, aes(x = SAMPLE, y = ARG, fill = presence)) +
  geom_tile(color = "black",
            linewidth = 0.25,
            show.legend = FALSE) +
  scale_fill_manual(#name = "ARG presence",
    breaks = c("plus", "minus"),
    #labels = c("Present", "Absent"),
    values = c("#66C2A5", "white")) +
  theme_classic() +
  labs(x = NULL, y = NULL) +
  theme(axis.line = element_blank(), axis.text = element_markdown())
#axis.text.x = element_text(size=18, angle=35, hjust=1)

# VFDB: ALLTOGETHER #

VFDB_combined <- heatmap_vfdb_part1 + heatmap_vfdb_part2 + heatmap_vfdb_part3 &
  plot_annotation(tag_levels = list(c("A", "B", "C")))

ggsave(
  "images/ABRicate_heatmap_vfdb_all.png",
  plot = VFDB_combined,
  width = 20,
  height = 16,
  dpi = 600
)

###############
# Wombo Combo #
###############

wombo <- (barplot / (heatmap_card + heatmap_resfinder)) +
  plot_layout(heights = c(3, 14))

wombo_combo <- (wombo | VFDB_combined) +
  plot_layout(heights = c(17)) +
  plot_annotation(tag_levels = list(c('A', 'B', 'C', 'D')))

ggsave(
  "images/ABRicate_wombo_combo.png",
  plot = wombo_combo,
  width = 22,
  height = 17,
  dpi = 600
)

################
# Venn Diagram #
################

set_A <- paste0("A", 1:121)
set_B <- c(paste0("A", 1:32), paste0("B", 1:21))

venn_list <- list(CARD = set_A, ResFinder = set_B)

venn <- Venn(venn_list)
data <- process_data(venn, shape_id = "201")

region_labels <- venn_regionlabel(data)

custom_colors <- c("1" = "#8DA0CB", "2" = "#FC8D62", "3" = "#BF9FB0")

venn_diag <- ggplot() +
  geom_polygon(
    data = venn_regionedge(data),
    aes(X, Y, group = id, fill = id),
    color = "black",
    linewidth = 1.2,
    show.legend = FALSE
  ) +
  geom_path(
    data = venn_setedge(data),
    aes(X, Y, group = id),
    color = "black",
    linewidth = 1.2,
    show.legend = FALSE
  ) +
  geom_label(
    data = venn_regionlabel(data),
    aes(X, Y, label = count),
    size = 4
  ) +
  scale_fill_manual(values = custom_colors) +
  coord_equal() +
  theme_void()

ggsave(
  "images/venn_diag.png",
  plot = venn_diag,
  width = 11,
  height = 3,
  dpi = 600
)

#####################
# Wombo Ultra Combo #
#####################

resfinder_venn <- (heatmap_resfinder / venn_diag) +
  plot_layout(heights = c(11, 3))

wombo_ultra <- (free(barplot, type = "label") / (heatmap_card + resfinder_venn)) +
  plot_layout(heights = c(3, 14))

wombo_ultra_combo <- (wombo_ultra | VFDB_combined) +
  plot_layout(heights = c(20)) +
  plot_annotation(tag_levels = list(c('A', 'B', 'C', 'D', 'E')))

ggsave(
  "images/ABRicate_wombo_ultra_combo.png",
  plot = wombo_ultra_combo,
  width = 22,
  height = 20,
  dpi = 600
)
