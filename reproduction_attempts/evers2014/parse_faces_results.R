library(readxl)

cat("===== PARSING FACES RESULTS FROM ALL_DATA.xlsx =====\n\n")

# Read around row 87
data <- read_excel("ALL_DATA.xlsx", sheet="tables & graphs", .name_repair="minimal")

# Look at rows 90-96 more carefully (rows around the data)
cat("Rows with data (93-96 from file, which is index 93-96):\n")
for (i in 90:98) {
  cat("\nRow", i, ":\n")
  row_data <- data[i, ]
  # Print non-NA values
  non_na <- which(!is.na(row_data))
  for (col in non_na) {
    cat("  Col", col, ":", as.character(row_data[1, col]), "\n")
  }
}

# Try to extract the actual numbers
cat("\n\n===== EXTRACTING KEY VALUES =====\n")
cat("Looking at rows 93-96:\n")
print(data[93:96, 1:10])

cat("\n\nRow 95 (Dutch students) values:\n")
print(data[95, ])

cat("\n\nRow 96 (mTurk) values:\n")
print(data[96, ])
