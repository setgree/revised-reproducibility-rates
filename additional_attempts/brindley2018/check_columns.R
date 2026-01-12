library(haven)
data <- read_sav("Study1_Data.sav")
# Check if BehVIG items exist
behvig_cols <- grep("BehVIG", names(data), value=TRUE)
print(behvig_cols)
