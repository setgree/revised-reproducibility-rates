library(readxl)
library(dplyr)

df <- read_excel('lakens_data.xlsx')

gibson <- df %>%
  filter(grepl("Gibson", study, ignore.case=TRUE))

cat("===== ALL GIBSON INFO =====\n\n")
print(names(df))

cat("\n\n===== GIBSON ROW =====\n")
print(as.data.frame(t(gibson)))
