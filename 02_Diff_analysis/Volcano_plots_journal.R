main_dir <- dirname(rstudioapi::getSourceEditorContext()$path) 
setwd(main_dir)

if (!require("pacman")) install.packages("pacman")

pacman::p_load(tidyverse, ggtext, ggrepel)

#####################
###### SPECIES ######
#####################

DAA_species <- read.csv("MaAsLin2_results/species/all_results.tsv", sep = "\t")

DAA_species$diffabund <- "NO"
DAA_species$diffabund[DAA_species$coef > 1 & DAA_species$qval < 0.05 & DAA_species$metadata == "Group"] <- "NN_plus"
DAA_species$diffabund[DAA_species$coef < -1 & DAA_species$qval < 0.05 & DAA_species$metadata == "Group"] <- "NN_minus"
DAA_species$feature[DAA_species$diffabund == "NO"] <- NA
DAA_species$label <- NA
top_red <- DAA_species[DAA_species$coef < -1 & DAA_species$qval < 0.05 & DAA_species$metadata == "Group", ]
top_red <- top_red[order(top_red$qval), ][1:5, ]
DAA_species$label[DAA_species$feature %in% top_red$feature] <- DAA_species$feature[DAA_species$feature %in% top_red$feature]
DAA_species$label[DAA_species$coef > 1 & DAA_species$qval < 0.05 & DAA_species$metadata == "Group"] <- DAA_species$feature[DAA_species$coef > 1 & DAA_species$qval < 0.05 & DAA_species$metadata == "Group"]

volcano_plot_species <- ggplot(data = DAA_species, aes(x = coef, y = -log10(qval), label = feature, col = diffabund)) +
  geom_point(size = 2) +
  theme_bw() +
  geom_vline(xintercept = c(-1, 1), col = "gray", linetype = 'dashed') +
  geom_hline(yintercept = c(-log10(0.05)), col = "gray", linetype = 'dashed') +
  geom_text_repel(data = subset(DAA_species, !is.na(label)),
                  aes(label = label),
                  size = 2,
                  box.padding = 1,
                  point.padding = 0.5,
                  max.overlaps = 10,
                  nudge_x = 2,
                  nudge_y = 3,
                  force = 10) +
  scale_color_manual(name = NULL,
                     values = c("grey"),
                     labels = c("<strong>Not significant:</strong><br>q-value>0.05")) +
  labs(x = "Log2fc") +
  theme(plot.title = element_text(size=22),
        legend.text = element_markdown(size=14),
        plot.caption = element_text(size=22),
        axis.text = element_text(size=14),
        axis.title = element_text(size=16, vjust = 0)) + 
  guides(colour = guide_legend(override.aes = list(size=3.5)))

ggsave("images/volcano_plots/volcano_plot_species.png", plot = volcano_plot_species, width = 10, height = 6, dpi = 600)


###################
###### GENUS ######
###################

DAA_genus <- read.csv("MaAsLin2_results/genus/all_results.tsv", sep = "\t")

DAA_genus$diffabund <- "NO"
DAA_genus$diffabund[DAA_genus$coef > 1 & DAA_genus$qval < 0.05 & DAA_genus$metadata == "Group"] <- "NN_plus"
DAA_genus$diffabund[DAA_genus$coef < -1 & DAA_genus$qval < 0.05 & DAA_genus$metadata == "Group"] <- "NN_minus"
DAA_genus$feature[DAA_genus$diffabund == "NO"] <- NA
DAA_genus$label <- NA
top_red <- DAA_genus[DAA_genus$coef < -1 & DAA_genus$qval < 0.05 & DAA_genus$metadata == "Group", ]
top_red <- top_red[order(top_red$qval), ][1:5, ]
DAA_genus$label[DAA_genus$feature %in% top_red$feature] <- DAA_genus$feature[DAA_genus$feature %in% top_red$feature]
DAA_genus$label[DAA_genus$coef > 1 & DAA_genus$qval < 0.05 & DAA_genus$metadata == "Group"] <- DAA_genus$feature[DAA_genus$coef > 1 & DAA_genus$qval < 0.05 & DAA_genus$metadata == "Group"]

