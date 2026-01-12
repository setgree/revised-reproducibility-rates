# Blanken 2014 - Convert SPSS and run analyses
library(haven)

# Read SPSS data
data <- read_sav("Study3_mturk_clean.sav")

cat("Blanken 2014 - Study 3 (MTurk)\n")
cat("N =", nrow(data), "rows\n")
cat("Variables =", ncol(data), "\n\n")

# Show first few column names
cat("First 30 variables:\n")
print(names(data)[1:30])

# Show structure
cat("\n\nData structure:\n")
str(data[,1:10])

# Save as CSV
write.csv(data, "blanken_data.csv", row.names=FALSE)
cat("\nSaved to blanken_data.csv\n")
