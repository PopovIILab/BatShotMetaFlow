main_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(main_dir)

if (!require("pacman"))
  install.packages("pacman")

pacman::p_load(tidyverse, reshape2, patchwork, ggtext)

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
  "images/ABRicate_heatmaps/heatmap_card.png",
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
  "images/ABRicate_heatmaps/heatmap_resfinder.png",
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

combined <- heatmap_vfdb_part1 + heatmap_vfdb_part2 + heatmap_vfdb_part3 &
  plot_annotation(tag_levels = list(c("A", "B", "C")))
ggsave(
  "images/ABRicate_heatmaps/heatmap_vfdb_all.png",
  plot = combined,
  width = 20,
  height = 16,
  dpi = 600
)

ggsave(
  "images/ABRicate_heatmaps/heatmap_vfdb1.png",
  plot = heatmap_vfdb_part1,
  width = 5,
  height = 16,
  dpi = 600
)
