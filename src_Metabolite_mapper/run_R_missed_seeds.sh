#!/bin/bash

patient_number=$7
thresholds=$1
maxrxns=$2
steps=$3
code_dir=$4
seed_file=$5 
R_location=$6

$R_location/Rscript $code_dir/GeneMetabMapper.R $patient_number $thresholds $maxrxns $steps $code_dir $seed_file $R_location
