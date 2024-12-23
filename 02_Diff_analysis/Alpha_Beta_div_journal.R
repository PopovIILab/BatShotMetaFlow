main_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(main_dir)

if (!require("pacman"))
  install.packages("pacman")

pacman::p_load(tidyverse, ggtext, patchwork, vegan, glue, scales)

###################
# Alpha-diversity #
###################

Alpha <- read.csv("Alpha_div/alpha_div_cult.csv")
metadata <- read.csv("metadata.csv")

names(Alpha)[1] <- "sample_id"
names(Alpha)[7] <- "shannon"
names(Alpha)[8] <- "eveness"
Alpha$status <- metadata$Group

shannon_res <- wilcox.test(shannon ~ status,
                           data = Alpha,
                           correct = FALSE,
                           exact = FALSE)
chao1_res <- wilcox.test(S.chao1 ~ status,
                         data = Alpha,
                         correct = FALSE,
                         exact = FALSE)
eveness_res <- wilcox.test(eveness ~ status,
                           data = Alpha,
                           correct = FALSE,
                           exact = FALSE)

pvals <- c(shannon_res$p.value, chao1_res$p.value, eveness_res$p.value)


#####################
###### SHANNON ######
#####################

shannon <- Alpha %>%
  mutate(status = factor(status, levels = c("Vespertilio murinus", "Nyctalus noctula"))) %>%
  ggplot(aes(x = status, y = shannon, fill = status)) +
  geom_boxplot(
    width = 0.25,
    size = 0.5,
    shape = 21,
    color = "black",
    show.legend = FALSE
  ) +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black")
  ) +
  scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
  scale_fill_manual(name = "Bat species", values = c("#0000FF", "#FF0000")) +
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    legend.key = element_blank()
  ) +
  theme(text = element_text(size = 14)) +
  annotate(
    geom = "richtext",
    x = 1.5,
    y = 6,
    label = "M-W, <i>p</i>-value=0.075",
    size = 4.5,
    label.color = NA
  ) +
  theme(axis.title.x = element_blank(),
        legend.text = element_markdown(face = "italic")) +
  labs(y = "Shannon index")

#####################
###### CHAO1 ########
#####################

chao1 <- Alpha %>%
  mutate(status = factor(status, levels = c("Vespertilio murinus", "Nyctalus noctula"))) %>%
  ggplot(aes(x = status, y = S.chao1, fill = status)) +
  geom_boxplot(
    width = 0.25,
    size = 0.5,
    shape = 21,
    color = "black",
    show.legend = FALSE
  ) +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black")
  ) +
  scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
  scale_fill_manual(name = "Bat species", values = c("#0000FF", "#FF0000")) +
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    legend.key = element_blank()
  ) +
  theme(text = element_text(size = 14)) +
  annotate(
    geom = "richtext",
    x = 1.5,
    y = 12600,
    label = "M-W, <i>p</i>-value=0.028",
    size = 4.5,
    label.color = NA
  ) +
  theme(axis.title.x = element_blank(),
        legend.text = element_markdown(face = "italic")) +
  labs(y = "Chao1 index")

####################
###### PIELOU ######
####################

pielou <- Alpha %>%
  mutate(status = factor(status, levels = c("Vespertilio murinus", "Nyctalus noctula"))) %>%
  ggplot(aes(x = status, y = eveness, fill = status)) +
  geom_boxplot(
    width = 0.25,
    size = 0.5,
    shape = 21,
    color = "black",
    show.legend = FALSE
  ) +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black")
  ) +
  scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
  scale_fill_manual(name = "Bat species", values = c("#0000FF", "#FF0000")) +
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    legend.key = element_blank()
  ) +
  theme(text = element_text(size = 14)) +
  annotate(
    geom = "richtext",
    x = 1.5,
    y = 0.65,
    label = "M-W, <i>p</i>-value=0.075",
    size = 4.5,
    label.color = NA
  ) +
  theme(axis.title.x = element_blank(),
        legend.text = element_markdown(face = "italic")) +
  labs(y = "Pielou index")


##################
# Beta-diversity #
##################

metadata <- read.table('metadata.csv',
                       sep = ',',
                       comment = '',
                       head = T) %>%
  mutate(
    status = factor(Group),
    status = fct_relevel(Group, "Vespertilio murinus", "Nyctalus noctula")
  )

taxon_counts <- read.table(
  'counts/csv/counts_species.csv',
  sep = ',',
  comment = '',
  row.names = 1
)

##################
###### Bray ######
##################

bray <- avgdist(taxon_counts, dmethod = "bray", sample = 10000) %>%
  as.matrix() %>%
  as_tibble(rownames = "sample_id")

bray_dist_matrix <- bray %>%
  pivot_longer(cols = -sample_id,
               names_to = "b",
               values_to = "distances") %>%
  dplyr::inner_join(., metadata, by = "sample_id") %>%
  dplyr::inner_join(., metadata, by = c("b" = "sample_id")) %>%
  dplyr::select(sample_id, b, distances) %>%
  pivot_wider(names_from = "b", values_from = "distances") %>%
  dplyr::select(-sample_id) %>%
  as.dist()

