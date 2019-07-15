#! /bin/bash

# load(paste(src, "HGNC2Uniprot.RData", sep="/"))
# dim(HGNC2Uniprot) => 19266

#scripts="/hpc/shared/dbg_mz/marcel/Crossomics_Build_Metabolite_Set/src"
scripts="/Users/mkerkho7/DIMS2_repo/Crossomics/src/src_Metabolite_Set_Creation"

#qsub -l h_rt=08:00:00 -l h_vmem=16G -t 1-22968:1 -tc 50 $scripts/array_job.sh
#for gene_id in {1..22968}
for gene_id in {16961..20351}
do
    $scripts/array_job_Marten.sh $gene_id
done