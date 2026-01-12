library(readxl)
library(dplyr)

df <- read_excel('lakens_data.xlsx')

# Find papers with data URLs but script didn't run or wasn't attempted
papers <- df %>%
  filter(
    (is.na(run_script_final) | run_script_final == 0) &
    !is.na(url_dataset) & url_dataset != ""
  ) %>%
  select(study, url_dataset, url_scripts, run_script_final, reproducible_final, comments_on_reproducibility_sg)

cat("Papers with data but script didn't run or wasn't attempted:\n")
cat(paste(rep("=", 80), collapse=""), "\n\n")

for (i in 1:nrow(papers)) {
  cat(papers$study[i], "\n")
  cat("  Data URL:", papers$url_dataset[i], "\n")
  cat("  Code URL:", ifelse(is.na(papers$url_scripts[i]), "None", papers$url_scripts[i]), "\n")
  cat("  Script ran:", papers$run_script_final[i], "\n")
  cat("  Comments:", ifelse(is.na(papers$comments_on_reproducibility_sg[i]), "None", papers$comments_on_reproducibility_sg[i]), "\n\n")
}
