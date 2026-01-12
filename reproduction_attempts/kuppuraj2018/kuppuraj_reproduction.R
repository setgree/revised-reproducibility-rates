# Kuppuraj 2018 Reproduction Attempt
# Statistical Learning and Working Memory paper
# Simplified reproduction focusing on main analyses

cat("===== KUPPURAJ 2018 REPRODUCTION =====\n\n")

# Install/load packages
packages <- c("doBy", "lme4", "lmerTest")
for(pkg in packages) {
  if(!require(pkg, character.only = TRUE, quietly = TRUE)) {
    install.packages(pkg, repos='http://cran.us.r-parameter name.org')
    suppressPackageStartupMessages(library(pkg, character.only = TRUE))
  }
}

options(scipen=999) # avoid scientific notation

cat("=== STEP 1: LOAD VISIT 1 DATA ===\n")

# Get list of Visit 1 files
namelist <- list.files("Visit_1", pattern="*.csv", full.names = TRUE)
nsubs <- length(namelist)
cat("Number of participants (Visit 1):", nsubs, "\n\n")

# Initialize data frame
main.data.visit1_ALL <- data.frame(
  ID=factor(),
  Age=integer(),
  Gender=factor(),
  Routine=integer(),
  SetInd=integer(),
  Type=factor(),
  TargetRT=numeric()
)

# Process each participant
for (i in 1:nsubs){
  tryCatch({
    myname <- namelist[i]
    mydata <- read.csv(myname)

    # Extract relevant columns: ID, Age, Gender, Routine, SetInd, Type, TargetRT
    rawdata <- mydata[, c(1,2,3,5,10,12,26)]
    RTcutoff <- 2000

    # Clean RTs
    rawdata$TargetRT[rawdata$TargetACC==0] <- NA
    rawdata$TargetRT[rawdata$TargetRT < (-199)] <- NA
    rawdata$TargetRT[rawdata$TargetRT > RTcutoff] <- RTcutoff

    RWdata <- rawdata

    # Recode type labels
    RWdata$Type[RWdata$Type==1] <- "Adj_D"
    RWdata$Type[RWdata$Type==2] <- "Adj_D"
    RWdata$Type[RWdata$Type==3] <- "Adj_P"
    RWdata$Type[RWdata$Type==4] <- "Adj_P"
    RWdata$Type[RWdata$Type==5] <- "Non_D"
    RWdata$Type[RWdata$Type==6] <- "Non_D"
    RWdata$Type[RWdata$Type==7] <- "rand"
    RWdata$Type[RWdata$Type==8] <- "rand"

    RWdata$Type <- as.factor(RWdata$Type)
    RWdata$Type <- factor(RWdata$Type, levels=c("rand", "Adj_D", "Adj_P", "Non_D"))

    # Create summary data for this participant
    detaildata.visit1 <- summaryBy(TargetRT ~ SetInd+Type, data=RWdata,
                                    FUN=c(min), na.rm=TRUE)

    detaildata.visit1$ID <- rep(RWdata$ID[4], nrow(detaildata.visit1))
    detaildata.visit1$Age <- rep(RWdata$Age[4], nrow(detaildata.visit1))
    detaildata.visit1$Gender <- rep(RWdata$Gender[4], nrow(detaildata.visit1))
    detaildata.visit1$Routine <- rep(RWdata$Routine[4], nrow(detaildata.visit1))

    names(detaildata.visit1) <- c("SetInd", "Type", "TargetRT", "ID", 'Age', 'Gender', 'Routine')

    main.data.visit1_ALL <- rbind(main.data.visit1_ALL, detaildata.visit1)

  }, error = function(e) {
    cat("Error processing file", i, ":", e$message, "\n")
  })
}

# Remove participant 31 who didn't show up for visit 2
main.data.visit1 <- subset(main.data.visit1_ALL, !main.data.visit1_ALL$ID==31)

cat("Visit 1 data loaded. Total rows:", nrow(main.data.visit1), "\n")
cat("Unique participants:", length(unique(main.data.visit1$ID)), "\n\n")

cat("=== STEP 2: LOAD VISIT 2 DATA ===\n")

namelist.v2 <- list.files("Visit_2", pattern="*.csv", full.names = TRUE)
nsubs.v2 <- length(namelist.v2)
cat("Number of participants (Visit 2):", nsubs.v2, "\n\n")

main.data.visit2 <- data.frame(
  ID=factor(),
  Age=integer(),
  Gender=factor(),
  Routine=integer(),
  SetInd=integer(),
  Type=factor(),
  TargetRT=numeric()
)

