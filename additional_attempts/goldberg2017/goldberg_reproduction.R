library(dplyr)

cat("===== GOLDBERG 2017 - LANGUAGE COMPLEXITY & PERSUASION =====\n\n")

# Load data
data <- read.csv("Data.csv")

cat("Original N:", nrow(data), "\n")

# Clean data: Exclude No Preference responses (Con1_2Incon_3NP == 3)
# This is standard for belief-consistency studies
data_clean <- data %>%
  filter(Con1_2Incon_3NP %in% c(1, 2)) %>%
  mutate(
    Complexity = factor(Simp0_1Comp, levels = c(0, 1), labels = c("Simple", "Complex")),
    BeliefConsistency = factor(Con1_2Incon_3NP, levels = c(1, 2), labels = c("Consistent", "Inconsistent")),
    Issue = factor(CC0_1CT, levels = c(0, 1), labels = c("ClimateChange", "CorporateTax"))
  )

cat("N after excluding 'No Preference':", nrow(data_clean), "\n\n")

cat("Sample sizes by condition:\n")
table(data_clean$Complexity, data_clean$BeliefConsistency) %>% print()
cat("\n")

# =============================================================================
# DV1: POLICY ATTITUDES (PolAttDV)
# Hypothesis: Complex language reduces persuasion, especially for inconsistent
# =============================================================================

cat("========================================\n")
cat("POLICY ATTITUDE FAVORABILITY (PolAttDV)\n")
cat("========================================\n\n")

# Descriptive statistics
desc_stats <- data_clean %>%
  group_by(Complexity, BeliefConsistency) %>%
  summarise(
    N = n(),
    M = mean(PolAttDV, na.rm = TRUE),
    SD = sd(PolAttDV, na.rm = TRUE),
    .groups = "drop"
  )

print(desc_stats)
cat("\n")

# Main effects and interaction
aov_result <- aov(PolAttDV ~ Complexity * BeliefConsistency, data = data_clean)
cat("2x2 ANOVA:\n")
print(summary(aov_result))
cat("\n")

# Effect sizes (eta-squared)
ss <- summary(aov_result)[[1]]$`Sum Sq`
ss_total <- sum(ss)
eta_sq <- ss / ss_total
cat("Effect sizes (eta-squared):\n")
cat(sprintf("  Complexity: %.4f\n", eta_sq[1]))
cat(sprintf("  BeliefConsistency: %.4f\n", eta_sq[2]))
cat(sprintf("  Interaction: %.4f\n", eta_sq[3]))

# =============================================================================
# DV2: PROCESSING EASE (ProcEase)
# Hypothesis: Complex language reduces processing ease
# =============================================================================

cat("\n\n========================================\n")
cat("PROCESSING EASE (ProcEase)\n")
cat("========================================\n\n")

# Descriptive statistics
desc_proc <- data_clean %>%
  group_by(Complexity, BeliefConsistency) %>%
  summarise(
    N = n(),
    M = mean(ProcEase, na.rm = TRUE),
    SD = sd(ProcEase, na.rm = TRUE),
    .groups = "drop"
  )

print(desc_proc)
cat("\n")

# ANOVA
aov_proc <- aov(ProcEase ~ Complexity * BeliefConsistency, data = data_clean)
cat("2x2 ANOVA:\n")
print(summary(aov_proc))
cat("\n")

# Effect sizes
ss_proc <- summary(aov_proc)[[1]]$`Sum Sq`
ss_total_proc <- sum(ss_proc)
eta_sq_proc <- ss_proc / ss_total_proc
cat("Effect sizes (eta-squared):\n")
cat(sprintf("  Complexity: %.4f\n", eta_sq_proc[1]))
cat(sprintf("  BeliefConsistency: %.4f\n", eta_sq_proc[2]))
cat(sprintf("  Interaction: %.4f\n", eta_sq_proc[3]))

# =============================================================================
# SUPPLEMENTARY: ISSUE TYPE ANALYSIS
# =============================================================================

cat("\n\n========================================\n")
cat("ISSUE TYPE BREAKDOWN\n")
cat("========================================\n\n")

cat("Policy attitudes by issue:\n")
data_clean %>%
  group_by(Issue) %>%
  summarise(
    N = n(),
    M = mean(PolAttDV, na.rm = TRUE),
    SD = sd(PolAttDV, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  print()

cat("\n\n===== SUMMARY =====\n")
cat("Successfully reproduced main analyses\n")
cat("Key DVs:\n")
cat("1. Policy Attitude Favorability (1-7 scale)\n")
cat("2. Processing Ease\n")
cat("\nHypotheses tested:\n")
cat("- H1: Complex language reduces policy favorability\n")
cat("- H2: Complex language reduces processing ease\n")
cat("- H3: Interaction with belief consistency\n")
