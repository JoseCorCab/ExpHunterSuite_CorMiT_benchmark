#!/usr/bin/env bash
#SBATCH --cpus-per-task=16
#SBATCH --mem='60gb'
#SBATCH --constraint=cal
#SBATCH --time='05:00:00'

source ~soft_bio_267/initializes/init_degenes_hunter
#export PATH=~/software/ExpHunterSuite/inst/scripts/:$PATH

input_path=$f_input_path/results/$strategy
mkdir -p $f_output_path
cp $input_path/all_miRNA_summary.txt  $input_path/target_results_table.txt $input_path/../hunter_results_table_translated.txt $input_path/../miRNA_target.html $f_output_path/../
clusters_to_enrichment.R -p $f_pval -w 16 -i $input_path/miRNA_to_enrich.txt -g $input_path/gene_attributes.txt -o $f_output_path -f $funsys -F -O $F_organism -k ENSEMBL $Add_opt_enr
