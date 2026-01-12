library(haven)

# Try to read the SPSS file
data <- read_sav("rotteveel_data.sav")

cat("Data dimensions:", nrow(data), "rows x", ncol(data), "cols\n\n")
cat("Column names:\n")
print(names(data))
cat("\nFirst few rows:\n")
print(head(data))
cat("\nSummary:\n")
print(summary(data))
