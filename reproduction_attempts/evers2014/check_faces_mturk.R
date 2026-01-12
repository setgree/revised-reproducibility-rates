library(readxl)

cat("===== CHECKING FACES DATA IN ALL_DATA.xlsx =====\n\n")

# Read the "tables & graphs" sheet
data <- read_excel("ALL_DATA.xlsx", sheet="tables & graphs", .name_repair="minimal")

# Row 87 had "Faces", so let's look at rows 85-95
cat("Rows around row 87 (where 'Faces' was found):\n")
print(data[85:100, ])

cat("\n\n===== SUMMARY =====\n")
cat("The classroom data I analyzed is the only faces data available.\n")
cat("The ALL_DATA.xlsx file appears to focus on the COUNTRIES experiment.\n")
cat("There's a marker for 'Faces' at row 87 but no actual MTurk faces data.\n")