volcano_plot_genus <- ggplot(data = DAA_genus, aes(x = coef, y = -log10(qval), label = feature, col = diffabund)) +
  geom_point(size = 2) +
  theme_bw() +
  geom_vline(xintercept = c(-1, 1), col = "gray", linetype = 'dashed') +
  geom_hline(yintercept = c(-log10(0.05)), col = "gray", linetype = 'dashed') +
  geom_text_repel(data = subset(DAA_species, !is.na(label)),
                  aes(label = label),
                  size = 2,
                  box.padding = 1,
                  point.padding = 0.5,
                  max.overlaps = 10,
                  nudge_x = 2,
                  nudge_y = 3,
                  force = 10) +
  scale_color_manual(name = NULL,
                     values = c("grey"),
                     labels = c("<strong>Not significant:</strong><br>q-value>0.05")) +
  labs(x = "Log2fc") +
  theme(plot.title = element_text(size=22),
        legend.text = element_markdown(size=14),
        plot.caption = element_text(size=22),
        axis.text = element_text(size=14),
        axis.title = element_text(size=16, vjust = 0)) + 
  guides(colour = guide_legend(override.aes = list(size=3.5)))

ggsave("images/volcano_plots/volcano_plot_genus.png", plot = volcano_plot_genus, width = 10, height = 6, dpi = 600)


####################
###### FAMILY ######
####################

DAA_family <- read.csv("MaAsLin2_results/family/all_results.tsv", sep = "\t")

DAA_family$diffabund <- "NO"
DAA_family$diffabund[DAA_family$coef > 1 & DAA_family$qval < 0.05 & DAA_family$metadata == "Group"] <- "NN_plus"
DAA_family$diffabund[DAA_family$coef < -1 & DAA_family$qval < 0.05 & DAA_family$metadata == "Group"] <- "NN_minus"
DAA_family$feature[DAA_family$diffabund == "NO"] <- NA
DAA_family$label <- NA
top_red <- DAA_family[DAA_family$coef < -1 & DAA_family$qval < 0.05 & DAA_family$metadata == "Group", ]
top_red <- top_red[order(top_red$qval), ][1:5, ]
DAA_family$label[DAA_family$feature %in% top_red$feature] <- DAA_family$feature[DAA_family$feature %in% top_red$feature]
DAA_family$label[DAA_family$coef > 1 & DAA_family$qval < 0.05 & DAA_family$metadata == "Group"] <- DAA_family$feature[DAA_family$coef > 1 & DAA_family$qval < 0.05 & DAA_family$metadata == "Group"]

volcano_plot_family <- ggplot(data = DAA_family, aes(x = coef, y = -log10(qval), label = feature, col = diffabund)) +
  geom_point(size = 2) +
  theme_bw() +
  geom_vline(xintercept = c(-1, 1), col = "gray", linetype = 'dashed') +
  geom_hline(yintercept = c(-log10(0.05)), col = "gray", linetype = 'dashed') +
  geom_text_repel(data = subset(DAA_species, !is.na(label)),
                  aes(label = label),
                  size = 2,
                  box.padding = 1,
                  point.padding = 0.5,
                  max.overlaps = 10,
                  nudge_x = 2,
                  nudge_y = 3,
                  force = 10) +
  scale_color_manual(name = NULL,
                     values = c("grey"),
                     labels = c("<strong>Not significant:</strong><br>q-value>0.05")) +
  labs(x = "Log2fc") +
  theme(plot.title = element_text(size=22),
        legend.text = element_markdown(size=14),
        plot.caption = element_text(size=22),
        axis.text = element_text(size=14),
        axis.title = element_text(size=16, vjust = 0)) + 
  guides(colour = guide_legend(override.aes = list(size=3.5)))

