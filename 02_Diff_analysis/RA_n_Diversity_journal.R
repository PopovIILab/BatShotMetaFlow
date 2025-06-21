main_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(main_dir)

if (!require("pacman"))
  install.packages("pacman")

pacman::p_load(
  tidyverse,
  ggtext,
  patchwork,
  paletteer,
  data.table,
  tibble,
  dplyr,
  tidyr,
  ggplot2,
  scales,
  vegan,
  glue
)

set.seed(42)

#################################
##########Taxa_bar_plots#########
#################################

metadata <- read.csv("metadata.csv")

#####################
###### SPECIES ######
#####################

data_species <- read.csv("data/counts/csv/counts_species_new.csv", check.names = F)
merged_data_species <- merge(data_species, metadata, by.x = "Sample_id", by.y = "sample_id")
long_data_species <- pivot_longer(
  merged_data_species,
  cols = -c(Sample_id, Group),
  names_to = "taxon",
  values_to = "abundance"
)
long_data_species <- select(long_data_species, Sample_id, Group, taxon, abundance)

summarized_data_species <- long_data_species %>%
  group_by(Sample_id, taxon) %>%
  summarize(total_abundance = sum(abundance, na.rm = TRUE),
            .groups = 'drop')


# Preprocess data to calculate percentages and filter based on conditions
data_species_1 <- summarized_data_species %>%
  group_by(Sample_id) %>%
  mutate(total_abundance_group = sum(total_abundance)) %>%
  ungroup() %>%
  mutate(percentage = (total_abundance / total_abundance_group) * 100) %>%
  #filter(!(Group == "positive" & total_abundance < 1)) %>%
  mutate(taxon = ifelse(percentage < 3, "Other (< 3%)", as.character(taxon))) %>%
  group_by(Sample_id, taxon) %>%
  summarize(total_percentage = sum(percentage), .groups = 'drop') %>%
  arrange(Sample_id, desc(total_percentage))

data_species_1$taxon <- factor(data_species_1$taxon, levels = c("Other (< 3%)", unique(data_species_1$taxon[data_species_1$taxon != "Other (< 3%)"])))

# Set specific colors for each taxon
color_palette <- c("Other (< 3%)" = "#837b8d", "Kluyvera ascorbata" = "#9dcc00",
                   "Kluyvera sichuanensis" = "#c20088", "Kluyvera intermedia" = "#e0ff66",
                   "Kluyvera genomosp. 3" = "#990000",
                   setNames(
                     paletteer_d("ggsci::default_igv", n = length(unique(
                       data_species_1$taxon
                     )) - 1),
                     unique(data_species_1$taxon[data_species_1$taxon != "Other (< 3%)"])
                   ))

# Plotting with refined grid settings
species <- ggplot(data_species_1,
                  aes(x = Sample_id, y = total_percentage, fill = taxon)) +
  geom_bar(stat = "identity", width = 0.7) +
  scale_fill_manual(values = color_palette, name = "Species") +
  scale_y_continuous(labels = percent_format(scale = 1)) +
  scale_x_discrete(
    breaks = c("D1", "D2", "D3", "D4", "D5", "P1", "P2", "P3", "P4", "P5"),
    labels = c(
      "VM1",
      "VM2",
      "VM3",
      "VM4",
      "VM5",
      "NN1",
      "NN2",
      "NN3",
      "NN4",
      "NN5"
    )
  ) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x = "Samples", y = "Relative Abundance (%)", fill = "Species") +
  theme_classic() +
  theme(
    legend.text = element_text(face = "italic"),
    legend.key.size = unit(10, "pt"),
    axis.text.x = ggtext::element_markdown()
  )

# Save the plot
ggsave(
  "images/RA_species.png",
  species,
  width = 8.5,
  height = 4,
  dpi = 600
)


###################
###### GENUS ######
###################

data_genus <- read.csv("data/counts/csv/counts_genus.csv", check.names = F)
merged_data_genus <- merge(data_genus, metadata, by.x = "Sample_id", by.y = "sample_id")
long_data_genus <- pivot_longer(
  merged_data_genus,
  cols = -c(Sample_id, Group),
  names_to = "taxon",
  values_to = "abundance"
)
long_data_genus <- select(long_data_genus, Sample_id, Group, taxon, abundance)

