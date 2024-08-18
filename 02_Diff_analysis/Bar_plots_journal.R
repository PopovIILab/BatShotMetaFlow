main_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(main_dir)

if (!require("pacman")) install.packages("pacman")

pacman::p_load(tidyverse, ggtext, patchwork, paletteer, data.table, tibble, dplyr, tidyr, ggplot2, scales)

#################################
##########Taxa_bar_plots#########
#################################

metadata <- read.csv("metadata.csv")

#####################
###### SPECIES ######
#####################

data_species <- read.csv("counts/csv/counts_species.csv", check.names = F)
merged_data_species <- merge(data_species, metadata, by.x = "Sample_id", by.y = "sample_id")
long_data_species <- pivot_longer(merged_data_species, 
                                cols = -c(Sample_id, Group), 
                                names_to = "taxon", 
                                values_to = "abundance")
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
  mutate(taxon = ifelse(percentage < 2, "Other (< 2%)", as.character(taxon))) %>%
  group_by(Sample_id, taxon) %>%
  summarize(total_percentage = sum(percentage), .groups = 'drop') %>%
  arrange(Sample_id, desc(total_percentage))

data_species_1$taxon <- factor(data_species_1$taxon, levels = c("Other (< 2%)", unique(data_species_1$taxon[data_species_1$taxon != "Other (< 2%)"])))

# Set specific colors for each taxon
color_palette <- c("Other (< 2%)" = "#837b8d", 
                   #"Bradyrhizobium sp. BTAi1" = "#ce3d32",
                   #"Candidatus Kaistella beijingensis" = "#f0e685",
                   setNames(paletteer_d("ggsci::default_igv", n = length(unique(data_species_1$taxon))-1),
                            unique(data_species_1$taxon[data_species_1$taxon != "Other (< 2%)"])))

# Plotting with refined grid settings
species <- ggplot(data_species_1, aes(x = Sample_id, y = total_percentage, fill = taxon)) +
  geom_bar(stat = "identity", width = 0.7) +
  scale_fill_manual(values = color_palette, name = "Species") +
  scale_y_continuous(labels = percent_format(scale = 1)) +
  scale_x_discrete(breaks=c("D1", "D2", "D3", "D4", "D5", "P1", "P2", "P3", "P4", "P5"),
                   labels=c("VM1", "VM2", "VM3", "VM4", "VM5", "NN1", "NN2", "NN3", "NN4", "NN5"))+
  scale_y_continuous(expand=c(0, 0)) +
  labs(x = "Samples",
       y = "Mean Relative Abundance (%)",
       fill = "Species") +
  theme_classic() +
  theme(legend.text = element_text(face = "italic"),
        legend.key.size = unit(10, "pt"),
        axis.text.x = ggtext::element_markdown())

# Save the plot
ggsave("images/bar_plots/bar_plot_species.png", species, width=8.5, height=4, dpi = 600)


###################
###### GENUS ######
###################

data_genus <- read.csv("counts/csv/counts_genus.csv", check.names = F)
merged_data_genus <- merge(data_genus, metadata, by.x = "Sample_id", by.y = "sample_id")
long_data_genus <- pivot_longer(merged_data_genus, 
                                  cols = -c(Sample_id, Group), 
                                  names_to = "taxon", 
                                  values_to = "abundance")
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
  mutate(taxon = ifelse(percentage < 2, "Other (< 2%)", as.character(taxon))) %>%
  group_by(Sample_id, taxon) %>%
  summarize(total_percentage = sum(percentage), .groups = 'drop') %>%
  arrange(Sample_id, desc(total_percentage))

data_genus_1$taxon <- factor(data_genus_1$taxon, levels = c("Other (< 2%)", unique(data_genus_1$taxon[data_genus_1$taxon != "Other (< 2%)"])))

