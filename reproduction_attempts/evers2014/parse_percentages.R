library(readxl)
library(dplyr)

cat("===== PARSING PERCENTAGES SHEET =====\n\n")

# Read the percentages sheet more carefully
data <- read_excel("Classroom_Data_Faces_2012_and_2013.xlsx", sheet="percentages", 
                   col_names=FALSE, .name_repair="minimal")

cat("Raw data (first 10 rows):\n")
print(data[1:10, 1:15])

cat("\n\n===== INTERPRETING THE LAYOUT =====\n")
cat("It looks like:\n")
cat("- Columns show different conditions/versions\n")
cat("- Row 3 has labels: Sample, b, q, c (for one version) and Sample, b, p, c (for other)\n")
cat("- Row 4: 2012 data\n")
cat("- Row 5: 2013 data\n\n")

# Manually parse
year_2012_with_q <- c(b=23, q=0, c=18)
year_2012_with_p <- c(b=20, p=0, c=25)  # Wait, this shows p=0 too?
year_2013_with_q <- c(b=45, q=0, c=18)
year_2013_with_p <- c(b=29, p=8, c=33)

cat("2012 with q (frowning distractor):", paste(names(year_2012_with_q), year_2012_with_q, sep="=", collapse=", "), "\n")
cat("2012 with p (smiling distractor):", paste(names(year_2012_with_p), year_2012_with_p, sep="=", collapse=", "), "\n")
cat("2013 with q (frowning distractor):", paste(names(year_2013_with_q), year_2013_with_q, sep="=", collapse=", "), "\n")
cat("2013 with p (smiling distractor):", paste(names(year_2013_with_p), year_2013_with_p, sep="=", collapse=", "), "\n\n")

cat("Total combined:\n")
cat("Condition with q (frowning distractor): b=", 23+45, ", q=", 0+0, ", c=", 18+18, "\n")
cat("Condition with p (smiling distractor): b=", 20+29, ", p=", 0+8, ", c=", 25+33, "\n\n")

cat("This matches my analysis:\n")
cat("- Condition 2 (frowning distractor): b=68, c=36 (68 vs my count)\n")
cat("- Condition 1 (smiling distractor): b=49, c=58, p=8\n\n")

cat("Now let me verify against my totals:\n")
total_cond1 <- 20+25 + 29+8+33  # Should be 115
total_cond2 <- 23+0+18 + 45+0+18  # Should be 104

cat("Condition 1 total:", total_cond1, "(expected 115)\n")
cat("Condition 2 total:", total_cond2, "(expected 104)\n")
