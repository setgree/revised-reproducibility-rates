library(readxl)

# Check ALL_DATA file
cat("===== ALL_DATA.xlsx =====\n")
sheets <- excel_sheets("ALL_DATA.xlsx")
cat("Sheets:", paste(sheets, collapse=", "), "\n\n")

for (sheet in sheets) {
  cat("\n--- Sheet:", sheet, "---\n")
  data <- read_excel("ALL_DATA.xlsx", sheet=sheet, .name_repair="minimal")
  cat("Dimensions:", nrow(data), "rows x", ncol(data), "cols\n")
  cat("Column names:", paste(head(names(data), 20), collapse=", "), "\n")

  # Try to identify the data structure
  if (nrow(data) > 0) {
    cat("\nFirst 5 rows:\n")
    print(head(data, 5))
  }
}

# Check Classroom file
cat("\n\n===== Classroom_Data_Faces_2012_and_2013.xlsx =====\n")
sheets2 <- excel_sheets("Classroom_Data_Faces_2012_and_2013.xlsx")
cat("Sheets:", paste(sheets2, collapse=", "), "\n\n")

for (sheet in sheets2) {
  cat("\n--- Sheet:", sheet, "---\n")
  data <- read_excel("Classroom_Data_Faces_2012_and_2013.xlsx", sheet=sheet, .name_repair="minimal")
  cat("Dimensions:", nrow(data), "rows x", ncol(data), "cols\n")
  if (ncol(data) > 0) {
    cat("Column names:", paste(names(data), collapse=", "), "\n")
  }
  if (nrow(data) > 0 && ncol(data) > 0) {
    cat("\nFirst few rows:\n")
    print(head(data, 5))
  }
}
