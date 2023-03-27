#!/usr/bin/env bash

source ~soft_bio_267/initializes/init_autoflow
CODE_PATH=`pwd`
ADD_OPTIONS=$2
module=$1
report_template_folder=$CODE_PATH/templates
CONFIG_DAEMON=$CODE_PATH/config_daemon
if [ "$3" != "" ] ; then
	CONFIG_DAEMON=$3
fi


source $CONFIG_DAEMON
export PATH=$CODE_PATH/aux_scripts:$PATH


mkdir -p $output

if [ "$module" == "download" ] ; then
	curl 'https://www.genenames.org/cgi-bin/download/custom?col=gd_hgnc_id&col=md_ensembl_id&status=Approved&status=Entry%20Withdrawn&hgnc_dbtag=on&order_by=gd_app_sym_sort&format=text&submit=submit' |tail -n +2 | awk '{if ($2 != ""){ print $0}}' > $CODE_PATH/HGNC_enemsbl_hs

elif [ "$module" == "1" ] ; then


	AF_VARS=`echo "
	\\$multimir_path=$Multimir_path,
	\\$rnaseq_input_path=$RNAseq_input,
	\\$mirnaseq_input_path=$miRNA_seq_input,
	\\$organism=$Organism,
	\\$ADD_OPT_corr=$Add_opt_corr,
	\\$corr_thrs=$CORR_THR,
	\\$f_organism=$F_organism,
	\\$ADD_OPT_enrichment=$Add_opt_enr,
	\\$REPORT_TEMPLATES_FOLDER=$report_template_folder,
	\\$F_pval=$f_pval
	" | tr -d [:space:]`

	AutoFlow -e -w $CODE_PATH/templates/targets_templates.af -V $AF_VARS -o $output $ADD_OPTIONS

elif [ "$module" == "2" ] ; then
	sbatch $CODE_PATH/launch_functional.sh
	#$CODE_PATH/launch_functional.sh
fi