summarized_data_genus <- long_data_genus %>%
  group_by(Sample_id, taxon) %>%
  summarize(total_abundance = sum(abundance, na.rm = TRUE),
            .groups = 'drop')


# Preprocess data to calculate percentages and filter based on conditions
data_genus_1 <- summarized_data_genus %>%
  group_by(Sample_id) %>%
  mutate(total_abundance_group = sum(total_abundance)) %>%
  ungroup() %>%
  mutate(percentage = (total_abundance / total_abundance_group) * 100) %>%
  #filter(!(Group == "positive" & total_abundance < 1)) %>%
  mutate(taxon = ifelse(percentage < 3, "Other (< 3%)", as.character(taxon))) %>%
  group_by(Sample_id, taxon) %>%
  summarize(total_percentage = sum(percentage), .groups = 'drop') %>%
  arrange(Sample_id, desc(total_percentage))

data_genus_1$taxon <- factor(data_genus_1$taxon, levels = c("Other (< 3%)", unique(data_genus_1$taxon[data_genus_1$taxon != "Other (< 3%)"])))

# Set specific colors for each taxon
color_palette <- c("Other (< 3%)" = "#837b8d", #"Bradyrhizobium sp. BTAi1" = "#ce3d32",
                   #"Candidatus Kaistella beijingensis" = "#f0e685",
                   setNames(
                     paletteer_d("ggsci::default_igv", n = length(unique(data_genus_1$taxon)) -
                                   1),
                     unique(data_genus_1$taxon[data_genus_1$taxon != "Other (< 3%)"])
                   ))

# Plotting with refined grid settings
genus <- ggplot(data_genus_1,
                aes(x = Sample_id, y = total_percentage, fill = taxon)) +
  geom_bar(stat = "identity", width = 0.7) +
  scale_fill_manual(values = color_palette, name = "Genus") +
  scale_y_continuous(labels = percent_format(scale = 1)) +
  scale_x_discrete(
    breaks = c("D1", "D2", "D3", "D4", "D5", "P1", "P2", "P3", "P4", "P5"),
    labels = c(
      "VM1",
      "VM2",
      "VM3",
      "VM4",
      "VM5",
      "NN1",
      "NN2",
      "NN3",
      "NN4",
      "NN5"
    )
  ) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x = "Samples", y = "Relative Abundance (%)", fill = "Genus") +
  theme_classic() +
  theme(
    legend.text = element_text(face = "italic"),
    legend.key.size = unit(10, "pt"),
    axis.text.x = ggtext::element_markdown()
  )

# Save the plot
ggsave(
  "images/RA_genus.png",
  genus,
  width = 8.5,
  height = 4,
  dpi = 600
)


####################
###### FAMILY ######
####################

data_family <- read.csv("data/counts/csv/counts_family.csv", check.names = F)
merged_data_family <- merge(data_family, metadata, by.x = "Sample_id", by.y = "sample_id")
long_data_family <- pivot_longer(
  merged_data_family,
  cols = -c(Sample_id, Group),
  names_to = "taxon",
  values_to = "abundance"
)
long_data_family <- select(long_data_family, Sample_id, Group, taxon, abundance)

summarized_data_family <- long_data_family %>%
  group_by(Sample_id, taxon) %>%
  summarize(total_abundance = sum(abundance, na.rm = TRUE),
            .groups = 'drop')


# Preprocess data to calculate percentages and filter based on conditions
data_family_1 <- summarized_data_family %>%
  group_by(Sample_id) %>%
  mutate(total_abundance_group = sum(total_abundance)) %>%
  ungroup() %>%
  mutate(percentage = (total_abundance / total_abundance_group) * 100) %>%
  #filter(!(Group == "positive" & total_abundance < 1)) %>%
  mutate(taxon = ifelse(percentage < 3, "Other (< 3%)", as.character(taxon))) %>%
  group_by(Sample_id, taxon) %>%
  summarize(total_percentage = sum(percentage), .groups = 'drop') %>%
  arrange(Sample_id, desc(total_percentage))

