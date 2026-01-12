library(readxl)
library(dplyr)

df <- read_excel('lakens_data.xlsx')

campbell <- df %>%
  filter(grepl("Campbell", study, ignore.case=TRUE))

cat("===== CAMPBELL 2017 INFO FROM LAKENS DATA =====\n\n")
cat("Study:", campbell$study, "\n")
cat("Data URL:", campbell$url_dataset, "\n")
cat("Code URL:", campbell$url_scripts, "\n")
cat("Run script final:", campbell$run_script_final, "\n")
cat("Reproducible final:", campbell$reproducible_final, "\n\n")

cat("Comments from SG (Seth Green):\n")
cat(campbell$comments_on_reproducibility_sg, "\n\n")

cat("Comments from other coders:\n")
cat("PO:", campbell$comments_on_reproducibility_po, "\n")
cat("JG:", campbell$comments_on_reproducibility_jg, "\n")
cat("NC:", campbell$comments_on_reproducibility_nc, "\n")
cat("DL:", campbell$comments_on_reproducibility_dl, "\n")
