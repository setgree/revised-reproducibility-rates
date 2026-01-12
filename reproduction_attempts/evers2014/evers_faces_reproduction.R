# Evers 2014 - Reproduction Attempt
# Experiment 1: Tversky Diagnosticity Principle - Faces Study

library(readxl)
library(dplyr)

cat("===== EVERS 2014 - FACES STUDY REPRODUCTION =====\n")
cat("Testing Tversky's diagnosticity principle\n\n")

# Load raw data from classroom replication
data <- read_excel("Classroom_Data_Faces_2012_and_2013.xlsx", sheet="raw data")

cat("Total observations:", nrow(data), "\n")
cat("Years:", unique(data$`Year (2012/2013)`), "\n")
cat("Conditions:", unique(data$Condition), "\n")
cat("Distractors:", unique(data$Distractor), "\n\n")

# Clean up column names
names(data) <- c("Time", "Birthday", "Condition", "Distractor", "Year", "Question", "Choice")

# The study design (from Tversky 1977):
# Target face: a (neutral)
# Always shown: b (frowning), c (smiling)
# Distractor varies:
#   Condition 1: p (smiling) - so we have 2 smiling faces
#   Condition 2: q (frowning) - so we have 2 frowning faces

# Hypothes is:
# When distractor is smiling (cond 1), "smiling vs non-smiling" is diagnostic
#   -> participants should pick frowning face (b) as similar to neutral (a)
# When distractor is frowning (cond 2), "frowning vs non-frowning" is diagnostic
#   -> participants should pick smiling face (c) as similar to neutral (a)

cat("===== DATA CLEANING =====\n")

# Check Choice values
cat("Unique choices:", paste(unique(data$Choice), collapse=", "), "\n")

# Map choices to face types based on the paradigm
# Need to figure out which choice corresponds to b (frowning) vs c (smiling) vs distractor

# From the preregistration and Tversky's method:
# - Target is always neutral (a) on top
# - Three options below: b (frowning), c (smiling), and p/q (distractor)

# Let's examine the choices more carefully
choice_table <- table(data$Choice, data$Distractor)
cat("\nChoice by Distractor:\n")
print(choice_table)

# Based on Tversky's Figure 1:
# Set 1 (Condition 1): Distractor = p (smiling)
#   - b (frowning) should be chosen more (44%)
#   - p (smiling distractor) less (14%)
#   - c (smiling) middle (42%)
# Set 2 (Condition 2): Distractor = q (frowning)
#   - b (frowning) should be chosen less (12%)
#   - q (frowning distractor) less (8%)
#   - c (smiling) should be chosen more (80%)

# Let's map the actual choice labels to faces
# The choices appear to be the actual labels or positions

# Create analysis following Tversky's method:
# Exclude distractor choices, compare b vs c between conditions

cat("\n===== DESCRIPTIVE STATISTICS =====\n")

# Count choices by condition
condition_summary <- data %>%
  group_by(Condition, Distractor, Choice) %>%
  summarise(N = n(), .groups="drop") %>%
  group_by(Condition, Distractor) %>%
  mutate(Proportion = N / sum(N))

print(condition_summary)

# Based on the data structure, let's identify which choice is which face
# From the percentages sheet, I can see:
# - When distractor is smiling (cond 1): more pick b (frowning)
# - When distractor is frowning (cond 2): more pick c (smiling)

# Let's code this more explicitly
# Assign face types based on the experimental design
data <- data %>%
  mutate(
    FaceType = case_when(
      # In condition 1 (distractor smiling), if choice is "b" or frowning-like
      Condition == 1 & grepl("[Bb]|[Ff]rown", Choice) ~ "Frowning",
      Condition == 1 & grepl("[Cc]|[Ss]mil", Choice) ~ "Smiling_Target",
      Condition == 1 & grepl("[Pp]|distract", Choice, ignore.case=TRUE) ~ "Distractor",
      # In condition 2 (distractor frowning)
      Condition == 2 & grepl("[Bb]|[Ff]rown", Choice) ~ "Frowning_Target",
      Condition == 2 & grepl("[Cc]|[Ss]mil", Choice) ~ "Smiling",
      Condition == 2 & grepl("[Qq]|distract", Choice, ignore.case=TRUE) ~ "Distractor",
      TRUE ~ Choice
    )
  )

