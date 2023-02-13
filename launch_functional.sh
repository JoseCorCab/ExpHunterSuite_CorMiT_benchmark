#!/usr/bin/env bash
#SBATCH --cpus-per-task=1
#SBATCH --mem='30gb'
#SBATCH --constraint=cal
#SBATCH --time='05:00:00'

source ~soft_bio_267/initializes/init_degenes_hunter
export PATH=~/software/ExpHunterSuite/inst/scripts/:$PATH

input_path=$f_input_path/results/$strategy
over_miRNA_path=$f_output_path/overexpressed_miRNA
under_miRNA_path=$f_output_path/underexpressed_miRNA
mkdir -p $over_miRNA_path
mkdir -p $under_miRNA_path

cp $input_path/all_miRNA_summary.txt $input_path/target_results_table.txt $input_path/../hunter_results_table_translated.txt $input_path/../miRNA_target.html $f_output_path/../

#echo -e "cluster\tgeneid\tlog2_FC" > $all_miRNA_path/grouped_miRNA_ATTR.txt

#tail -n +2  $input_path/target_results_table.txt | cut -f 4,10|sort -u| awk '{IFS=" "; OFS="\t"}{print "ALL_MIRNA",$1,$2}' >> $all_miRNA_path/grouped_miRNA_ATTR.txt 

tail -n +2  $input_path/target_results_table.txt |awk '{if($12 > 0) print $1}'|sort -u > overexpressed_miRNAs

while read -r line; do
	echo -e "$line" > test.text
	miRNA_name=`echo -e "$line" | cut -f 1`	
	if `grep -q $miRNA_name overexpressed_miRNAs`; then
		echo -e "$line" >> $over_miRNA_path/overexpressed_miRNA.txt	
	else
		echo -e "$line" >> $under_miRNA_path/underexpressed_miRNA.txt
	fi
done < $input_path/miRNA_to_enrich.txt


clusters_to_enrichment.R -p $f_pval  -w 6 -i $input_path/miRNA_to_enrich.txt -g $input_path/gene_attributes.txt -o $f_output_path -f $funsys -O $F_organism -k ENSEMBL $Add_opt_enr &>$f_output_path/func_err  
clusters_to_enrichment.R -p $f_pval -w 6 -i  $over_miRNA_path/overexpressed_miRNA.txt -g $input_path/gene_attributes.txt -o $over_miRNA_path -f $funsys -O $F_organism -k ENSEMBL $Add_opt_enr &>$over_miRNA_path/func_err 
clusters_to_enrichment.R -p $f_pval -w 6 -i $under_miRNA_path/underexpressed_miRNA.txt -g $input_path/gene_attributes.txt -o $under_miRNA_path -f $funsys -O $F_organism -k ENSEMBL $Add_opt_enr &>$under_miRNA_path/func_err

