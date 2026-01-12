library(readxl)

# Check all sheets more carefully
cat("===== SEARCHING FOR FACES DATA IN ALL_DATA.xlsx =====\n\n")

# Read the entire "tables & graphs" sheet
data <- read_excel("ALL_DATA.xlsx", sheet="tables & graphs", .name_repair="minimal")

# Look for any mention of "face" or "schematic"
cat("Searching for 'face' or 'schematic' in all cells...\n")
face_rows <- which(apply(data, 1, function(x) any(grepl("face|schematic", x, ignore.case=TRUE))))
if (length(face_rows) > 0) {
  cat("Found at rows:", face_rows, "\n\n")
  for (row in face_rows) {
    cat("Row", row, ":\n")
    print(data[row, ])
    cat("\n")
  }
} else {
  cat("No 'face' or 'schematic' mentions found\n\n")
}

# Check the percentages sheet if it exists
cat("\n\n===== CHECKING CLASSROOM DATA PERCENTAGES SHEET =====\n")
classroom_sheets <- excel_sheets("Classroom_Data_Faces_2012_and_2013.xlsx")
cat("Sheets in Classroom file:\n")
print(classroom_sheets)

if ("percentages" %in% classroom_sheets) {
  cat("\nReading percentages sheet:\n")
  perc_data <- read_excel("Classroom_Data_Faces_2012_and_2013.xlsx", sheet="percentages")
  print(perc_data)
}
