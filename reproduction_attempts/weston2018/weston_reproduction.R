# Weston 2018 Reproduction Attempt
# Neuroticism & Vigilance paper
# Simplified reproduction focusing on main correlations

cat("===== WESTON 2018 REPRODUCTION =====\n\n")

# Install/load packages
packages <- c("psych", "GPArotation")
for(pkg in packages) {
  if(!require(pkg, character.only = TRUE, quietly = TRUE)) {
    install.packages(pkg, repos='http://cran.us.r-project.org')
    suppressPackageStartupMessages(library(pkg, character.only = TRUE))
  }
}

set.seed(7916)  # Same seed as original

cat("=== STEP 1: LOAD DATA ===\n")
vigdata <- read.csv("data.csv", stringsAsFactors = F)
cat("Initial N:", nrow(vigdata), "\n")

# Factor gc and filter to good completes
vigdata$gc <- factor(vigdata$gc, levels = c(1:4),
                     labels = c("Good Completes", "Screen Out", "Over Quota",
                                "Failed Quality Check"))

N_total <- nrow(vigdata)
N_final <- sum(vigdata$gc == "Good Completes")
cat("Good Completes:", N_final, "\n\n")

vigdata <- subset(vigdata, gc == "Good Completes")

# Clean column names
colnames(vigdata) <- gsub("SPI.135_1_", "", colnames(vigdata))
colnames(vigdata) <- gsub("SPI.135_2_", "", colnames(vigdata))
colnames(vigdata) <- gsub("SPI.135_3_", "", colnames(vigdata))

cat("=== STEP 2: CREATE NEUROTICISM SCALE ===\n")

# Neuroticism items
neur.items <- c("SPI_578", "SPI_4252", "SPI_979", "SPI_811", "SPI_1989", "SPI_1683",
                "SPI_4249", "SPI_793", "SPI_1585", "SPI_1505", "SPI_797",
                "SPI_176", "SPI_808", "SPI_1840")

# Check for missing items
missing_items <- neur.items[!neur.items %in% colnames(vigdata)]
if(length(missing_items) > 0) {
  cat("WARNING: Missing neuroticism items:", paste(missing_items, collapse=", "), "\n")
}

alpha.n <- tryCatch({
  psych::alpha(vigdata[, neur.items], check.keys = T)
}, error = function(e) {
  cat("Error in alpha calculation:", e$message, "\n")
  return(NULL)
})

if(!is.null(alpha.n)) {
  cat("Cronbach's alpha for neuroticism:", round(alpha.n$total[1, "raw_alpha"], 3), "\n")
  n.keys <- alpha.n$keys

  # Score neuroticism - handle the scoring more robustly
  tryCatch({
    scoreNeur <- scoreItems(keys = n.keys, items = vigdata[, neur.items])

    # Check the structure of scoreNeur
    if(!is.null(dim(scoreNeur$scores))) {
      cat("Score dimensions:", dim(scoreNeur$scores), "\n")
      cat("Score columns available:", colnames(scoreNeur$scores), "\n")
      vigdata$neuroticism <- scoreNeur$scores[, 1]
    } else {
      # If scores is a vector
      vigdata$neuroticism <- as.numeric(scoreNeur$scores)
    }

    cat("Neuroticism scale created successfully\n")
    cat("Mean:", round(mean(vigdata$neuroticism, na.rm=T), 3), "\n")
    cat("SD:", round(sd(vigdata$neuroticism, na.rm=T), 3), "\n\n")
  }, error = function(e) {
    cat("Error in scoreItems:", e$message, "\n")
    cat("Using simple mean of items instead...\n")
    # Fallback: just use mean of items
    vigdata$neuroticism <<- rowMeans(vigdata[, neur.items], na.rm=TRUE)
    cat("Mean:", round(mean(vigdata$neuroticism, na.rm=T), 3), "\n")
    cat("SD:", round(sd(vigdata$neuroticism, na.rm=T), 3), "\n\n")
  })
} else {
  cat("Could not create neuroticism scale\n")
}

cat("=== STEP 3: CREATE VIGILANCE SCALES ===\n")

# Create BVS4 composite
vigdata$BVS4 <- rowMeans(vigdata[, c("BVS4_BVS4_1", "BVS4_BVS4_2", "BVS4_BVS4_3",
                                      "BVS4_BVS4_4", "BVS4_BVS4_5", "BVS4_BVS4_6",
                                      "BVS4_BVS4_7", "BVS4_BVS4_8", "BVS4_BVS4_9",
                                      "BVS4_BVS4_10", "BVS4_BVS4_11", "BVS4_BVS4_12",
                                      "BVS4_BVS4_13", "BVS4_BVS4_14", "BVS4_BVS4_15")],
                         na.rm = T)

