library(haven)
library(dplyr)

cat("===== SINCLAIR 2014 - EXAMINING DATA =====\n\n")

# Load SPSS data
data <- read_sav("FinalDelinkedDataSetMTurkRJ_1.sav")

cat("Data dimensions:", nrow(data), "rows x", ncol(data), "cols\n\n")

cat("Column names:\n")
print(names(data))

cat("\n\nFirst few rows:\n")
print(head(data, 10))

cat("\n\nSummary statistics:\n")
print(summary(data[, 1:min(20, ncol(data))]))

cat("\n\nVariable labels (from SPSS):\n")
labels <- sapply(data, function(x) attr(x, "label"))
labels <- labels[!is.na(labels) & labels != ""]
for (i in seq_along(labels)) {
  cat(names(labels)[i], ":", labels[i], "\n")
}
