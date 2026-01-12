library(readxl)
library(dplyr)

df <- read_excel('lakens_data.xlsx')

papers <- c("Burger", "Gibson", "Soliman")

for (paper_name in papers) {
  cat("\n", paste(rep("=", 70), collapse=""), "\n")
  cat("===== ", toupper(paper_name), " =====\n")
  cat(paste(rep("=", 70), collapse=""), "\n\n")

  paper <- df %>%
    filter(grepl(paper_name, study, ignore.case=TRUE))

  if (nrow(paper) > 0) {
    cat("Study:", paper$study, "\n")
    cat("Data URL:", paper$url_dataset, "\n")
    cat("Code URL:", paper$url_scripts, "\n")
    cat("Language:", paper$programming_language, "\n")
    cat("Run script:", paper$run_script_final, "\n")
    cat("Reproducible:", paper$reproducible_final, "\n\n")

    cat("Issue (from PO):", paper$comments_on_reproducibility_po, "\n")
  } else {
    cat("Paper not found!\n")
  }
}