set.seed(42)
adonis2(as.dist(bray_dist_matrix) ~ metadata$status, method = "bray")

pcoa_bray <- cmdscale(bray_dist_matrix, eig = TRUE, add = TRUE)

positions_bray <- pcoa_bray$points
colnames(positions_bray) <- c("pcoa1", "pcoa2")

percent_explained_bray <- 100 * pcoa_bray$eig / sum(pcoa_bray$eig)

pretty_pe_bray <- format(round(percent_explained_bray, digits = 1),
                         nsmall = 1,
                         trim = TRUE)

labels_bray <- c(glue("PCo Axis 1 ({pretty_pe_bray[1]}%)"),
                 glue("PCo Axis 2 ({pretty_pe_bray[2]}%)"))

PCOA_bray_plot <- positions_bray %>%
  as_tibble(rownames = "sample_id") %>%
  dplyr::inner_join(., metadata, by = "sample_id") %>%
  ggplot(aes(x = pcoa1, y = pcoa2, color = status)) +
  geom_point() +
  labs(x = labels_bray[1], y = labels_bray[2]) +
  scale_color_manual(
    name = "Bat species",
    breaks = c("Vespertilio murinus", "Nyctalus noctula"),
    labels = c("Vespertilio murinus", "Nyctalus noctula"),
    values = c(
      alpha("#0000FF", 0.5),
      alpha("#FF0000", 0.5),
      alpha("gray", 0.5)
    )
  ) +
  stat_ellipse(show.legend = FALSE) +
  annotate(
    geom = 'richtext',
    x = 0.5,
    y = 0.8,
    label = "PERMANOVA<br><i>p</i>-value=0.047",
    size = 4,
    fill = NA,
    label.color = NA
  ) +
  theme_classic() +
  theme(legend.text = element_text(face = "italic"),
        legend.position = "bottom") +
  theme(text = element_text(size = 16)) +
  ylim(-1.0, 1.1)

#####################
###### Jaccard ######
#####################

jaccard <- avgdist(taxon_counts, dmethod = "jaccard", sample = 10000) %>%
  as.matrix() %>%
  as_tibble(rownames = "sample_id")

jaccard_dist_matrix <- jaccard %>%
  pivot_longer(cols = -sample_id,
               names_to = "b",
               values_to = "distances") %>%
  dplyr::inner_join(., metadata, by = "sample_id") %>%
  dplyr::inner_join(., metadata, by = c("b" = "sample_id")) %>%
  dplyr::select(sample_id, b, distances) %>%
  pivot_wider(names_from = "b", values_from = "distances") %>%
  dplyr::select(-sample_id) %>%
  as.dist()

set.seed(42)
adonis2(as.dist(jaccard_dist_matrix) ~ metadata$status, method = "jaccard")

pcoa_jaccard <- cmdscale(jaccard_dist_matrix, eig = TRUE, add = TRUE)

positions_jaccard <- pcoa_jaccard$points
colnames(positions_jaccard) <- c("pcoa1", "pcoa2")

percent_explained_jaccard <- 100 * pcoa_jaccard$eig / sum(pcoa_jaccard$eig)

pretty_pe_jaccard <- format(round(percent_explained_jaccard, digits = 1),
                            nsmall = 1,
                            trim = TRUE)

labels_jaccard <- c(
  glue("PCo Axis 1 ({pretty_pe_jaccard[1]}%)"),
  glue("PCo Axis 2 ({pretty_pe_jaccard[2]}%)")
)

PCOA_jaccard_plot <- positions_jaccard %>%
  as_tibble(rownames = "sample_id") %>%
  dplyr::inner_join(., metadata, by = "sample_id") %>%
  ggplot(aes(x = pcoa1, y = pcoa2, color = status)) +
  geom_point() +
  labs(x = labels_jaccard[1], y = labels_jaccard[2]) +
  scale_color_manual(
    name = "Bat species",
    breaks = c("Vespertilio murinus", "Nyctalus noctula"),
    labels = c("Vespertilio murinus", "Nyctalus noctula"),
    values = c(
      alpha("#0000FF", 0.5),
      alpha("#FF0000", 0.5),
      alpha("gray", 0.5)
    )
  ) +
  stat_ellipse(show.legend = FALSE) +
  annotate(
    geom = 'richtext',
    x = 0.5,
    y = 0.5,
    label = "PERMANOVA<br><i>p</i>-value=0.047",
    size = 4,
    fill = NA,
    label.color = NA
  ) +
  theme_classic() +
  theme(legend.text = element_text(face = "italic"),
        legend.position = "bottom") +
  theme(text = element_text(size = 16))

######################
###### COMBINED ######
######################

combined_alpha <- shannon + chao1 + pielou

combined_beta <- (PCOA_bray_plot + PCOA_jaccard_plot) +
  plot_layout(guides = "collect") &
  theme(legend.position = "bottom")

combined <- (combined_alpha / combined_beta) &
  plot_annotation(tag_levels = list(c("A", "B", "C", "D")))

ggsave(
  "images/alpha_beta_div/combined.png",
  plot = combined,
  width = 14,
  height = 8,
  dpi = 600
)
