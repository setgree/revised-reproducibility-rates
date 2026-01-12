library(haven)

cat("===== WESSELMAN 2014 - EXAMINING DATA =====\n\n")

# Load both SPSS files
cat("Loading Communication_DV.sav...\n")
comm_data <- read_sav("Communication_DV.sav")
cat("Dimensions:", nrow(comm_data), "rows x", ncol(comm_data), "cols\n")
cat("Columns:", paste(names(comm_data), collapse=", "), "\n\n")

cat("Loading Votes_and_Committees.sav...\n")
votes_data <- read_sav("Votes_and_Committees.sav")
cat("Dimensions:", nrow(votes_data), "rows x", ncol(votes_data), "cols\n")
cat("Columns:", paste(names(votes_data), collapse=", "), "\n\n")

cat("===== Communication Data Summary =====\n")
print(summary(comm_data))

cat("\n\n===== Votes Data Summary =====\n")
print(summary(votes_data))
