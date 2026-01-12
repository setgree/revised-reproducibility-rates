library(readxl)

df <- read_excel('lakens_data.xlsx')

cat("Column names in lakens_data.xlsx:\n")
print(names(df))
cat("\n\nFirst few rows:\n")
print(head(df[, 1:10]))
