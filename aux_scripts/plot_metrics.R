#!/usr/bin/env Rscript
library(optparse)
library(ggplot2)
########################################################################
## OPTPARSE
########################################################################
option_list <- list(
    make_option(c("-d", "--data"), type="character",
                help="Star Log File as input"),
    make_option(c("-s", "--sep"), type="character",
                help="Separator character"),
    make_option(c("-m", "--metric"), type = "character", help = "Metric to plot"),
    make_option(c("-o", "--output"), type = "character", help = "outputfile")


)
opt <- parse_args(OptionParser(option_list=option_list))

all_files <- unlist(strsplit(opt$data, opt$sep))
merged_data_file <- data.frame()

merged_data_file <- lapply(all_files, function(file){read.table(file, header = TRUE)})
merged_data_file <- data.table::rbindlist(merged_data_file)

merged_data_file <- merged_data_file[merged_data_file$db_group == "validated",]

pp <- ggplot(merged_data_file) + geom_line(aes(x=corr_cutoff, y=Odds_ratio,color = strategy), stat="identity") +
      theme(legend.position="bottom", legend.box = "vertical")

pdf(paste0(opt$output, ".pdf"), 10, 10)
pp
dev.off()

