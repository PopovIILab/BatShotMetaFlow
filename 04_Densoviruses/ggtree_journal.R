main_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(main_dir)

if (!require("pacman"))
  install.packages("pacman")

pacman::p_load(ggtree,
               ggimage,
               phangorn,
               ggplot2,
               treeio,
               ggnewscale,
               viridis,
               phytools,
               patchwork)

####################
# METADATA PARSING #
####################

metadata <- read.table(
  'phylogenomics/metadata/well_done_metadata.tsv',
  sep = '\t',
  header = T
)

tips <- metadata$Host

tips[tips == "Bat"] <- "Eptesicus"
tips[tips == "bat"] <- "Eptesicus"
tips[tips == "Culex annulirostris"] <- "Culex"
tips[tips == "Actinonaias pectorosa"] <- "Unionidae"
tips[tips == "Bactericera trigonica"] <- "Hemiptera"
tips[tips == "Asterias forbesi (sea star)"] <- "Asterias"
tips[tips == "house cricket"] <- "Acheta domestica"
tips[tips == "Myzus persicae"] <- "Aphididae"
tips[tips == "Sibine fusca"] <- "Acharia stimulea"
tips[tips == "Dendrolimus punctatus"] <- "Sphinx ligustri"
tips[tips == "Mythimna loreyi"] <- "Catocala nupta"
tips[tips == "Casphalia extranea"] <- "Acharia stimulea"
tips[tips == "Galleria mellonella"] <- "Eriocephala calthella"
tips[tips == "Junonia coenia"] <- "Vanessa atalanta"
tips[tips == "Periplaneta fuliginosa"] <- "Periplaneta americana"
tips[tips == "Bombus cryptarum"] <- "Bombus"
tips[tips == "Dendroctonus brevicomis"] <- "Dendroctonus"
tips[tips == "Parus major"] <- "Parus"
tips[tips == "Perigonia lusca ilus"] <- "Dilophonotini"
tips[tips == "Cherax quadricarinatus"] <- "Decapoda"
tips[tips == "Erinnyis ello ello"] <- "sphinx ligustri"
tips[tips == "cricket"] <- "Acheta domestica"
tips[tips == "Pseudoplusia includens"] <- "Spodoptera frugiperda"
tips[tips == "Helicoverpa armigera"] <- "Catocala nupta"
tips[tips == "Fenneropenaeus chinensis"] <- "Penaeus monodon"
tips[tips == "Culex pipiens pipiens"] <- "Culex"
tips[tips == "Neodiprion sertifer"] <- "Xyela julii"
tips[tips == "Diatraea saccharalis"] <- "Crambus praefectellus"
tips[tips == "Solenopsis invicta; worker ants"] <- "Solenopsis invicta"
tips[tips == "Zophobas morio (mealworm)"] <- "Tribolium castaneum"

tipsimg <- ggimage::phylopic_uid(tips)

meta.year <- as.data.frame(metadata[, 'Year'])
colnames(meta.year) <- 'Year'
rownames(meta.year) <- metadata$Name
meta.year$Year[meta.year$Year == "ND"] <- NA

country_code_map <- c(
  "USA" = "us",
  "Russia" = "ru",
  "China" = "cn",
  "France" = "fr",
  "Brazil" = "br",
  "India" = "in",
  "Canada" = "ca",
  "Australia" = "au",
  "Belgium" = "be",
  "Tanzania" = "tz",
  "Israel" = "il",
  "Argentina" = "ar",
  "Colombia" = "co",
  "USA: Clinch River, Sycamore Island, Virginia" = "us",
  "China: Zhenjiang" = "cn",
  "China: Beihuang Island, Bohai Gulf" = "cn",
  "France: Montpellier" = "fr"
)

metadata$flag_code <- country_code_map[metadata$Country]
metadata$flag_code[is.na(metadata$flag_code)] <- NA

if (!dir.exists("flags"))
  dir.create("flags")

flag_urls <- paste0(
  "https://raw.githubusercontent.com/HatScripts/circle-flags/gh-pages/flags/",
  unique(metadata$flag_code[!is.na(metadata$flag_code)]),
  ".svg"
)

for (i in seq_along(flag_urls)) {
  country_code <- sub(".*/flags/(.*)\\.svg", "\\1", flag_urls[i])
  
  destfile <- paste0("flags/", country_code, ".svg")
  
  download.file(flag_urls[i], destfile, mode = "wb")
}