data_family_1$taxon <- factor(data_family_1$taxon, levels = c("Other (< 3%)", unique(data_family_1$taxon[data_family_1$taxon != "Other (< 3%)"])))

# Set specific colors for each taxon
color_palette <- c("Other (< 3%)" = "#837b8d", #"Bradyrhizobium sp. BTAi1" = "#ce3d32",
                   #"Candidatus Kaistella beijingensis" = "#f0e685",
                   setNames(
                     paletteer_d("ggsci::default_igv", n = length(unique(
                       data_family_1$taxon
                     )) - 1),
                     unique(data_family_1$taxon[data_family_1$taxon != "Other (< 3%)"])
                   ))

# Plotting with refined grid settings
family <- ggplot(data_family_1,
                 aes(x = Sample_id, y = total_percentage, fill = taxon)) +
  geom_bar(stat = "identity", width = 0.7) +
  scale_fill_manual(values = color_palette, name = "Family") +
  scale_y_continuous(labels = percent_format(scale = 1)) +
  scale_x_discrete(
    breaks = c("D1", "D2", "D3", "D4", "D5", "P1", "P2", "P3", "P4", "P5"),
    labels = c(
      "VM1",
      "VM2",
      "VM3",
      "VM4",
      "VM5",
      "NN1",
      "NN2",
      "NN3",
      "NN4",
      "NN5"
    )
  ) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x = "Samples", y = "Relative Abundance (%)", fill = "Family") +
  theme_classic() +
  theme(
    legend.text = element_text(face = "italic"),
    legend.key.size = unit(10, "pt"),
    axis.text.x = ggtext::element_markdown()
  )

# Save the plot
ggsave(
  "images/RA_family.png",
  family,
  width = 8.5,
  height = 4,
  dpi = 600
)


###################
###### ORDER ######
###################

data_order <- read.csv("data/counts/csv/counts_order.csv", check.names = F)
merged_data_order <- merge(data_order, metadata, by.x = "Sample_id", by.y = "sample_id")
long_data_order <- pivot_longer(
  merged_data_order,
  cols = -c(Sample_id, Group),
  names_to = "taxon",
  values_to = "abundance"
)
long_data_order <- select(long_data_order, Sample_id, Group, taxon, abundance)

summarized_data_order <- long_data_order %>%
  group_by(Sample_id, taxon) %>%
  summarize(total_abundance = sum(abundance, na.rm = TRUE),
            .groups = 'drop')


# Preprocess data to calculate percentages and filter based on conditions
data_order_1 <- summarized_data_order %>%
  group_by(Sample_id) %>%
  mutate(total_abundance_group = sum(total_abundance)) %>%
  ungroup() %>%
  mutate(percentage = (total_abundance / total_abundance_group) * 100) %>%
  #filter(!(Group == "positive" & total_abundance < 1)) %>%
  mutate(taxon = ifelse(percentage < 3, "Other (< 3%)", as.character(taxon))) %>%
  group_by(Sample_id, taxon) %>%
  summarize(total_percentage = sum(percentage), .groups = 'drop') %>%
  arrange(Sample_id, desc(total_percentage))

data_order_1$taxon <- factor(data_order_1$taxon, levels = c("Other (< 3%)", unique(data_order_1$taxon[data_order_1$taxon != "Other (< 3%)"])))

# Set specific colors for each taxon
color_palette <- c("Other (< 3%)" = "#837b8d", #"Bradyrhizobium sp. BTAi1" = "#ce3d32",
                   #"Candidatus Kaistella beijingensis" = "#f0e685",
                   setNames(
                     paletteer_d("ggsci::default_igv", n = length(unique(data_order_1$taxon)) -
                                   1),
                     unique(data_order_1$taxon[data_order_1$taxon != "Other (< 3%)"])
                   ))

# Plotting with refined grid settings
order <- ggplot(data_order_1,
                aes(x = Sample_id, y = total_percentage, fill = taxon)) +
  geom_bar(stat = "identity", width = 0.7) +
  scale_fill_manual(values = color_palette, name = "Order") +
  scale_y_continuous(labels = percent_format(scale = 1)) +
  scale_x_discrete(
    breaks = c("D1", "D2", "D3", "D4", "D5", "P1", "P2", "P3", "P4", "P5"),
    labels = c(
      "VM1",
      "VM2",
      "VM3",
      "VM4",
      "VM5",
      "NN1",
      "NN2",
      "NN3",
      "NN4",
      "NN5"
    )
  ) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x = "Samples", y = "Relative Abundance (%)", fill = "Order") +
  theme_classic() +
  theme(
    legend.text = element_text(face = "italic"),
    legend.key.size = unit(10, "pt"),
    axis.text.x = ggtext::element_markdown()
  )