ggsave("images/volcano_plots/volcano_plot_family.png", plot = volcano_plot_family, width = 10, height = 6, dpi = 600)


###################
###### ORDER ######
###################

DAA_order <- read.csv("MaAsLin2_results/order/all_results.tsv", sep = "\t")

DAA_order$diffabund <- "NO"
DAA_order$diffabund[DAA_order$coef > 1 & DAA_order$qval < 0.05 & DAA_order$metadata == "Group"] <- "NN_plus"
DAA_order$diffabund[DAA_order$coef < -1 & DAA_order$qval < 0.05 & DAA_order$metadata == "Group"] <- "NN_minus"
DAA_order$feature[DAA_order$diffabund == "NO"] <- NA
DAA_order$label <- NA
top_red <- DAA_order[DAA_order$coef < -1 & DAA_order$qval < 0.05 & DAA_order$metadata == "Group", ]
top_red <- top_red[order(top_red$qval), ][1:5, ]
DAA_order$label[DAA_order$feature %in% top_red$feature] <- DAA_order$feature[DAA_order$feature %in% top_red$feature]
DAA_order$label[DAA_order$coef > 1 & DAA_order$qval < 0.05 & DAA_order$metadata == "Group"] <- DAA_order$feature[DAA_order$coef > 1 & DAA_order$qval < 0.05 & DAA_order$metadata == "Group"]

volcano_plot_order <- ggplot(data = DAA_order, aes(x = coef, y = -log10(qval), label = feature, col = diffabund)) +
  geom_point(size = 2) +
  theme_bw() +
  geom_vline(xintercept = c(-1, 1), col = "gray", linetype = 'dashed') +
  geom_hline(yintercept = c(-log10(0.05)), col = "gray", linetype = 'dashed') +
  geom_text_repel(data = subset(DAA_species, !is.na(label)),
                  aes(label = label),
                  size = 2,
                  box.padding = 1,
                  point.padding = 0.5,
                  max.overlaps = 10,
                  nudge_x = 2,
                  nudge_y = 3,
                  force = 10) +
  scale_color_manual(name = NULL,
                     values = c("grey"),
                     labels = c("<strong>Not significant:</strong><br>q-value>0.05")) +
  labs(x = "Log2fc") +
  theme(plot.title = element_text(size=22),
        legend.text = element_markdown(size=14),
        plot.caption = element_text(size=22),
        axis.text = element_text(size=14),
        axis.title = element_text(size=16, vjust = 0)) + 
  guides(colour = guide_legend(override.aes = list(size=3.5)))

ggsave("images/volcano_plots/volcano_plot_order.png", plot = volcano_plot_order, width = 10, height = 6, dpi = 600)

###################
###### CLASS ######
###################

DAA_class <- read.csv("MaAsLin2_results/class/all_results.tsv", sep = "\t")

DAA_class$diffabund <- "NO"
DAA_class$diffabund[DAA_class$coef > 1 & DAA_class$qval < 0.05 & DAA_class$metadata == "Group"] <- "NN_plus"
DAA_class$diffabund[DAA_class$coef < -1 & DAA_class$qval < 0.05 & DAA_class$metadata == "Group"] <- "NN_minus"
DAA_class$feature[DAA_class$diffabund == "NO"] <- NA
DAA_class$label <- NA
top_red <- DAA_class[DAA_class$coef < -1 & DAA_class$qval < 0.05 & DAA_class$metadata == "Group", ]
top_red <- top_red[order(top_red$qval), ][1:5, ]
DAA_class$label[DAA_class$feature %in% top_red$feature] <- DAA_class$feature[DAA_class$feature %in% top_red$feature]
DAA_class$label[DAA_class$coef > 1 & DAA_class$qval < 0.05 & DAA_class$metadata == "Group"] <- DAA_class$feature[DAA_class$coef > 1 & DAA_class$qval < 0.05 & DAA_class$metadata == "Group"]

