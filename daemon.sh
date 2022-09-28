#!/usr/bin/env bash

source ~soft_bio_267/initializes/init_autoflow
CODE_PATH=`pwd`
ADD_OPTIONS=$2
module=$1
source $CODE_PATH/config_daemon


if [ "$module" == "1" ] ; then


	AF_VARS=`echo "
	\\$multimir_path=$Multimir_path,
	\\$rnaseq_input_path=$RNAseq_input,
	\\$mirnaseq_input_path=$miRNA_seq_input,
	\\$organism=$Organism,
	\\$ADD_OPT_corr=$Add_opt_corr,
	\\$corr_thrs=$CORR_THR,
	\\$f_organism=$F_organism,
	\\$ADD_OPT_enrichment=$Add_opt_enr
	" | tr -d [:space:]`

	AutoFlow -e -w targets_templates.af -V $AF_VARS -o $output $ADD_OPTIONS

elif [ "$module" == "2" ] ; then
	$CODE_PATH/launch_functional.sh
fi