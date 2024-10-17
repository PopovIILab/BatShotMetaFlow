#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly=TRUE)

# Read the proteinortho table
onetoone <- read.delim(args[1])

  # Create directory to store SCOs
  dir.create(args[2]) #e.g. data/SCOs

  # Write name lists to later extract
   for (i in 4:ncol(onetoone)) {
   writeLines(onetoone[,i], paste0(args[2], names(onetoone[i]), ".names.txt"))
   }
   dir.create(args[3])  
   # And gene lists grouped by families
   for (i in 1:nrow(onetoone)) {
   oo <- as.matrix(onetoone)
   writeLines(oo[i, 4:ncol(onetoone)], paste0(args[3], "family", as.character(i), ".names.txt"))
   }