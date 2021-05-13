#!/usr/bin/env bash

source ~soft_bio_267/initializes/init_autoflow

output=$SCRATCH'/NGS_projects/LaforaRNAseq/target_miRNA_wf'
ADD_OPTIONS=$1


AF_VARS=`echo "
\\$multimir_path=~josecordoba/proyectos/multimir_db/p_mmu,
\\$rnaseq_input_path=$SCRATCH/NGS_projects/LaforaRNAseq/RNA_seq/DEGenesHunter_results/ctrl_vs_mut,
\\$mirnaseq_input_path=$SCRATCH/NGS_projects/LaforaRNAseq/DEA_miRNA_seq/DEGenesHunter_results/ctrl_vs_mut,
\\$organism=mmu,
\\$corr_thrs=0.65;0.7;0.75;0.8;0.85;0.9
" | tr -d [:space:]`

echo "AutoFlow -e -w targets_templates.af -V $AF_VARS -o $output $ADD_OPTIONS"
AutoFlow -e -w targets_templates.af -V $AF_VARS -o $output $ADD_OPTIONS