# Vigilance items for factor analysis
vig.items <- c("BAQ01", "BAQ02", "BAQ03", "BAQ04", "BAQ05", "BAQ06", "BAQ07",
               "BAQ08", "BAQ09", "BAQ10", "BAQ11", "BAQ12", "BAQ13", "BAQ14",
               "BAQ15", "BAQ16", "BAQ17", "BAQ18", "PBCS01", "PBCS02", "PBCS03",
               "PBCS04", "PBCS05", "SBA01", "SBA02", "SBA03", "SBA04", "BRQ01",
               "BRQ02", "BRQ03", "BRQ04", "BRQ05", "BRQ06", "BRQ07", "BVS1",
               "BVS2", "BVS3", "BVS4")

# Run factor analysis with 2 factors (as per original)
cat("Running factor analysis with 2 factors...\n")
fa.final <- fa(vigdata[, vig.items], nfactors = 2, rotate = "oblimin")

# Extract factor scores
vigdata$sensation <- fa.final$scores[, 1]
vigdata$change <- fa.final$scores[, 2]

cat("Factor analysis complete\n")
cat("Sensation mean:", round(mean(vigdata$sensation, na.rm=T), 3), "\n")
cat("Change mean:", round(mean(vigdata$change, na.rm=T), 3), "\n\n")

cat("=== STEP 4: KEY CORRELATIONS ===\n")

if(!is.null(vigdata$neuroticism)) {
  # Main correlations
  cor_neur_sensation <- cor(vigdata$neuroticism, vigdata$sensation, use="complete.obs")
  cor_neur_change <- cor(vigdata$neuroticism, vigdata$change, use="complete.obs")

  cat("Correlation: Neuroticism ~ Sensation:", round(cor_neur_sensation, 3), "\n")
  cat("Correlation: Neuroticism ~ Change:", round(cor_neur_change, 3), "\n\n")

  # Get confidence intervals
  test_sens <- cor.test(vigdata$neuroticism, vigdata$sensation)
  test_change <- cor.test(vigdata$neuroticism, vigdata$change)

  cat("Neuroticism ~ Sensation:\n")
  cat("  r =", round(test_sens$estimate, 3), "\n")
  cat("  95% CI: [", round(test_sens$conf.int[1], 3), ",", round(test_sens$conf.int[2], 3), "]\n")
  cat("  p =", format.pval(test_sens$p.value, digits=3), "\n\n")

  cat("Neuroticism ~ Change:\n")
  cat("  r =", round(test_change$estimate, 3), "\n")
  cat("  95% CI: [", round(test_change$conf.int[1], 3), ",", round(test_change$conf.int[2], 3), "]\n")
  cat("  p =", format.pval(test_change$p.value, digits=3), "\n\n")

  # Partial correlations (controlling for age and gender)
  cat("=== PARTIAL CORRELATIONS (controlling for age and gender) ===\n")

  # Gender coding (1=male, others=non-male, make male=0 as reference)
  vigdata$Gender_binary <- ifelse(vigdata$Gender == 1, 0, 1)

  # Standardize age
  vigdata$z_age <- as.numeric(scale(vigdata$Age))

  # Create data subset with complete cases
  analysis_data <- vigdata[complete.cases(vigdata[, c("neuroticism", "sensation", "change", "z_age", "Gender_binary")]), ]

  cat("N for partial correlations:", nrow(analysis_data), "\n")

  # Partial correlation: neuroticism ~ sensation | age, gender
  pc_sens <- partial.r(data = analysis_data[, c("neuroticism", "sensation", "z_age", "Gender_binary")],
                        x = c(1,2), y = c(3,4))

  cat("Partial r (Neur ~ Sensation | age, gender):", round(pc_sens[1,2], 3), "\n")

  # Partial correlation: neuroticism ~ change | age, gender
  pc_change <- partial.r(data = analysis_data[, c("neuroticism", "change", "z_age", "Gender_binary")],
                          x = c(1,2), y = c(3,4))

  cat("Partial r (Neur ~ Change | age, gender):", round(pc_change[1,2], 3), "\n\n")
}

cat("=== REPRODUCTION SUMMARY ===\n")
cat("Successfully loaded data and created scales\n")
cat("Main correlations computed\n")
cat("Compare these values to those reported in the paper\n\n")

cat("===== END OF REPRODUCTION =====\n")
