# Blanken 2014 - Moral Licensing Replication (Study 3)
library(haven)
library(dplyr)

data <- read_sav("Study3_mturk_clean.sav")

cat("===== BLANKEN 2014 REPRODUCTION =====\n")
cat("Moral licensing: Does recalling positive traits reduce donations?\n\n")

# Basic info
cat("N =", nrow(data), "participants\n")
cat("Condition:", table(data$Condition), "\n\n")

# Filter to complete cases for main analysis
main_data <- data %>%
  filter(!is.na(donation_amount), !is.na(Condition))

cat("After filtering: N =", nrow(main_data), "\n")
cat("Condition distribution:\n")
print(table(main_data$Condition))
cat("\n")

# Main analysis: Does condition affect donation amount?
cat("===== MAIN ANALYSIS: Donation Amount by Condition =====\n")

# Descriptives by condition
descriptives <- main_data %>%
  group_by(Condition) %>%
  summarise(
    N = n(),
    Mean = mean(donation_amount, na.rm=TRUE),
    SD = sd(donation_amount, na.rm=TRUE),
    Median = median(donation_amount, na.rm=TRUE)
  )

print(descriptives)
cat("\n")

# T-test comparing conditions
if(length(unique(main_data$Condition)) == 2) {
  test_result <- t.test(donation_amount ~ Condition, data=main_data)

  cat("Independent samples t-test:\n")
  cat("  t(", test_result$parameter, ") = ", round(test_result$statistic, 3),
      ", p = ", format.pval(test_result$p.value, digits=3), "\n", sep="")
  cat("  95% CI: [", round(test_result$conf.int[1], 2), ", ",
      round(test_result$conf.int[2], 2), "]\n", sep="")

  # Effect size (Cohen's d)
  pooled_sd <- sqrt(((sum(!is.na(main_data$donation_amount[main_data$Condition==unique(main_data$Condition)[1]])) - 1) *
                       var(main_data$donation_amount[main_data$Condition==unique(main_data$Condition)[1]], na.rm=TRUE) +
                      (sum(!is.na(main_data$donation_amount[main_data$Condition==unique(main_data$Condition)[2]])) - 1) *
                       var(main_data$donation_amount[main_data$Condition==unique(main_data$Condition)[2]], na.rm=TRUE)) /
                     (nrow(main_data) - 2))

  cohens_d <- diff(rev(by(main_data$donation_amount, main_data$Condition, mean, na.rm=TRUE))) / pooled_sd
  cat("  Cohen's d = ", round(cohens_d, 3), "\n\n", sep="")
}

# Check for self-monitoring moderation if variable exists
if("ZSelfmonitoring_score" %in% names(main_data)) {
  cat("===== MODERATION: Self-Monitoring =====\n")

  # Create high/low self-monitoring groups
  main_data$SM_high <- ifelse(main_data$ZSelfmonitoring_score > 0, 1, 0)

  cat("Self-monitoring descriptives:\n")
  sm_desc <- main_data %>%
    group_by(Condition, SM_high) %>%
    summarise(
      N = n(),
      Mean_donation = mean(donation_amount, na.rm=TRUE),
      SD_donation = sd(donation_amount, na.rm=TRUE)
    )
  print(sm_desc)

  # Regression with interaction
  if(require(stats, quietly=TRUE)) {
    model <- lm(donation_amount ~ Condition * ZSelfmonitoring_score, data=main_data)
    cat("\n\nRegression: Donation ~ Condition * Self-Monitoring\n")
    print(summary(model))
  }
}

# Check cooperative behavior if exists
if("cooperative_behavior" %in% names(main_data)) {
  cat("\n\n===== ADDITIONAL DV: Cooperative Behavior =====\n")

  coop_desc <- main_data %>%
    group_by(Condition) %>%
    summarise(
      N = sum(!is.na(cooperative_behavior)),
      Mean = mean(cooperative_behavior, na.rm=TRUE),
      SD = sd(cooperative_behavior, na.rm=TRUE)
    )
  print(coop_desc)

  if(length(unique(main_data$Condition)) == 2) {
    coop_test <- t.test(cooperative_behavior ~ Condition, data=main_data)
    cat("\nt-test: t(", coop_test$parameter, ") = ", round(coop_test$statistic, 3),
        ", p = ", format.pval(coop_test$p.value, digits=3), "\n", sep="")
  }
}

cat("\n===== SUMMARY =====\n")
cat("Main hypothesis: Positive self-affirmation leads to LOWER donations (moral licensing)\n")
cat("Successfully analyzed donation amounts across experimental conditions\n")