# Set specific colors for each taxon
color_palette <- c("Other (< 2%)" = "#837b8d", 
                   #"Bradyrhizobium sp. BTAi1" = "#ce3d32",
                   #"Candidatus Kaistella beijingensis" = "#f0e685",
                   setNames(paletteer_d("ggsci::default_igv", n = length(unique(data_genus_1$taxon))-1),
                            unique(data_genus_1$taxon[data_genus_1$taxon != "Other (< 2%)"])))

# Plotting with refined grid settings
genus <- ggplot(data_genus_1, aes(x = Sample_id, y = total_percentage, fill = taxon)) +
  geom_bar(stat = "identity", width = 0.7) +
  scale_fill_manual(values = color_palette, name = "Genus") +
  scale_y_continuous(labels = percent_format(scale = 1)) +
  scale_x_discrete(breaks=c("D1", "D2", "D3", "D4", "D5", "P1", "P2", "P3", "P4", "P5"),
                   labels=c("VM1", "VM2", "VM3", "VM4", "VM5", "NN1", "NN2", "NN3", "NN4", "NN5"))+
  scale_y_continuous(expand=c(0, 0)) +
  labs(x = "Samples",
       y = "Mean Relative Abundance (%)",
       fill = "Genus") +
  theme_classic() +
  theme(legend.text = element_text(face = "italic"),
        legend.key.size = unit(10, "pt"),
        axis.text.x = ggtext::element_markdown())

# Save the plot
ggsave("images/bar_plots/bar_plot_genus.png", genus, width=8.5, height=4, dpi = 600)


####################
###### FAMILY ######
####################

data_family <- read.csv("counts/csv/counts_family.csv", check.names = F)
merged_data_family <- merge(data_family, metadata, by.x = "Sample_id", by.y = "sample_id")
long_data_family <- pivot_longer(merged_data_family, 
                                cols = -c(Sample_id, Group), 
                                names_to = "taxon", 
                                values_to = "abundance")
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
  mutate(taxon = ifelse(percentage < 2, "Other (< 2%)", as.character(taxon))) %>%
  group_by(Sample_id, taxon) %>%
  summarize(total_percentage = sum(percentage), .groups = 'drop') %>%
  arrange(Sample_id, desc(total_percentage))

data_family_1$taxon <- factor(data_family_1$taxon, levels = c("Other (< 2%)", unique(data_family_1$taxon[data_family_1$taxon != "Other (< 2%)"])))

# Set specific colors for each taxon
color_palette <- c("Other (< 2%)" = "#837b8d", 
                   #"Bradyrhizobium sp. BTAi1" = "#ce3d32",
                   #"Candidatus Kaistella beijingensis" = "#f0e685",
                   setNames(paletteer_d("ggsci::default_igv", n = length(unique(data_family_1$taxon))-1),
                            unique(data_family_1$taxon[data_family_1$taxon != "Other (< 2%)"])))

# Plotting with refined grid settings
family <- ggplot(data_family_1, aes(x = Sample_id, y = total_percentage, fill = taxon)) +
  geom_bar(stat = "identity", width = 0.7) +
  scale_fill_manual(values = color_palette, name = "Family") +
  scale_y_continuous(labels = percent_format(scale = 1)) +
  scale_x_discrete(breaks=c("D1", "D2", "D3", "D4", "D5", "P1", "P2", "P3", "P4", "P5"),
                   labels=c("VM1", "VM2", "VM3", "VM4", "VM5", "NN1", "NN2", "NN3", "NN4", "NN5"))+
  scale_y_continuous(expand=c(0, 0)) +
  labs(x = "Samples",
       y = "Mean Relative Abundance (%)",
       fill = "Family") +
  theme_classic() +
  theme(legend.text = element_text(face = "italic"),
        legend.key.size = unit(10, "pt"),
        axis.text.x = ggtext::element_markdown())

# Save the plot
ggsave("images/bar_plots/bar_plot_family.png", family, width=8.5, height=4, dpi = 600)


###################
###### ORDER ######
###################

