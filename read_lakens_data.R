library(readxl)

# Read the Excel file
data <- read_excel("lakens_data.xlsx")

# Show column names
cat("Column names:\n")
print(names(data))

cat("\n\nFirst 3 rows:\n")
print(as.data.frame(data[1:3, ]))

cat("\n\nTotal rows:", nrow(data), "\n")
