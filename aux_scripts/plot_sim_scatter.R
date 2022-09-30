#!/usr/bin/env Rscript

library(ggplot2)


print("USAGE: plot_sim_scatter.R target_results_table.txt ensembl_SemSim.txt")
args <- commandArgs(trailingOnly = TRUE)


target_results <- read.table(args[1], header = TRUE)
module_info <- read.table(args[3], header = TRUE)

similarities <- read.table(args[2])
colnames(similarities) <- c("RNAseq", "similarity")

targets_with_sim <- merge(target_results, similarities, by.x = "Target_ID", by.y = "RNAseq", all.x = TRUE)
module_info <- module_info[,c("miRNA","RNA_mod", "Pred_percentage", "Val_percentage" )] 
complete_table <- merge(targets_with_sim, module_info, by.x=c("miRNA", "RNA_mod"), by.y = c("miRNA","RNA_mod"), all.x = TRUE)
complete_table$RNA_mod <- as.character(complete_table$RNA_mod)
# save(complete_table, file = "/mnt/scratch/users/bio_267_uma/josecordoba/NGS_projects/LaforaRNAseq/target_miRNA_wf_DEG/merge_targets_and_sim.rb_0003/test.Rdata")
pdf(file.path(paste0(args[4], ".pdf")))

 ggplot(complete_table, aes(x = Predicted_DB_count, y = Validated_DB_count)) +
	geom_point(aes(fill = miRNA, colour = miRNA, shape = RNA_mod, size = similarity), alpha = 0.7)  #+  scale_x_discrete(guide = guide_axis(n.dodge = 2)) + NULL
dev.off()

#sorting and writting table

complete_table <- complete_table[with(complete_table, order(-similarity, -Predicted_DB_count, -Validated_DB_count, -Val_percentage, -Pred_percentage)), ]

write.table(complete_table, "target_results_table_sim.txt", quote = FALSE, sep = "\t")