# Save the plot
ggsave(
  "images/RA_order.png",
  order,
  width = 8.5,
  height = 4,
  dpi = 600
)


###################
###### CLASS ######
###################

data_class <- read.csv("data/counts/csv/counts_class.csv", check.names = F)
merged_data_class <- merge(data_class, metadata, by.x = "Sample_id", by.y = "sample_id")
long_data_class <- pivot_longer(
  merged_data_class,
  cols = -c(Sample_id, Group),
  names_to = "taxon",
  values_to = "abundance"
)
long_data_class <- select(long_data_class, Sample_id, Group, taxon, abundance)

summarized_data_class <- long_data_class %>%
  group_by(Sample_id, taxon) %>%
  summarize(total_abundance = sum(abundance, na.rm = TRUE),
            .groups = 'drop')


# Preprocess data to calculate percentages and filter based on conditions
data_class_1 <- summarized_data_class %>%
  group_by(Sample_id) %>%
  mutate(total_abundance_group = sum(total_abundance)) %>%
  ungroup() %>%
  mutate(percentage = (total_abundance / total_abundance_group) * 100) %>%
  #filter(!(Group == "positive" & total_abundance < 1)) %>%
  mutate(taxon = ifelse(percentage < 3, "Other (< 3%)", as.character(taxon))) %>%
  group_by(Sample_id, taxon) %>%
  summarize(total_percentage = sum(percentage), .groups = 'drop') %>%
  arrange(Sample_id, desc(total_percentage))

data_class_1$taxon <- factor(data_class_1$taxon, levels = c("Other (< 3%)", unique(data_class_1$taxon[data_class_1$taxon != "Other (< 3%)"])))

# Set specific colors for each taxon
color_palette <- c("Other (< 3%)" = "#837b8d", #"Bradyrhizobium sp. BTAi1" = "#ce3d32",
                   #"Candidatus Kaistella beijingensis" = "#f0e685",
                   setNames(
                     paletteer_d("ggsci::default_igv", n = length(unique(data_class_1$taxon)) -
                                   1),
                     unique(data_class_1$taxon[data_class_1$taxon != "Other (< 3%)"])
                   ))

# Plotting with refined grid settings
class <- ggplot(data_class_1,
                aes(x = Sample_id, y = total_percentage, fill = taxon)) +
  geom_bar(stat = "identity", width = 0.7) +
  scale_fill_manual(values = color_palette, name = "Class") +
  scale_y_continuous(labels = percent_format(scale = 1)) +
  scale_x_discrete(
    breaks = c("D1", "D2", "D3", "D4", "D5", "P1", "P2", "P3", "P4", "P5"),
    labels = c(
      "VM1",
      "VM2",
      "VM3",
      "VM4",
      "VM5",
      "NN1",
      "NN2",
      "NN3",
      "NN4",
      "NN5"
    )
  ) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x = "Samples", y = "Relative Abundance (%)", fill = "Class") +
  theme_classic() +
  theme(
    legend.text = element_text(face = "italic"),
    legend.key.size = unit(10, "pt"),
    axis.text.x = ggtext::element_markdown()
  )

# Save the plot
ggsave(
  "images/RA_class.png",
  class,
  width = 8.5,
  height = 4,
  dpi = 600
)


####################
###### PHYLUM ######
####################

data_phylum <- read.csv("data/counts/csv/counts_phylum.csv", check.names = F)
merged_data_phylum <- merge(data_phylum, metadata, by.x = "Sample_id", by.y = "sample_id")
long_data_phylum <- pivot_longer(
  merged_data_phylum,
  cols = -c(Sample_id, Group),
  names_to = "taxon",
  values_to = "abundance"
)
long_data_phylum <- select(long_data_phylum, Sample_id, Group, taxon, abundance)