volcano_plot_class <- ggplot(data = DAA_class, aes(x = coef, y = -log10(qval), label = feature, col = diffabund)) +
  geom_point(size = 2) +
  theme_bw() +
  geom_vline(xintercept = c(-1, 1), col = "gray", linetype = 'dashed') +
  geom_hline(yintercept = c(-log10(0.05)), col = "gray", linetype = 'dashed') +
  geom_text_repel(data = subset(DAA_species, !is.na(label)),
                  aes(label = label),
                  size = 2,
                  box.padding = 1,
                  point.padding = 0.5,
                  max.overlaps = 10,
                  nudge_x = 2,
                  nudge_y = 3,
                  force = 10) +
  scale_color_manual(name = NULL,
                     values = c("grey"),
                     labels = c("<strong>Not significant:</strong><br>q-value>0.05")) +
  labs(x = "Log2fc") +
  theme(plot.title = element_text(size=22),
        legend.text = element_markdown(size=14),
        plot.caption = element_text(size=22),
        axis.text = element_text(size=14),
        axis.title = element_text(size=16, vjust = 0)) + 
  guides(colour = guide_legend(override.aes = list(size=3.5)))

ggsave("images/volcano_plots/volcano_plot_class.png", plot = volcano_plot_class, width = 10, height = 6, dpi = 600)


####################
###### PHYLUM ######
####################

DAA_phylum <- read.csv("MaAsLin2_results/phylum/all_results.tsv", sep = "\t")

DAA_phylum$diffabund <- "NO"
DAA_phylum$diffabund[DAA_phylum$coef > 1 & DAA_phylum$qval < 0.05 & DAA_phylum$metadata == "Group"] <- "NN_plus"
DAA_phylum$diffabund[DAA_phylum$coef < -1 & DAA_phylum$qval < 0.05 & DAA_phylum$metadata == "Group"] <- "NN_minus"
DAA_phylum$feature[DAA_phylum$diffabund == "NO"] <- NA
DAA_phylum$label <- NA
top_red <- DAA_phylum[DAA_phylum$coef < -1 & DAA_phylum$qval < 0.05 & DAA_phylum$metadata == "Group", ]
top_red <- top_red[order(top_red$qval), ][1:5, ]
DAA_phylum$label[DAA_phylum$feature %in% top_red$feature] <- DAA_phylum$feature[DAA_phylum$feature %in% top_red$feature]
DAA_phylum$label[DAA_phylum$coef > 1 & DAA_phylum$qval < 0.05 & DAA_phylum$metadata == "Group"] <- DAA_phylum$feature[DAA_phylum$coef > 1 & DAA_phylum$qval < 0.05 & DAA_phylum$metadata == "Group"]

volcano_plot_phylum <- ggplot(data = DAA_phylum, aes(x = coef, y = -log10(qval), label = feature, col = diffabund)) +
  geom_point(size = 2) +
  theme_bw() +
  geom_vline(xintercept = c(-1, 1), col = "gray", linetype = 'dashed') +
  geom_hline(yintercept = c(-log10(0.05)), col = "gray", linetype = 'dashed') +
  geom_text_repel(data = subset(DAA_species, !is.na(label)),
                  aes(label = label),
                  size = 2,
                  box.padding = 1,
                  point.padding = 0.5,
                  max.overlaps = 10,
                  nudge_x = 2,
                  nudge_y = 3,
                  force = 10) +
  scale_color_manual(name = NULL,
                     values = c("grey"),
                     labels = c("<strong>Not significant:</strong><br>q-value>0.05")) +
  labs(x = "Log2fc") +
  theme(plot.title = element_text(size=22),
        legend.text = element_markdown(size=14),
        plot.caption = element_text(size=22),
        axis.text = element_text(size=14),
        axis.title = element_text(size=16, vjust = 0)) + 
  guides(colour = guide_legend(override.aes = list(size=3.5)))

ggsave("images/volcano_plots/volcano_plot_phylum.png", plot = volcano_plot_phylum, width = 10, height = 6, dpi = 600)
