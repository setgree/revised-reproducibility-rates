library(readxl)

data <- read_excel("lakens_data.xlsx")

# Find partially reproducible papers
# reproducible_final == 0 means not fully reproducible
# But run_script_final == 1 means script ran

partial <- data[data$run_script_final == 1 & data$reproducible_final == 0, ]

if (nrow(partial) > 0) {
  cat("===== PARTIALLY REPRODUCIBLE PAPERS =====\n")
  cat("Total:", nrow(partial), "papers\n\n")
  
  for (i in 1:nrow(partial)) {
    cat("---\n")
    cat("Study:", partial$study[i], "\n")
    cat("Language:", partial$programming_language[i], "\n")
    cat("Data URL:", partial$url_dataset[i], "\n")
    cat("Script URL:", partial$url_scripts[i], "\n")
    cat("Main reason:", partial$main_reason_not_reproducible[i], "\n")
    cat("Comments:", partial$comments_on_reproducibility_dl[i], "\n")
  }
} else {
  cat("No partially reproducible papers found with these criteria.\n")
  cat("\nLet me check the data structure...\n")
  cat("Columns related to reproducibility:\n")
  print(grep("reprod|run_script", names(data), value=TRUE, ignore.case=TRUE))
}