metadata$flag_path <- paste0("flags/", metadata$flag_code, ".svg")
metadata$flag_path[metadata$flag_path == "flags/NA.svg"] <- NA

############
# NSP tree #
############

NSP_tree <- read.tree("phylogenomics/iqtree/NSPs/NSPs.treefile")

midpoint.root(NSP_tree)

tipsNSP <- tipsimg
tipsNSP$name <- metadata$Name
labels <- NSP_tree$tip.label
tipsNSP_filtered <- tipsNSP[tipsNSP$name %in% labels, ]
df_NSP <- tipsNSP_filtered[match(labels, tipsNSP_filtered$name), ]

df_NSP$uid[df_NSP$name == "NC_077050.1"] <- "036b96de-4bca-408e-adb6-2154fcd724ef"

NSP <- ggtree(NSP_tree) %<+% metadata +
  geom_tiplab(
    image = df_NSP$uid,
    geom = "phylopic",
    size = ifelse(
      df_NSP$name == "NC_040626.1",
      0.015,
      ifelse(
        df_NSP$name == "NC_005041.2" |
          df_NSP$name == "NC_005040.2" |
          df_NSP$name == "NC_026943.1" |
          df_NSP$name == "NC_001899.1" |
          df_NSP$name == "NC_077036.1",
        0.02,
        ifelse(
          df_NSP$name == "MW628494.1",
          0.015,
          ifelse(
            df_NSP$name == "NC_077050.1",
            0.01,
            ifelse(
              df_NSP$uid == "6e42ac62-37f4-458c-bf44-3f7decb1f14e",
              0.007,
              0.03
            )
          )
        )
      )
    ),
    offset = 1.5,
    align = TRUE
  ) +
  xlim(0, 5) +
  geom_tiplab(
    aes(label = Full.Name),
    color = "black",
    geom = "label",
    fill = "white",
    label.size = 0
  )

NSP_boot <- NSP$data
NSP_boot <- NSP_boot[!NSP_boot$isTip, ]
NSP_boot$label <- as.numeric(NSP_boot$label)
NSP_boot$bootstrap <- '0'
NSP_boot$bootstrap[NSP_boot$label >= 70] <- '1'
NSP_boot$bootstrap[is.na(NSP_boot$label)] <- '1'

NSP <- NSP + new_scale_color() +
  geom_tree(data = NSP_boot, aes(color = bootstrap == '1')) +
  scale_color_manual(name = 'Bootstrap',
                     values = setNames(c("black", "grey"), c(T, F)),
                     guide = "none")

NSP <- NSP + geom_tiplab(
  aes(image = flag_path),
  geom = "image",
  offset = 1.8,
  align = TRUE,
  size = 0.02,
  linesize = 0
)

NSP <- gheatmap(
  NSP,
  meta.year,
  width = 0.05,
  offset = 2,
  color = "black",
  font.size = 4,
  colnames_offset_y = -0.05
) +
  scale_fill_viridis(
    option = "D",
    name = "Year",
    discrete = TRUE,
    na.translate = T
  )

NSP <- NSP +
  annotate(
    "text",
    x = max(NSP$data$x) + 1.5,
    y = -0.05,
    label = "Host",
    size = 4
  ) +
  annotate(
    "text",
    x = max(NSP$data$x) + 1.8,
    y = -0.05,
    label = "Country",
    size = 4
  )

ggsave(
  'images/NSP_tree.png',
  NSP,
  width = 14,
  height = 12,
  dpi = 600
)

###########
# SP tree #
###########

SP_tree <- read.tree("phylogenomics/iqtree/SPs/SPs.treefile")

midpoint.root(SP_tree)

tipsSP <- tipsimg
tipsSP$name <- metadata$Name
labels <- SP_tree$tip.label
tipsSP_filtered <- tipsSP[tipsSP$name %in% labels, ]
df_SP <- tipsSP_filtered[match(labels, tipsSP_filtered$name), ]

SP <- ggtree(SP_tree) %<+% metadata +
  geom_tiplab(
    image = df_SP$uid,
    geom = "phylopic",
    size = ifelse(
      df_SP$name == "MW628494.1",
      0.025,
      ifelse(df_SP$name == "NC_004290.1", 0.012, 0.05)
    ),
    offset = 1.5,
    align = TRUE
  ) +
  xlim(0, 4.5) +
  geom_tiplab(
    aes(label = Full.Name),
    color = "black",
    geom = "label",
    fill = "white",
    label.size = 0
  )