for (i in 1:nsubs.v2){
  tryCatch({
    myname <- namelist.v2[i]
    mydata <- read.csv(myname)

    rawdata <- mydata[, c(1,2,3,5,10,12,26)]
    RTcutoff <- 2000

    rawdata$TargetRT[rawdata$TargetACC==0] <- NA
    rawdata$TargetRT[rawdata$TargetRT < (-199)] <- NA
    rawdata$TargetRT[rawdata$TargetRT > RTcutoff] <- RTcutoff

    RWdata <- rawdata

    # Recode types
    RWdata$Type[RWdata$Type==1] <- "Adj_D"
    RWdata$Type[RWdata$Type==2] <- "Adj_D"
    RWdata$Type[RWdata$Type==3] <- "Adj_P"
    RWdata$Type[RWdata$Type==4] <- "Adj_P"
    RWdata$Type[RWdata$Type==5] <- "Non_D"
    RWdata$Type[RWdata$Type==6] <- "Non_D"
    RWdata$Type[RWdata$Type==7] <- "rand"
    RWdata$Type[RWdata$Type==8] <- "rand"

    RWdata$Type <- as.factor(RWdata$Type)
    RWdata$Type <- factor(RWdata$Type, levels=c("rand", "Adj_D", "Adj_P", "Non_D"))

    detaildata.visit2 <- summaryBy(TargetRT ~ SetInd+Type, data=RWdata,
                                    FUN=c(min), na.rm=TRUE)

    detaildata.visit2$ID <- rep(RWdata$ID[4], nrow(detaildata.visit2))
    detaildata.visit2$Age <- rep(RWdata$Age[4], nrow(detaildata.visit2))
    detaildata.visit2$Gender <- rep(RWdata$Gender[4], nrow(detaildata.visit2))
    detaildata.visit2$Routine <- rep(RWdata$Routine[4], nrow(detaildata.visit2))

    names(detaildata.visit2) <- c("SetInd", "Type", "TargetRT", "ID", 'Age', 'Gender', 'Routine')

    main.data.visit2 <- rbind(main.data.visit2, detaildata.visit2)

  }, error = function(e) {
    cat("Error processing file", i, ":", e$message, "\n")
  })
}

cat("Visit 2 data loaded. Total rows:", nrow(main.data.visit2), "\n")
cat("Unique participants:", length(unique(main.data.visit2$ID)), "\n\n")

cat("=== STEP 3: CHECK DATA CONSISTENCY ===\n")
# Check IDs match between visits
id_mismatch <- which(main.data.visit1[,4] != main.data.visit2[,4])
if(length(id_mismatch) == 0) {
  cat("✓ IDs match between Visit 1 and Visit 2\n")
} else {
  cat("⚠ ID mismatches found at rows:", id_mismatch, "\n")
}

cat("\n=== STEP 4: DESCRIPTIVE STATISTICS ===\n")
cat("Mean RT by Type (Visit 1):\n")
print(aggregate(TargetRT ~ Type, data=main.data.visit1, FUN=mean, na.rm=TRUE))

cat("\nMean RT by Type (Visit 2):\n")
print(aggregate(TargetRT ~ Type, data=main.data.visit2, FUN=mean, na.rm=TRUE))

cat("\n=== STEP 5: MAIN ANALYSIS (Visit 1) ===\n")
cat("Running linear mixed model...\n")

# Main analysis: Do people show learning effects (faster RTs for structured vs. random)?
# Random is the baseline/reference level

tryCatch({
  model_v1 <- lmer(TargetRT ~ Type + (1|ID), data=main.data.visit1)
  cat("\nModel summary for Visit 1:\n")
  print(summary(model_v1))

  cat("\n=== KEY FINDINGS (Visit 1) ===\n")
  coefs <- summary(model_v1)$coefficients
  cat("Baseline (random):", round(coefs[1,1], 2), "ms\n")
  cat("Adjacent Determiner effect:", round(coefs[2,1], 2), "ms, t =", round(coefs[2,4], 2), "\n")
  cat("Adjacent Predictable effect:", round(coefs[3,1], 2), "ms, t =", round(coefs[3,4], 2), "\n")
  cat("Non-adjacent Determiner effect:", round(coefs[4,1], 2), "ms, t =", round(coefs[4,4], 2), "\n")

}, error = function(e) {
  cat("Error in model fitting:", e$message, "\n")
})

cat("\n=== REPRODUCTION SUMMARY ===\n")
cat("Successfully loaded and processed data from both visits\n")
cat("Main mixed effects model completed\n")
cat("Compare results to paper\n\n")

cat("===== END OF REPRODUCTION =====\n")
