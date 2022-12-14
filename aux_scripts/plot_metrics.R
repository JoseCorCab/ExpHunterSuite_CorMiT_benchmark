#!/usr/bin/env Rscript
library(optparse)
library(ggplot2)
########################################################################
## Functions
########################################################################



summarize_strategies <- function(strategies){
dictionary <- list(
    "Eigengene" = "E",
    "Eigengene_0" = "E0",
    "hub_1" = "H",
    "normalized_counts" = "c"
    )
  translated_strategies <- c()
  str(dictionary)
  for (strategy_name in strategies){

    strategies <- unlist(strsplit(strategy_name, "_RNA_vs_miRNA_"))
    summ_name <- c()
    for (strategy in strategies) {
        if (!is.null(dictionary[[strategy]])){
                summ_name <- c(summ_name, dictionary[[strategy]])
        } else {
                if(stringr::str_detect(strategy, "_opp")) strategy <- gsub("_opp", " (opp)", strategy)
                if(stringr::str_detect(strategy, "_sim")) strategy <- gsub("_sim", " (sim)", strategy)

                
                summ_name <- c(summ_name, strategy)
        }
    }
    str(summ_name)
    translated_str <- paste(summ_name,collapse =  "_gene | miR_")
    translated_strategies <- c(translated_strategies, translated_str)
  }
  return(translated_strategies)
} 

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

colorBlindGrey8 <- c("#999999", "#E69F00", "#56B4E9", "#009E73", 
                       "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
all_files <- unlist(strsplit(opt$data, opt$sep))
merged_data_file <- data.frame()

merged_data_file <- lapply(all_files, function(file){read.table(file, header = TRUE)})
merged_data_file <- data.table::rbindlist(merged_data_file)

merged_data_file <- as.data.frame(merged_data_file[merged_data_file$db_group == "validated",])
names(merged_data_file)[names(merged_data_file) == "TP"] <- "validated_pairs"
merged_data_file$strategy <- summarize_strategies(merged_data_file$strategy)
str(merged_data_file)
pp <- ggplot(merged_data_file,aes(x=corr_cutoff, y=Odds_ratio,color = strategy)) + 
            geom_point(aes(size = validated_pairs), stat="identity", alpha = 0.5) +
            geom_line(aes(size = 3), stat="identity", alpha = 0.5)+
      theme(legend.position="bottom", legend.box = "vertical") + 
      scale_color_manual(breaks = unique(merged_data_file$strategy),
                            values = colorBlindGrey8[seq(1,length(unique(merged_data_file$strategy)))])

pdf(paste0(opt$output, ".pdf"), 10, 10)
pp
dev.off()

