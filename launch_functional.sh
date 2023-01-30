#!/usr/bin/env bash
#SBATCH --cpus-per-task=16
#SBATCH --mem='60gb'
#SBATCH --constraint=cal
#SBATCH --time='05:00:00'

source ~soft_bio_267/initializes/init_degenes_hunter
#export PATH=~/software/ExpHunterSuite/inst/scripts/:$PATH

input_path=$f_input_path/results/$strategy
all_miRNA_path=$f_output_path/all_miRNA
mkdir -p $all_miRNA_path
cp $input_path/all_miRNA_summary.txt  $input_path/target_results_table.txt $input_path/../hunter_results_table_translated.txt $input_path/../miRNA_target.html $f_output_path/../

echo -e "cluster\tgeneid\tmiRNA_count" > $all_miRNA_path/ALL_MIRNA_ATTR.txt
cut -f 2 /mnt/scratch/users/bio_267_uma/josecordoba/NGS_projects/muerte_subita_rocio_toro/miRNA_target_mouse/target_wf_bicor/coRmiT.R_0006/results/hub_1_RNA_vs_miRNA_Eigengene/miRNA_to_enrich.txt | tr "," "\n" | sort | uniq -c | sed -r 's/^ +//g'| awk '{IFS=" "; OFS="\t"}{print "ALL_MIRNA",$2,$1}' >> $all_miRNA_path/ALL_MIRNA_ATTR.txt 

echo -e ALL_MIRNA"\t"`cut -f 2 $all_miRNA_path/ALL_MIRNA_ATTR.txt |tail -n +2 | head -c -1 |tr "\n" ","` > $all_miRNA_path/ALL_MIRNA.txt

clusters_to_enrichment.R -p $f_pval -w 16 -i $input_path/miRNA_to_enrich.txt -g $input_path/gene_attributes.txt -o $f_output_path -f $funsys -F -O $F_organism -k ENSEMBL $Add_opt_enr &>$f_output_path/func_err
clusters_to_enrichment.R -p $f_pval -w 16 -i $all_miRNA_path/ALL_MIRNA.txt -g $all_miRNA_path/ALL_MIRNA_ATTR.txt -o $all_miRNA_path -f $funsys -F -O $F_organism -k ENSEMBL $Add_opt_enr &>$all_miRNA_path/func_err_all_miRNA
