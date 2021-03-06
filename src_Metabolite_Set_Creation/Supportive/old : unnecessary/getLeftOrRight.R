getLeftOrRight <- function(uris, entrezgene, label) {
#   uris=uris3
#   label="left"

  compound=NULL
  chebi_id=NULL
  kegg_id=NULL
  pubchem_id=NULL
  dataSource=NULL
  inchi_key=NULL
  
  for (i in 1:length(uris)){
    
    xml = NULL
    result = tryCatch(
      {xml = traverse(uri = uris[i], path = "SmallMolecule/entityReference:SmallMoleculeReference")}
      , warning = function(w) {
        message("Nothing found!")
      }, error = function(e) {
        message("Nothing found!")
      })
    
    if (is.null(xml)) next
    
    id = strsplit(xpathSApply(traverse(uri = uris[i], path = "SmallMolecule/entityReference:SmallMoleculeReference"), "//value/text()", xmlValue), ":")[[1]][3]
    if (!is.na(id)){
      # chebi id
      chebi_id = c(chebi_id, id)
      compound = c(compound, xpathSApply(traverse(uri = uris[i], path = "SmallMolecule/entityReference:SmallMoleculeReference/displayName"), "//value/text()", xmlValue))
      dataSource = c(dataSource, xpathSApply(traverse(uri = uris[i], path = "SmallMolecule/dataSource"), "//value/text()", xmlValue))
      xrefs = xpathSApply(traverse(uri = uris[i], path = "SmallMolecule/entityReference:SmallMoleculeReference/xref"), "//value/text()", xmlValue)
      if (!length(grep("kegg_compound", xrefs, fixed = TRUE))==0){
        kegg_id = c(kegg_id, strsplit(xrefs[grep("kegg_compound", xrefs, fixed = TRUE)],"_")[[1]][4])
      } else {
        kegg_id = c(kegg_id, NA)
      }
      if (!length(grep("pubchem-compound", xrefs, fixed = TRUE))==0){
        pubchem_id = c(pubchem_id, strsplit(xrefs[grep("pubchem-compound", xrefs, fixed = TRUE)],"_")[[1]][3])
      } else {
        pubchem_id = c(pubchem_id, NA)
      }
      if (!length(grep("inchikey", xrefs, fixed = TRUE))==0){
        inchi_key = c(inchi_key, strsplit(xrefs[grep("inchikey", xrefs, fixed = TRUE)],"_")[[1]][3])
      } else {
        inchi_key = c(inchi_key, NA)
      }

    } else {
      # SmallMoleculeReference
      compound = c(compound, xpathSApply(traverse(uri = uris[i], path = "SmallMolecule/entityReference:SmallMoleculeReference/displayName"), "//value/text()", xmlValue))
      dataSource = c(dataSource, xpathSApply(traverse(uri = uris[i], path = "SmallMolecule/dataSource"), "//value/text()", xmlValue))
      
      xml=NULL
      try({xml=traverse(uri = uris[i], path = "SmallMolecule/entityReference:SmallMoleculeReference/xref")}, silent = TRUE)
      if (is.null(xml)){
        xrefs = NA
      } else {
        xrefs = xpathSApply(xml, "//value/text()", xmlValue)
      }
  
      if (!length(grep("kegg_compound", xrefs, fixed = TRUE))==0){
        kegg_id = c(kegg_id, strsplit(xrefs[grep("kegg_compound", xrefs, fixed = TRUE)],"_")[[1]][4])
      } else if (!length(grep("KEGG_Compound", xrefs, fixed = TRUE))==0){
        kegg_id = c(kegg_id, strsplit(xrefs[grep("KEGG_Compound", xrefs, fixed = TRUE)],"_")[[1]][4])
      } else {
        kegg_id = c(kegg_id, NA)
      }
#       if (!length(grep("CHEBI", xrefs, fixed = TRUE))==0){
#         xrefs = xrefs[grep("CHEBI", xrefs, fixed = TRUE)]
#         xrefs = xrefs[grep("identity", xrefs, fixed = TRUE)]
#         #xrefs = xrefs[length(xrefs)]
#         xrefs = xrefs[1]
#         chebi_id = c(chebi_id, strsplit(xrefs,"_")[[1]][4])
#       } else {
        chebi_id = c(chebi_id, NA)
      # }
      pubchem_id = c(pubchem_id,NA)
      inchi_key = c(inchi_key,NA)
    }
  }
  
  retVal=cbind(compound, kegg_id, chebi_id, pubchem_id, inchi_key, dataSource)
  colnames(retVal) = c("Compound","KEGG_id","CheBI_id", "PubChem_id", "InchI_key","Data Source") 
  
  # save(retVal, file=paste(entrezgene,label,"RData", sep="."))
  
  return(unique(retVal))
}