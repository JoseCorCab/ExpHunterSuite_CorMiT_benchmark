#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
results <- read.table(args[1], header = TRUE)
results$DEG_tag_target <- factor(results$DEG_tag_target, c("PREVALENT_DEG","POSSIBLE_DEG","NOT_DEG"))
sorted_results <- results[order(results$DEG_tag_target, -results$similarity),]
rownames(sorted_results) <- seq(nrow(sorted_results))
write.table(sorted_results, args[2], quote=FALSE, col.names=NA, sep="\t")
