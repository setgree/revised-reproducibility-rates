# Reproduction attempt for Steinemann 2017
# Original script modified to fix known issues

# Install and load required packages
packages <- c("ltm", "robustHD", "mvoutlier", "lattice", "gclus", "ggplot2", 
              "car", "psych", "apaStyle", "corrplot", "Hmisc", "lavaan", 
              "semTools", "compute.es", "effects", "multcomp", "WRS2", "pastecs", "xtable")

for(pkg in packages) {
  if(!require(pkg, character.only = TRUE, quietly = TRUE)) {
    tryCatch({
      install.packages(pkg, repos='http://cran.us.r-project.org', quiet = TRUE)
      library(pkg, character.only = TRUE)
    }, error = function(e) {
      cat("Warning: Could not install", pkg, "- continuing without it\n")
    })
  }
}

# Load data (fixed filename)
data <- read.csv("data.csv")

cat("\n=== DATA LOADING ===\n")
cat("Initial sample size:", nrow(data), "\n")

# Data exclusion (from original script)
data<- data[!data$Include=="no - test insti",] 
cat("After excluding test rounds:", nrow(data), "\n")
data<- data[!data$storyoff_yn==-77,] 
cat("After excluding dropouts:", nrow(data), "\n")
data<- data[data$BogusItem==7,] 
cat("After bogus item filter:", nrow(data), "\n")
data<- data[!data$Include=="no - no tracking",] 
cat("After excluding no tracking:", nrow(data), "\n")
data <- data[-which(data$duration>3*sd(data$duration)), ] 
cat("After duration filter:", nrow(data), "\n")
data<- data[!data$Data_quality_carefully_answered==2,]
cat("After quality filter:", nrow(data), "\n")
data<- data[!data$Data_quality_participated_morethanonce==1,]
cat("After duplicates filter:", nrow(data), "\n")
data<- data[!data$textcomp < 3,]
cat("Final sample size:", nrow(data), "\n\n")

cat("=== FIRST ANALYSIS COMPLETE ===\n")
cat("Data successfully loaded and cleaned.\n")
cat("Final N =", nrow(data), "\n")
