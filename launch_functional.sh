#!/usr/bin/env bash
source ~soft_bio_267/initializes/init_degenes_hunter

input_path=$f_input_path/results/$strategy
clusters_to_enrichment.R -i $input_path/miRNA_to_enrich.txt -g $input_path/gene_attributes.txt -o $f_output_path -f $funsys -O $F_organism -k ENSEMBL $Add_opt_enr

