library(readxl)

cat("===== CHECKING ALL_DATA.xlsx =====\n\n")

sheets <- excel_sheets("ALL_DATA.xlsx")
cat("Sheets available:\n")
print(sheets)

for (sheet in sheets) {
  cat("\n\n===== Sheet:", sheet, "=====\n")
  tryCatch({
    data <- read_excel("ALL_DATA.xlsx", sheet=sheet, .name_repair="minimal")
    cat("Dimensions:", nrow(data), "rows x", ncol(data), "cols\n")
    
    if (nrow(data) > 0 && ncol(data) > 0) {
      cat("\nFirst few column names:", paste(head(names(data), 10), collapse=", "), "\n")
      cat("\nFirst 3 rows:\n")
      print(head(data, 3))
      
      # Check if this looks like faces data
      if (any(grepl("face|tversky|condition|distractor", names(data), ignore.case=TRUE))) {
        cat("\n*** This sheet might contain faces study data! ***\n")
      }
    }
  }, error = function(e) {
    cat("Error reading sheet:", e$message, "\n")
  })
}