data_order <- read.csv("counts/csv/counts_order.csv", check.names = F)
merged_data_order <- merge(data_order, metadata, by.x = "Sample_id", by.y = "sample_id")
long_data_order <- pivot_longer(merged_data_order, 
                                cols = -c(Sample_id, Group), 
                                names_to = "taxon", 
                                values_to = "abundance")
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
  mutate(taxon = ifelse(percentage < 2, "Other (< 2%)", as.character(taxon))) %>%
  group_by(Sample_id, taxon) %>%
  summarize(total_percentage = sum(percentage), .groups = 'drop') %>%
  arrange(Sample_id, desc(total_percentage))

data_order_1$taxon <- factor(data_order_1$taxon, levels = c("Other (< 2%)", unique(data_order_1$taxon[data_order_1$taxon != "Other (< 2%)"])))

# Set specific colors for each taxon
color_palette <- c("Other (< 2%)" = "#837b8d", 
                   #"Bradyrhizobium sp. BTAi1" = "#ce3d32",
                   #"Candidatus Kaistella beijingensis" = "#f0e685",
                   setNames(paletteer_d("ggsci::default_igv", n = length(unique(data_order_1$taxon))-1),
                            unique(data_order_1$taxon[data_order_1$taxon != "Other (< 2%)"])))

# Plotting with refined grid settings
order <- ggplot(data_order_1, aes(x = Sample_id, y = total_percentage, fill = taxon)) +
  geom_bar(stat = "identity", width = 0.7) +
  scale_fill_manual(values = color_palette, name = "Order") +
  scale_y_continuous(labels = percent_format(scale = 1)) +
  scale_x_discrete(breaks=c("D1", "D2", "D3", "D4", "D5", "P1", "P2", "P3", "P4", "P5"),
                   labels=c("VM1", "VM2", "VM3", "VM4", "VM5", "NN1", "NN2", "NN3", "NN4", "NN5"))+
  scale_y_continuous(expand=c(0, 0)) +
  labs(x = "Samples",
       y = "Mean Relative Abundance (%)",
       fill = "Order") +
  theme_classic() +
  theme(legend.text = element_text(face = "italic"),
        legend.key.size = unit(10, "pt"),
        axis.text.x = ggtext::element_markdown())

# Save the plot
ggsave("images/bar_plots/bar_plot_order.png", order, width=8.5, height=4, dpi = 600)


###################
###### CLASS ######
###################

data_class <- read.csv("counts/csv/counts_class.csv", check.names = F)
merged_data_class <- merge(data_class, metadata, by.x = "Sample_id", by.y = "sample_id")
long_data_class <- pivot_longer(merged_data_class, 
                                cols = -c(Sample_id, Group), 
                                names_to = "taxon", 
                                values_to = "abundance")
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
  mutate(taxon = ifelse(percentage < 2, "Other (< 2%)", as.character(taxon))) %>%
  group_by(Sample_id, taxon) %>%
  summarize(total_percentage = sum(percentage), .groups = 'drop') %>%
  arrange(Sample_id, desc(total_percentage))

data_class_1$taxon <- factor(data_class_1$taxon, levels = c("Other (< 2%)", unique(data_class_1$taxon[data_class_1$taxon != "Other (< 2%)"])))

# Set specific colors for each taxon
color_palette <- c("Other (< 2%)" = "#837b8d", 
                   #"Bradyrhizobium sp. BTAi1" = "#ce3d32",
                   #"Candidatus Kaistella beijingensis" = "#f0e685",
                   setNames(paletteer_d("ggsci::default_igv", n = length(unique(data_class_1$taxon))-1),
                            unique(data_class_1$taxon[data_class_1$taxon != "Other (< 2%)"])))

