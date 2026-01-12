library(readxl)
library(dplyr)

df <- read_excel('lakens_data.xlsx')

# Get all columns for Campbell rows
campbell_rows <- df %>%
  filter(grepl("Campbell", study, ignore.case=TRUE)) %>%
  select(study, doi, url_dataset, url_scripts, run_script_final, reproducible_final, 
         programming_language, comments_on_reproducibility_po)

cat("===== ALL CAMPBELL ENTRIES =====\n\n")
for (i in 1:nrow(campbell_rows)) {
  cat("Entry", i, ":\n")
  cat("  DOI:", campbell_rows$doi[i], "\n")
  cat("  Data URL:", campbell_rows$url_dataset[i], "\n")
  cat("  Code URL:", campbell_rows$url_scripts[i], "\n")
  cat("  Language:", campbell_rows$programming_language[i], "\n")
  cat("  Run script:", campbell_rows$run_script_final[i], "\n")
  cat("  Reproducible:", campbell_rows$reproducible_final[i], "\n")
  cat("  PO comment:", campbell_rows$comments_on_reproducibility_po[i], "\n\n")
}
