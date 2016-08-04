require(stringr)

get_pep_from_peptides = function(peptide_ids_to_map, peptide_df) {
    pepscores = matrix(peptide_df[, "PEP"])
    row.names(pepscores) = peptide_df[, "id"]
    calculated_pep_score = vapply(peptide_ids_to_map, FUN.VALUE = numeric(1), function(x) {
        prod(pepscores[unlist(str_split(x, ";")),])
    })
    return(calculated_pep_score)
}

#Set your working directory to the /txt folder from your MaxQuant output or just provide the path as /path/to/file.txt in quotations below.
your_proteingroups = read.delim("proteinGroups.txt", header = TRUE, stringsAsFactors = FALSE) 
your_peptides = read.delim("peptides.txt", header = TRUE, stringsAsFactors = FALSE)

#Calculate the PEP scores and add as a new column "PEP" to the protein data. 
#R will strip the spaces from the column headers in your files, so "Peptide IDs" becomes "Peptide.IDs".
your_proteingroups$PEP = get_pep_from_peptides(peptide_ids_to_map = your_proteingroups$Peptide.IDs, peptide_df = your_peptides)

#Save the output as a tab-delimited text file.
write.table(your_proteingroups, "proteinGroups_PEP.txt", row.names = FALSE, sep = "\t", quote = FALSE)