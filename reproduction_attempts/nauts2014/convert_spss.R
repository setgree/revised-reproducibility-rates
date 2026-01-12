# Convert SPSS .sav to CSV
if (!require(haven, quietly=TRUE)) install.packages('haven', repos='http://cran.us.r-project.org', quiet=TRUE)
library(haven)

# Read SPSS file
data <- read_sav("data/Asch_data.sav")

# Basic info
cat("Dimensions:", nrow(data), "rows,", ncol(data), "columns\n")
cat("First few column names:", paste(names(data)[1:min(20, ncol(data))], collapse=", "), "\n\n")

# Save as CSV
write.csv(data, "Asch_data.csv", row.names=FALSE)
cat("Saved to Asch_data.csv\n")

# Show structure
str(data[,1:10])