SP_boot <- SP$data
SP_boot <- SP_boot[!SP_boot$isTip, ]
SP_boot$label <- as.numeric(SP_boot$label)
SP_boot$bootstrap <- '0'
SP_boot$bootstrap[SP_boot$label >= 70] <- '1'
SP_boot$bootstrap[is.na(SP_boot$label)] <- '1'

SP <- SP + new_scale_color() +
  geom_tree(data = SP_boot, aes(color = bootstrap == '1')) +
  scale_color_manual(name = 'Bootstrap',
                     values = setNames(c("black", "grey"), c(T, F)),
                     guide = "none")

SP <- SP + geom_tiplab(
  aes(image = flag_path),
  geom = "image",
  offset = 1.8,
  align = TRUE,
  size = 0.04,
  linesize = 0
)

SP <- gheatmap(
  SP,
  meta.year,
  width = 0.05,
  offset = 2,
  color = "black",
  font.size = 4,
  colnames_offset_y = -0.05
) +
  scale_fill_viridis(
    option = "D",
    name = "Year",
    discrete = TRUE,
    na.translate = T
  )

SP <- SP +
  annotate(
    "text",
    x = max(SP$data$x) + 1.5,
    y = -0.05,
    label = "Host",
    size = 4
  ) +
  annotate(
    "text",
    x = max(SP$data$x) + 1.8,
    y = -0.05,
    label = "Country",
    size = 4
  )

ggsave(
  'images/SP_tree.png',
  SP,
  width = 14,
  height = 6,
  dpi = 600
)

#################
# NSP + SP tree #
#################

All_tree <- read.tree("phylogenomics/iqtree/All/All.treefile")

midpoint.root(All_tree)

tipsAll <- tipsimg
tipsAll$name <- metadata$Name
labels <- All_tree$tip.label
tipsAll_filtered <- tipsAll[tipsAll$name %in% labels, ]
df_All <- tipsAll_filtered[match(labels, tipsAll_filtered$name), ]

All <- ggtree(All_tree) %<+% metadata +
  geom_tiplab(
    image = df_All$uid,
    geom = "phylopic",
    size = ifelse(
      df_All$name == "MW628494.1",
      0.025,
      ifelse(df_All$name == "NC_004290.1", 0.012, 0.05)
    ),
    offset = 1.5,
    align = TRUE
  ) +
  xlim(0, 4.5) +
  geom_tiplab(
    aes(label = Full.Name),
    color = "black",
    geom = "label",
    fill = "white",
    label.size = 0
  )

All_boot <- All$data
All_boot <- All_boot[!All_boot$isTip, ]
All_boot$label <- as.numeric(All_boot$label)
All_boot$bootstrap <- '0'
All_boot$bootstrap[All_boot$label >= 70] <- '1'
All_boot$bootstrap[is.na(All_boot$label)] <- '1'

All <- All + new_scale_color() +
  geom_tree(data = All_boot, aes(color = bootstrap == '1')) +
  scale_color_manual(name = 'Bootstrap',
                     values = setNames(c("black", "grey"), c(T, F)),
                     guide = "none")

All <- All + geom_tiplab(
  aes(image = flag_path),
  geom = "image",
  offset = 1.8,
  align = TRUE,
  size = 0.04,
  linesize = 0
)

All <- gheatmap(
  All,
  meta.year,
  width = 0.05,
  offset = 2,
  color = "black",
  font.size = 4,
  colnames_offset_y = -0.05
) +
  scale_fill_viridis(
    option = "D",
    name = "Year",
    discrete = TRUE,
    na.translate = T
  )

All <- All +
  annotate(
    "text",
    x = max(All$data$x) + 1.5,
    y = -0.05,
    label = "Host",
    size = 4
  ) +
  annotate(
    "text",
    x = max(All$data$x) + 1.8,
    y = -0.05,
    label = "Country",
    size = 4
  )

ggsave(
  'images/All_tree.png',
  All,
  width = 14,
  height = 9,
  dpi = 600
)

############
# COMBINED #
############

# Thanks to https://patchwork.data-imaginist.com/articles/guides/layout.html
combined <- ((All / SP + plot_layout(guides = 'collect')) |
               NSP) &
  plot_annotation(tag_levels = list(c("A", "B", "C")))

ggsave(
  "images/combo_tree.png",
  plot = combined,
  width = 28,
  height = 12,
  dpi = 600
)