# Plotting with refined grid settings
class <- ggplot(data_class_1, aes(x = Sample_id, y = total_percentage, fill = taxon)) +
  geom_bar(stat = "identity", width = 0.7) +
  scale_fill_manual(values = color_palette, name = "Class") +
  scale_y_continuous(labels = percent_format(scale = 1)) +
  scale_x_discrete(breaks=c("D1", "D2", "D3", "D4", "D5", "P1", "P2", "P3", "P4", "P5"),
                   labels=c("VM1", "VM2", "VM3", "VM4", "VM5", "NN1", "NN2", "NN3", "NN4", "NN5"))+
  scale_y_continuous(expand=c(0, 0)) +
  labs(x = "Samples",
       y = "Mean Relative Abundance (%)",
       fill = "Class") +
  theme_classic() +
  theme(legend.text = element_text(face = "italic"),
        legend.key.size = unit(10, "pt"),
        axis.text.x = ggtext::element_markdown())

# Save the plot
ggsave("images/bar_plots/bar_plot_class.png", class, width=8.5, height=4, dpi = 600)


####################
###### PHYLUM ######
####################

data_phylum <- read.csv("counts/csv/counts_phylum.csv", check.names = F)
merged_data_phylum <- merge(data_phylum, metadata, by.x = "Sample_id", by.y = "sample_id")
long_data_phylum <- pivot_longer(merged_data_phylum, 
                                cols = -c(Sample_id, Group), 
                                names_to = "taxon", 
                                values_to = "abundance")
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
  mutate(taxon = ifelse(percentage < 2, "Other (< 2%)", as.character(taxon))) %>%
  group_by(Sample_id, taxon) %>%
  summarize(total_percentage = sum(percentage), .groups = 'drop') %>%
  arrange(Sample_id, desc(total_percentage))

data_phylum_1$taxon <- factor(data_phylum_1$taxon, levels = c("Other (< 2%)", unique(data_phylum_1$taxon[data_phylum_1$taxon != "Other (< 2%)"])))

# Set specific colors for each taxon
color_palette <- c("Other (< 2%)" = "#837b8d", 
                   #"Bradyrhizobium sp. BTAi1" = "#ce3d32",
                   #"Candidatus Kaistella beijingensis" = "#f0e685",
                   setNames(paletteer_d("ggsci::default_igv", n = length(unique(data_phylum_1$taxon))-1),
                            unique(data_phylum_1$taxon[data_phylum_1$taxon != "Other (< 2%)"])))

# Plotting with refined grid settings
phylum <- ggplot(data_phylum_1, aes(x = Sample_id, y = total_percentage, fill = taxon)) +
  geom_bar(stat = "identity", width = 0.7) +
  scale_fill_manual(values = color_palette, name = "Phylum") +
  scale_y_continuous(labels = percent_format(scale = 1)) +
  scale_x_discrete(breaks=c("D1", "D2", "D3", "D4", "D5", "P1", "P2", "P3", "P4", "P5"),
                   labels=c("VM1", "VM2", "VM3", "VM4", "VM5", "NN1", "NN2", "NN3", "NN4", "NN5"))+
  scale_y_continuous(expand=c(0, 0)) +
  labs(x = "Samples",
       y = "Mean Relative Abundance (%)",
       fill = "Phylum") +
  theme_classic() +
  theme(legend.text = element_text(face = "italic"),
        legend.key.size = unit(10, "pt"),
        axis.text.x = ggtext::element_markdown())

# Save the plot
ggsave("images/bar_plots/bar_plot_phylum.png", phylum, width=8.5, height=4, dpi = 600)


######################
###### COMBINED ######
######################

everything <- (phylum + class + order) / (family + genus + species) + plot_annotation(tag_levels = list(c("A", "B", "C", "D", "E", "F")))
ggsave("images/bar_plots/bar_plot_everything.png", plot = everything, width = 20, height = 8, dpi=600)

combined <- phylum + family + species + plot_annotation(tag_levels = list(c("A", "B", "C")))
ggsave("images/bar_plots/bar_plot_combined.png", plot = combined, width = 20, height = 4, dpi=600)
