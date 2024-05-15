#!/usr/bin/env bash

mkdir -p $CODE_PATH/miRNA_target_results/functional_enrichment

cp $output/clusters_to_enrichment.R_0000/DB_functional/*html $output/clusters_to_enrichment.R_0000/DB_functional/*csv  $CODE_PATH/miRNA_target_results/functional_enrichment/
cp $output/coRmiT.R_0000/results/target_results_table.txt $CODE_PATH/miRNA_target_results/