summarized_data_phylum <- long_data_phylum %>%
  group_by(Sample_id, taxon) %>%
  summarize(total_abundance = sum(abundance, na.rm = TRUE),
            .groups = 'drop')


# Preprocess data to calculate percentages and filter based on conditions
data_phylum_1 <- summarized_data_phylum %>%
  group_by(Sample_id) %>%
  mutate(total_abundance_group = sum(total_abundance)) %>%
  ungroup() %>%
  mutate(percentage = (total_abundance / total_abundance_group) * 100) %>%
  #filter(!(Group == "positive" & total_abundance < 1)) %>%
  mutate(taxon = ifelse(percentage < 3, "Other (< 3%)", as.character(taxon))) %>%
  group_by(Sample_id, taxon) %>%
  summarize(total_percentage = sum(percentage), .groups = 'drop') %>%
  arrange(Sample_id, desc(total_percentage))

data_phylum_1$taxon <- factor(data_phylum_1$taxon, levels = c("Other (< 3%)", unique(data_phylum_1$taxon[data_phylum_1$taxon != "Other (< 3%)"])))

# Set specific colors for each taxon
color_palette <- c("Other (< 3%)" = "#837b8d", #"Bradyrhizobium sp. BTAi1" = "#ce3d32",
                   #"Candidatus Kaistella beijingensis" = "#f0e685",
                   setNames(
                     paletteer_d("ggsci::default_igv", n = length(unique(
                       data_phylum_1$taxon
                     )) - 1),
                     unique(data_phylum_1$taxon[data_phylum_1$taxon != "Other (< 3%)"])
                   ))

# Plotting with refined grid settings
phylum <- ggplot(data_phylum_1,
                 aes(x = Sample_id, y = total_percentage, fill = taxon)) +
  geom_bar(stat = "identity", width = 0.7) +
  scale_fill_manual(values = color_palette, name = "Phylum") +
  scale_y_continuous(labels = percent_format(scale = 1)) +
  scale_x_discrete(
    breaks = c("D1", "D2", "D3", "D4", "D5", "P1", "P2", "P3", "P4", "P5"),
    labels = c(
      "VM1",
      "VM2",
      "VM3",
      "VM4",
      "VM5",
      "NN1",
      "NN2",
      "NN3",
      "NN4",
      "NN5"
    )
  ) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x = "Samples", y = "Relative Abundance (%)", fill = "Phylum") +
  theme_classic() +
  theme(
    legend.text = element_text(face = "italic"),
    legend.key.size = unit(10, "pt"),
    axis.text.x = ggtext::element_markdown()
  )

# Save the plot
ggsave(
  "images/RA_phylum.png",
  phylum,
  width = 8.5,
  height = 4,
  dpi = 600
)


######################
###### COMBINED ######
######################

RA_everything <- (phylum + class + order) / (family + genus + species) + plot_annotation(tag_levels = list(c("A", "B", "C", "D", "E", "F")))
ggsave(
  "images/RA_everything.png",
  plot = RA_everything,
  width = 20,
  height = 8,
  dpi = 600
)

RA_combined <- phylum + family + species + plot_annotation(tag_levels = list(c("A", "B", "C")))
ggsave(
  "images/RA_combined.png",
  plot = RA_combined,
  width = 20,
  height = 4,
  dpi = 600
)

###################
# Alpha-diversity #
###################

Alpha <- read.csv("data/alpha_div_cult.csv")

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
    label = "M-W, <i>p</i>-value=0.117",
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
  scale_y_continuous(labels = scales::label_comma()) +
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
    y = 1.2,
    label = "M-W, <i>p</i>-value=0.174",
    size = 4.5,
    label.color = NA
  ) +
  theme(axis.title.x = element_blank(),
        legend.text = element_markdown(face = "italic")) +
  labs(y = "Pielou index")


##################
# Beta-diversity #
##################

metadata_beta <- read.table('metadata.csv',
                       sep = ',',
                       comment = '',
                       head = T) %>%
  mutate(
    status = factor(Group),
    status = fct_relevel(Group, "Vespertilio murinus", "Nyctalus noctula")
  )

