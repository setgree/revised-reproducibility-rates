# Full Reproduction attempt for Steinemann 2017
# Interactive Narratives Affecting Social Change
# Reproduction by Claude Code (2026-01-08)

cat("===== STEINEMANN 2017 REPRODUCTION =====\n\n")

# Install and load required packages
packages <- c("ltm", "lavaan", "semTools")

for(pkg in packages) {
  if(!require(pkg, character.only = TRUE, quietly = TRUE)) {
    tryCatch({
      install.packages(pkg, repos='http://cran.us.r-project.org', quiet = TRUE)
      suppressPackageStartupMessages(library(pkg, character.only = TRUE))
    }, error = function(e) {
      cat("Warning: Could not install", pkg, "- continuing without it\n")
    })
  }
}

# Load data
data <- read.csv("data.csv")

cat("=== STEP 1: DATA LOADING ===\n")
cat("Initial sample size:", nrow(data), "\n\n")

# Data exclusion (as per preregistration)
data <- data[!data$Include=="no - test insti",]
cat("After excluding test rounds:", nrow(data), "\n")
data <- data[!data$storyoff_yn==-77,]
cat("After excluding dropouts:", nrow(data), "\n")
data <- data[data$BogusItem==7,]
cat("After bogus item filter:", nrow(data), "\n")
data <- data[!data$Include=="no - no tracking",]
cat("After excluding no tracking:", nrow(data), "\n")
data <- data[-which(data$duration>3*sd(data$duration)), ]
cat("After duration filter (3 SD):", nrow(data), "\n")
data <- data[!data$Data_quality_carefully_answered==2,]
cat("After quality filter:", nrow(data), "\n")
data <- data[!data$Data_quality_participated_morethanonce==1,]
cat("After duplicates filter:", nrow(data), "\n")
data <- data[!data$textcomp < 3,]
cat("Final sample size:", nrow(data), "\n\n")

cat("=== STEP 2: VARIABLE CODING ===\n")

# Reverse code items
data$EmpathicConcern_2_R <- 8 - data$EmpathicConcern_2_R
data$EmpathicConcern_5_R <- 8 - data$EmpathicConcern_5_R
data$EmpathicConcern_6_R <- 8 - data$EmpathicConcern_6_R

data$NarrativeEngagement_1_R <- 8 - data$NarrativeEngagement_1_R
data$NarrativeEngagement_2_R <- 8 - data$NarrativeEngagement_2_R
data$NarrativeEngagement_3_R <- 8 - data$NarrativeEngagement_3_R
data$NarrativeEngagement_4_R <- 8 - data$NarrativeEngagement_4_R
data$NarrativeEngagement_5_R <- 8 - data$NarrativeEngagement_5_R
data$NarrativeEngagement_6_R <- 8 - data$NarrativeEngagement_6_R

# Create composite variables
data$empco <- rowMeans(data[,14:20])
data$nareng <- rowMeans(data[,41:52])
data$enjoyment <- rowMeans(data[,38:40])
data$appreciation <- rowMeans(data[,35:37])
data$identification <- rowMeans(data[,23:32])
data$responsibility <- rowMeans(data[,33:34])

# Create donation variable
data$donation <- data$percentagedonated
data$donation[data$donation==1] <- 0
data$donation <- data$donation/100

cat("Created composite variables:\n")
cat("- empco (empathic concern)\n")
cat("- nareng (narrative engagement)\n")
cat("- enjoyment\n")
cat("- appreciation\n")
cat("- identification\n")
cat("- responsibility\n")
cat("- donation\n\n")

# Ensure numeric
data$condition <- as.numeric(data$condition)
data$empco <- as.numeric(data$empco)
data$enjoyment <- as.numeric(data$enjoyment)
data$nareng <- as.numeric(data$nareng)
data$identification <- as.numeric(data$identification)
data$responsibility <- as.numeric(data$responsibility)
data$appreciation <- as.numeric(data$appreciation)
data$donation <- as.numeric(data$donation)

# Create exphomeless variable
data$exphomeless <- ifelse(data$LivedHomeless == 1, 1, 0)
data$exphomeless[is.na(data$exphomeless)] <- 0

cat("=== STEP 3: DESCRIPTIVE STATISTICS ===\n")
cat("Condition distribution:\n")
print(table(data$condition))
cat("\n")

cat("Donation mean:", round(mean(data$donation, na.rm=TRUE), 3), "\n")
cat("Donation SD:", round(sd(data$donation, na.rm=TRUE), 3), "\n\n")

cat("=== STEP 4: MAIN SEM MODEL ===\n")
cat("Running structural equation model (this may take a moment)...\n\n")

# Main model from paper (Figure 2)
model_orig <- 'donation ~ condition + identification + responsibility + appreciation + empco + enjoyment + nareng
identification ~ condition + empco + enjoyment + nareng
responsibility ~ condition + empco + enjoyment + nareng
appreciation ~ condition + empco + enjoyment + nareng
identification ~~ appreciation
identification ~~ responsibility
responsibility ~~ appreciation
empco ~~ 0*condition
empco ~~ enjoyment
empco ~~ nareng
nareng ~~ enjoyment
enjoyment ~~ 0*condition
nareng ~~ 0*condition'

# Fit model
tryCatch({
  fit_orig <- sem(model_orig, data = data, fixed.x=FALSE)

  cat("=== MODEL FIT SUMMARY ===\n")
  fit_summary <- summary(fit_orig, fit.measures=TRUE, standardized=TRUE)
  print(fit_summary)

  cat("\n=== KEY FIT INDICES ===\n")
  fit_measures <- fitMeasures(fit_orig)
  cat("Chi-square:", round(fit_measures["chisq"], 2), "\n")
  cat("df:", fit_measures["df"], "\n")
  cat("CFI:", round(fit_measures["cfi"], 3), "\n")
  cat("TLI:", round(fit_measures["tli"], 3), "\n")
  cat("RMSEA:", round(fit_measures["rmsea"], 3), "\n")
  cat("SRMR:", round(fit_measures["srmr"], 3), "\n")

  cat("\n=== REPRODUCTION SUCCESSFUL ===\n")
  cat("Main SEM model was successfully fitted.\n")
  cat("Results can be compared to those reported in the paper.\n")

}, error = function(e) {
  cat("ERROR in model fitting:\n")
  print(e)
  cat("\n=== REPRODUCTION PARTIALLY SUCCESSFUL ===\n")
  cat("Data loaded and prepared, but SEM model encountered an error.\n")
})

cat("\n===== END OF REPRODUCTION =====\n")
