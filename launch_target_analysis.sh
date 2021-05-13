#!/usr/bin/env bash

source ~soft_bio_267/initializes/init_autoflow

output=''
ADD_OPTIONS=$1


AF_VARS=`echo "
\\$multimir_path='',
\\$rnaseq_input_path='',
\\$mirnaseq_input_path='',
\\$organism='',
\\$corr_thrs=0.65;0.7;0.75;0.8;0.85;0.9
" | tr -d [:space:]`

AutoFlow -e -w targets_templates.af -V $AF_VARS -o $output $ADD_OPTIONS