taxon_counts <- read.table(
  'data/counts/csv/counts_species.csv',
  sep = ',',
  comment = '',
  row.names = 1
)

# custom labeller for Unicode minus
minus_label <- function(x) {
  vapply(x, function(i) {
    if (is.na(i)) {
      # drop NA ticks: return blank or NA_character_
      return(NA_character_)
    } else if (i < 0) {
      paste0("\u2212", format(abs(i), nsmall = 1))
    } else {
      format(i, nsmall = 1)
    }
  }, FUN.VALUE = character(1))
}

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
  dplyr::inner_join(., metadata_beta, by = "sample_id") %>%
  dplyr::inner_join(., metadata_beta, by = c("b" = "sample_id")) %>%
  dplyr::select(sample_id, b, distances) %>%
  pivot_wider(names_from = "b", values_from = "distances") %>%
  dplyr::select(-sample_id) %>%
  as.dist()

adonis2(as.dist(bray_dist_matrix) ~ metadata_beta$status, method = "bray")

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
  dplyr::inner_join(., metadata_beta, by = "sample_id") %>%
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
  scale_x_continuous(labels = minus_label) +
  scale_y_continuous(labels = minus_label) +
  guides(color = guide_legend(
    override.aes = list(shape = 15, size = 4, alpha = 1)
  )) +
  stat_ellipse(show.legend = FALSE) +
  annotate(
    geom = 'richtext',
    x = 0.5,
    y = 1,
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
  dplyr::inner_join(., metadata_beta, by = "sample_id") %>%
  dplyr::inner_join(., metadata_beta, by = c("b" = "sample_id")) %>%
  dplyr::select(sample_id, b, distances) %>%
  pivot_wider(names_from = "b", values_from = "distances") %>%
  dplyr::select(-sample_id) %>%
  as.dist()

adonis2(as.dist(jaccard_dist_matrix) ~ metadata_beta$status, method = "jaccard")

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

positions_jaccard[, 2] <- -positions_jaccard[, 2]

PCOA_jaccard_plot <- positions_jaccard %>%
  as_tibble(rownames = "sample_id") %>%
  dplyr::inner_join(., metadata_beta, by = "sample_id") %>%
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
  scale_x_continuous(labels = minus_label) +
  scale_y_continuous(labels = minus_label) +
  guides(color = guide_legend(
    override.aes = list(shape = 15, size = 4, alpha = 1)
  )) +
  stat_ellipse(show.legend = FALSE) +
  annotate(
    geom = 'richtext',
    x = 1.2,
    y = 0.6,
    label = "PERMANOVA<br><i>p</i>-value=0.05",
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

div_combined <- (combined_alpha / combined_beta) &
  plot_annotation(tag_levels = list(c("A", "B", "C", "D")))

ggsave(
  "images/div_combined.png",
  plot = div_combined,
  width = 14,
  height = 8,
  dpi = 600
)

############################
###### ULTRA COMBINED ######
############################

bars <- (phylum | family) +
  plot_annotation(tag_levels = 'A')

combined_alpha_2 <- (shannon | chao1 | pielou) +
  plot_annotation(tag_levels = list(c('D', 'E', 'F')))

combined_beta_2 <- (PCOA_bray_plot + PCOA_jaccard_plot) +
  plot_annotation(tag_levels = list(c('G', 'H'))) +
  plot_layout(guides = "collect") &
  theme(legend.position = "bottom")

design <- "AAAAAAAA
           #BBBBBB#
           #CCCCCC#
           #DDDDDD#"

wombo_combo <- (free(bars) / free(species) / combined_alpha_2 / combined_beta_2) +
  plot_layout(widths = c(1),
              heights = c(4, 4, 4, 4),
              design = design) +
  plot_annotation(tag_levels = 'A')

wombo_combo[[1]][[1]][[2]] <- wombo_combo[[1]][[1]][[2]] +
  theme(plot.tag.position = c(-0.075, 1))
#wombo_combo[[1]][[1]][[3]] <- wombo_combo[[1]][[1]][[3]] +
  #theme(plot.tag.position = c(-0.45, 1))

ggsave(
  "images/wombo_combo.png",
  plot = wombo_combo,
  width = 20,
  height = 16,
  dpi = 600
)
