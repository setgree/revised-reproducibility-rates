library(readxl)
library(dplyr)

df <- read_excel('lakens_data.xlsx')

burger <- df %>%
  filter(grepl("Burger", study, ignore.case=TRUE))

cat("===== BURGER 2017 INFO =====\n\n")
cat("Study:", burger$study, "\n")
cat("Data URL:", burger$url_dataset, "\n")
cat("Code URL:", burger$url_scripts, "\n")
cat("Language:", burger$programming_language, "\n")
cat("Run script:", burger$run_script_final, "\n")
cat("Reproducible:", burger$reproducible_final, "\n\n")

cat("All comments:\n")
cat("SG:", burger$comments_on_reproducibility_sg, "\n")
cat("PO:", burger$comments_on_reproducibility_po, "\n")
cat("JG:", burger$comments_on_reproducibility_jg, "\n")
cat("NC:", burger$comments_on_reproducibility_nc, "\n")
cat("DL:", burger$comments_on_reproducibility_dl, "\n")
