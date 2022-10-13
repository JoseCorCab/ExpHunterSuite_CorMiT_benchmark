#!/usr/bin/env bash
#SBATCH --cpus-per-task=16
#SBATCH --mem='60gb'
#SBATCH --constraint=cal
#SBATCH --time='05:00:00'

source ~soft_bio_267/initializes/init_degenes_hunter
export PATH=~/software/ExpHunterSuite/inst/scripts/:$PATH

input_path=$f_input_path/results/$strategy
clusters_to_enrichment.R -w 16 -i $input_path/miRNA_to_enrich.txt -g $input_path/gene_attributes.txt -o $f_output_path -f $funsys -O $F_organism -k ENSEMBL $Add_opt_enr
