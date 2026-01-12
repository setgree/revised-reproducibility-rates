library(readxl)
library(dplyr)

data <- read_excel("lakens_data.xlsx")

# Filter to actual papers (not NAs)
papers <- data %>% filter(!is.na(study))

cat("===== TOTAL PAPERS =====\n")
cat("Total:", nrow(papers), "\n\n")

cat("===== BY MAIN REASON =====\n")
reason_table <- table(papers$main_reason_not_reproducible, useNA="ifany")
print(reason_table)

cat("\n===== BY REPRODUCIBLE_FINAL =====\n")
repro_table <- table(papers$reproducible_final, useNA="ifany")
print(repro_table)

cat("\n===== SCRIPT RAN vs REPRODUCIBLE =====\n")
cat("Script ran (run_script_final==1):", sum(papers$run_script_final == 1, na.rm=TRUE), "\n")
cat("Reproducible (reproducible_final==1):", sum(papers$reproducible_final == 1, na.rm=TRUE), "\n")

# Papers where script ran but not fully reproducible
partial_candidates <- papers %>%
  filter(run_script_final == 1, reproducible_final == 0)

cat("\n===== PARTIAL CANDIDATES (Script ran but reproducible_final==0) =====\n")
cat("Total:", nrow(partial_candidates), "\n\n")

for (i in 1:min(nrow(partial_candidates), 15)) {
  cat("---\n")
  cat("Study:", partial_candidates$study[i], "\n")
  cat("Language:", partial_candidates$programming_language[i], "\n")
  cat("Reason:", partial_candidates$main_reason_not_reproducible[i], "\n")
  if (!is.na(partial_candidates$comments_on_reproducibility_dl[i])) {
    cat("Comment:", substr(partial_candidates$comments_on_reproducibility_dl[i], 1, 200), "\n")
  }
}
