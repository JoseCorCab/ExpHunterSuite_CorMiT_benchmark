#!/usr/bin/env bash

mkdir -p $CODE_PATH/miRNA_target_results/functional_enrichment
mkdir $CODE_PATH/miRNA_target_results/functional_enrichment/data_files
mkdir $CODE_PATH/miRNA_target_results/functional_enrichment/reports

cp $output/clusters_to_enrichment.R_0000/DB_functional/*html $CODE_PATH/miRNA_target_results/functional_enrichment/reports/
cp $output/clusters_to_enrichment.R_0000/DB_functional/*csv  $CODE_PATH/miRNA_target_results/functional_enrichment/data_files/
cp $output/coRmiT.R_0000/results/target_results_table.txt $output/coRmiT.R_0000/results/miRNA_target.html $CODE_PATH/miRNA_target_results/