# Actually, let's use the raw Choice values and map them properly
# Looking at the Choice column values
unique_choices_by_cond <- data %>%
  group_by(Condition, Choice) %>%
  summarise(N = n(), .groups="drop")

cat("\n\nChoices by Condition:\n")
print(unique_choices_by_cond)

# Let me try a simpler approach: just analyze the raw proportions
# Following Tversky's exact method from the preregistration

cat("\n\n===== MAIN ANALYSIS: TVERSKY'S METHOD =====\n")

# Count choices excluding distractor
# From preregistration: "choices for the distracter options p[q] will be excluded"

# Identify non-distractor choices for each condition
# The study should have 3 choices: b (frowning), c (smiling), distractor (p or q)

# Let's work with what we have - calculate proportions for each choice type
analysis_data <- data %>%
  group_by(Condition, Choice) %>%
  summarise(Count = n(), .groups="drop") %>%
  group_by(Condition) %>%
  mutate(Total = sum(Count),
         Proportion = Count / Total)

cat("\nChoice proportions by condition:\n")
print(analysis_data)

# Chi-square test (as specified in preregistration)
# Create contingency table for the two main face types (b and c)

# I need to properly identify which choices are b vs c
# Let me look at the actual unique values
cat("\n\nUnique choice values:\n")
print(unique(data$Choice))

# Based on typical coding, let's assume:
# "b" or "frowning" = frowning face
# "c" or "smiling" = smiling face
# Other = distractor

# Create simplified categories
data_clean <- data %>%
  filter(!is.na(Choice)) %>%
  mutate(
    FaceChoice = case_when(
      grepl("b", Choice, ignore.case=TRUE) | grepl("frown", Choice, ignore.case=TRUE) ~ "Frowning",
      grepl("c", Choice, ignore.case=TRUE) | grepl("smil", Choice, ignore.case=TRUE) ~ "Smiling",
      TRUE ~ "Distractor"
    )
  )

# Exclude distractor choices
data_main <- data_clean %>%
  filter(FaceChoice != "Distractor")

cat("\n\nAfter excluding distractors:\n")
cat("N =", nrow(data_main), "\n\n")

# Create contingency table
cont_table <- table(data_main$Condition, data_main$FaceChoice)
cat("Contingency table:\n")
print(cont_table)

cat("\nProportions:\n")
print(prop.table(cont_table, margin=1))

# Chi-square test
if (nrow(data_main) > 0 && length(unique(data_main$FaceChoice)) > 1) {
  chisq_result <- chisq.test(cont_table)
  cat("\n\n===== CHI-SQUARE TEST =====\n")
  print(chisq_result)

  # Effect size (Cramer's V)
  n <- sum(cont_table)
  chi_sq <- chisq_result$statistic
  cramers_v <- sqrt(chi_sq / n)
  cat("\nCramer's V =", round(cramers_v, 3), "\n")

  # Expected effect based on Tversky's results
  cat("\n===== COMPARISON TO TVERSKY 1977 =====\n")
  cat("Tversky's original results:\n")
  cat("  Condition 1 (distractor smiling): b=44%, c=42%\n")
  cat("  Condition 2 (distractor frowning): b=12%, c=80%\n\n")

  cat("Our replication results:\n")
  prop_table <- prop.table(cont_table, margin=1)
  for (i in 1:nrow(prop_table)) {
    cat("  Condition", rownames(prop_table)[i], ":")
    for (j in 1:ncol(prop_table)) {
      cat(" ", colnames(prop_table)[j], "=", round(prop_table[i,j]*100, 1), "%,", sep="")
    }
    cat("\n")
  }
}

cat("\n===== SUMMARY =====\n")
cat("This is a partial reproduction attempt of Evers 2014 (classroom data only)\n")
cat("The original study aimed to replicate Tversky's diagnosticity principle\n")
cat("Data from", min(data$Year, na.rm=TRUE), "and", max(data$Year, na.rm=TRUE), "classroom replications\n")
cat("Total N =", nrow(data), "\n")
cat("\nNote: Without the full MTurk data and complete trial information,\n")
cat("this is only a partial analysis of the available classroom data.\n")
