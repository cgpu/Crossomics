run <- function(entry, outdir, src){
  # entry=1
  # outdir="./Results"
  # src="./src"
  
  # src="/hpc/shared/dbg_mz/marcel/Crossomics_Build_Metabolite_Set/src"
  # outdir="/hpc/shared/dbg_mz/marcel/Crossomics_Build_Metabolite_Set/Results"
  
  # reconVersion=2.0

  # source(paste(src, "Crossomics/sourceDir.R", sep="/"))
  # sourceDir(paste(src, "Crossomics/build_mets_set", sep="/"))
  # sourceDir(paste(src, "Crossomics", sep="/"))
  
  source(paste0(src,"/Supportive/sourceDir.R"))
  sourceDir(paste0(src,"/Supportive"))
  
  # if (reconVersion==2.2){
  #   
  #   load(paste(src, "Recon_2.2_biomodels.RData", sep="/"))
  #   load(paste(src, "recon2chebi_MODEL1603150001.RData", sep="/"))
  #   rownames(recon2chebi)=recon2chebi[,1]
  #   recon2chebi=recon2chebi[model@met_id,]
  #   
  # } else if (reconVersion==2.0){
  #   
  #   load(paste(src, "Recon2.RData", sep="/"))
  #   model=recon2$modelR204[,,1]
  #   recon2chebi=NULL
  # }
  
  # load(paste(src, "Recon3D.RData", sep="/"))
  load(paste(src, "../Data/Recon3D.RData", sep="/"))
  model=Recon3D$Recon3D[,,1]
  # Fix CHEBI: naming, where some Chebi codes are noted like this: "CHEBI:00001" and some like this: "00001"
  model$metCHEBIID <- rapply(model$metCHEBIID, gsub, pattern = "CHEBI:", replacement = "", ignore.case=TRUE, how = "list")
  
  recon2chebi=NULL
  
  # message(dim(model$S))
  
  # dir.create(paste(src, "../../Results/mss_0", sep="/"),showWarnings = FALSE)
  # dir.create(paste(src, "../../Results/mss_1", sep="/"),showWarnings = FALSE)
  # dir.create(paste(src, "../../Results/mss_2", sep="/"),showWarnings = FALSE)
  # dir.create(paste(src, "../../Results/mss_3", sep="/"),showWarnings = FALSE)
  # dir.create(paste(src, "../../Results/mss_4", sep="/"),showWarnings = FALSE)
  
  dir.create(paste0(outdir, "/mss_0"), showWarnings = FALSE)
  dir.create(paste0(outdir, "/mss_1"), showWarnings = FALSE)
  dir.create(paste0(outdir, "/mss_2"), showWarnings = FALSE)
  dir.create(paste0(outdir, "/mss_3"), showWarnings = FALSE)
  dir.create(paste0(outdir, "/mss_4"), showWarnings = FALSE)
  
  # load(paste(src, "../../Results/metabolite_sets_step_0,1,2,3_1.0_filter_1.1/mss_1", files[i], sep="/"))
  # 
  # myFirstDim=NULL
  # files = list.files(paste(src, "../../Results/metabolite_sets_step_0,1,2,3_1.0_filter_1.1/mss_0", sep="/"))
  # for (i in 1:length(files)) {
  #   load(paste(src, "../../Results/metabolite_sets_step_0,1,2,3_1.0_filter_1.1/mss_0", files[i], sep="/"))
  #   # message(paste("i",i))
  #   # message(dim(result_mets_0)[1])
  #   if (is.null(dim(result_mets_0)[1])){
  #     message(i)
  #     myFirstDim=c(myFirstDim,1)
  #   }
  #   myFirstDim=c(myFirstDim,dim(result_mets_0)[1])
  # }

  # files = list.files(paste(src, "../../Results/metabolite_sets_step_0,1,2,3_1.0_filter_1.1/mss_WG_step_0", sep="/"))
  # files = list.files(paste(src, "../../Results/mss", sep="/"))
  files = list.files(paste(src, "../Data/mss", sep="/"))
  # files = list.files(paste(src, "../../Results/mss_PathwayCommons", sep="/"))
  # SLC7A7: entry=18425
  # grep("SLC7A7", files)
  
  # message(paste(src, "../../Results/mss_PathwayCommons"))
  message(files[entry])
  # message(paste(src, "../../Results/mss_PathwayCommons", files[entry], sep="/"))

  # load(paste(src, "../../Results/mss_PathwayCommons", files[entry], sep="/"))
  # load(paste(src, "../../Results/metabolite_sets_step_0,1,2,3_1.0_filter_1.1/mss_WG_step_0", files[entry], sep="/"))
  # load(paste(src, "../../Results/mss", files[entry], sep="/"))
  load(paste(src, "../Data/mss", files[entry], sep="/"))
  
  if (!is.null(rval)){
    hgnc = unlist(strsplit(files[entry], split = ".", fixed = TRUE))[1]
      
    findMetabolicEnvironmentLocal(gene_in = hgnc, model = model, recon2chebi = recon2chebi, src = src, outdir = outdir, rval = rval)
  }
  
}

message("Start")
# cat("==> reading arguments:\n", sep = "")

cmd_args = commandArgs(trailingOnly = TRUE)

# TEST code{
# library("rstudioapi")
# code_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
# # cmd_args <- c("1", "/Users/mkerkho7/DIMS2_repo/Crossomics/Results", "/Users/mkerkho7/DIMS2_repo/Crossomics/src_Metabolite_Set_Creation")
# cmd_args <- c("2347", "/Users/mkerkho7/DIMS2_repo/Crossomics/Data", code_dir)
#}

# for (arg in cmd_args) cat("  ", arg, "\n", sep="")

# library("rstudioapi")
# code_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)

run(entry = as.numeric(cmd_args[1]), outdir = cmd_args[2], src = cmd_args[3])
# run(entry = as.numeric(cmd_args[1]), outdir = cmd_args[2], src = code_dir)

message("Ready")
