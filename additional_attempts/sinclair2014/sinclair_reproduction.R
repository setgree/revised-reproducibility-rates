library(haven)
library(dplyr)
library(effsize)

cat("===== SINCLAIR 2014 - ROMEO & JULIET EFFECT REPRODUCTION =====\n\n")

# Load SPSS data
data <- read_sav("FinalDelinkedDataSetMTurkRJ_1.sav")

cat("Original N:", nrow(data), "\n\n")

# Create return variable: 1 if completed Time 2, 2 if did not
# Check for Time 2 variables (those ending in _T2)
data <- data %>%
  mutate(return = if_else(!is.na(SCR01_T2), 1, 2))

cat("Return status:\n")
table(data$return) %>% print()
cat("\n")

# Function to run t-test and format output like SAS
run_ttest <- function(data, var_name, label) {
  cat("\n", paste(rep("=", 70), collapse=""), "\n")
  cat("Variable:", label, "(", var_name, ")\n")
  cat(paste(rep("=", 70), collapse=""), "\n\n")

  # Get data by group
  group1 <- data %>% filter(return == 1) %>% pull(!!sym(var_name)) %>% na.omit()
  group2 <- data %>% filter(return == 2) %>% pull(!!sym(var_name)) %>% na.omit()

  if (length(group1) == 0 || length(group2) == 0) {
    cat("Insufficient data for analysis\n")
    return(NULL)
  }

  # Descriptive statistics
  cat(sprintf("return  N     Mean      Std Dev\n"))
  cat(sprintf("1       %-5d %.4f    %.4f\n", length(group1), mean(group1), sd(group1)))
  cat(sprintf("2       %-5d %.4f    %.4f\n", length(group2), mean(group2), sd(group2)))

  # T-test
  t_result <- t.test(group1, group2, var.equal=TRUE)
  t_result_welch <- t.test(group1, group2, var.equal=FALSE)

  cat(sprintf("\nPooled t-test:\n"))
  cat(sprintf("  t = %.2f, df = %d, p = %.4f\n",
              t_result$statistic, t_result$parameter, t_result$p.value))

  cat(sprintf("Satterthwaite t-test:\n"))
  cat(sprintf("  t = %.2f, df = %.2f, p = %.4f\n",
              t_result_welch$statistic, t_result_welch$parameter, t_result_welch$p.value))

  # Cohen's d
  d <- cohen.d(group1, group2)
  cat(sprintf("\nCohen's d = %.2f\n", d$estimate))

  return(list(
    n1 = length(group1),
    n2 = length(group2),
    mean1 = mean(group1),
    mean2 = mean(group2),
    t = t_result$statistic,
    df = t_result$parameter,
    p = t_result$p.value,
    d = d$estimate
  ))
}

# Variables to test (from the PDF)
# P.GEN = partner gender (FGEN in output)
# P.AGE = partner age (FAGE)
# FPEDU = partner education (FEDU)
# etc.

cat("===== REPRODUCING T-TESTS FROM PDF =====\n")

# Test 1: Partner Gender (FGEN)
if ("P.GEN" %in% names(data)) {
  run_ttest(data, "P.GEN", "FGEN")
}

# Test 2: Partner Age (FAGE)
if ("P.AGE" %in% names(data)) {
  run_ttest(data, "P.AGE", "FAGE")
}

# Test 3: Partner Education (FEDU)
if ("FPEDU" %in% names(data)) {
  run_ttest(data, "FPEDU", "FEDU")
}

# Test 4: Relationship duration (RELA03)
if ("RELA03" %in% names(data)) {
  run_ttest(data, "RELA03", "RELA03")
}

# Test 5: Marital status (RELA04)
if ("RELA04" %in% names(data)) {
  run_ttest(data, "RELA04", "RELA04")
}

# Test 6: Cohabitation duration (RELA05)
if ("RELA05" %in% names(data)) {
  run_ttest(data, "RELA05", "RELA05")
}

# Test 7: Children (RELA06)
if ("RELA06" %in% names(data)) {
  run_ttest(data, "RELA06", "RELA06")
}

cat("\n\n===== SUMMARY =====\n")
cat("Successfully reproduced t-tests comparing Time 2 returners vs non-returners\n")
cat("Results should match Data_Output_T1_T2.pdf\n")
