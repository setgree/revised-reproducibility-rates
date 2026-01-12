library(readxl)

data <- read_excel("lakens_data.xlsx")

# Look for papers where reproducible_final is not REPRODUCIBLE but also not a failure
# The issue is that "partially reproducible" might be coded differently

cat("Unique values in reproducible_final:\n")
print(table(data$reproducible_final, useNA="ifany"))

cat("\n\nUnique values in main_reason_not_reproducible:\n")
print(table(data$main_reason_not_reproducible, useNA="ifany"))

# Find papers where script ran but not fully reproducible
partially <- data[!is.na(data$reproducible_final) & 
                  data$reproducible_final == 0 &
                  !is.na(data$main_reason_not_reproducible) &
                  data$main_reason_not_reproducible %in% c("partially reproducible", "minor numerical errors"),]

cat("\n\n===== PAPERS WITH PARTIAL ISSUES =====\n")
cat("Found:", nrow(partially), "papers\n\n")

if (nrow(partially) > 0) {
  for (i in 1:nrow(partially)) {
    cat("Study:", partially$study[i], "\n")
    cat("Reason:", partially$main_reason_not_reproducible[i], "\n")
    cat("Language:", partially$programming_language[i], "\n\n")
  }
}

# Also check: what about papers marked as "1" for reproducible?
fully <- data[!is.na(data$reproducible_final) & data$reproducible_final == 1,]
cat("\n===== FULLY REPRODUCIBLE PAPERS (according to data) =====\n")
cat("Total:", nrow(fully), "\n")
