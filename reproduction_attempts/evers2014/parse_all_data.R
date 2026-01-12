library(readxl)
library(dplyr)

cat("===== TRYING TO PARSE ALL_DATA.xlsx =====\n\n")

# Try reading "tables & graphs" sheet, skipping notes
data <- read_excel("ALL_DATA.xlsx", sheet="tables & graphs", skip=3, .name_repair="minimal")

cat("After skipping header rows:\n")
cat("Dimensions:", nrow(data), "rows x", ncol(data), "cols\n\n")

cat("Column names:\n")
print(names(data))

cat("\n\nFirst 20 rows:\n")
print(head(data, 20))

# Look for any columns that might indicate condition/choice
cat("\n\nLooking for face or countries data...\n")
cat("Columns with 'Dutch' or 'Mturk':\n")
dutch_cols <- grep("Dutch|Mturk", names(data), ignore.case=TRUE, value=TRUE)
print(dutch_cols)
