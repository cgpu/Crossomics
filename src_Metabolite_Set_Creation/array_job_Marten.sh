#!/bin/bash

# if [ "$SGE_TASK_ID" = "undefined" ]; then
#   echo "No array range defined! Specify -t option"
# else
#   gene_id=$SGE_TASK_ID
# fi

if [ "$1" = "undefined" ]; then
  echo "No array range defined! Specify -t option"
else
  gene_id=$1
fi

# scripts="/hpc/shared/dbg_mz/marcel/Crossomics_Build_Metabolite_Set/src"
# outdir="/hpc/shared/dbg_mz/marcel/Crossomics_Build_Metabolite_Set/results"

#scripts="/Volumes/Metab/Metabolomics/DIMS_pipeline/R_workspace_MartenK/Crossomics/src2"
scripts="/Users/mkerkho7/DIMS2_repo/Crossomics/src/src_Metabolite_Set_Creation"
outdir="/Users/mkerkho7/DIMS2_repo/Crossomics/Results"

echo "Run set $gene_id in R"

# module load R
R --slave --no-save --no-restore --no-environ --args $gene_id $outdir $scripts < "$scripts/findSurroundings_Marten.R"
