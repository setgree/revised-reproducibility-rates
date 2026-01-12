library(readxl)
library(dplyr)

# Load data
data <- read_excel("Classroom_Data_Faces_2012_and_2013.xlsx", sheet="raw data")
names(data) <- c("Time", "Birthday", "Condition", "Distractor", "Year", "Question", "Choice")

cat("===== CHECKING DATA CODING =====\n\n")

# Look at the relationship between Condition and Distractor
cat("Condition vs Distractor:\n")
table(data$Condition, data$Distractor) %>% print()

cat("\n\nChoice distribution by Condition and Distractor:\n")
data %>%
  group_by(Condition, Distractor, Choice) %>%
  summarise(N = n(), .groups="drop") %>%
  arrange(Condition, Distractor, Choice) %>%
  print()

# Check if my face type coding is correct
cat("\n\n===== CHECKING FACE LABELS =====\n")
cat("Unique choices:\n")
print(unique(data$Choice))

cat("\n\nFrom Tversky's design:\n")
cat("- Target: a (neutral) - always shown at top\n")
cat("- Always available: b (frowning), c (smiling)\n") 
cat("- Distractor: p (smiling in condition 1) or q (frowning in condition 2)\n\n")

cat("So:\n")
cat("- 'b' should be FROWNING face\n")
cat("- 'c' should be SMILING face\n")
cat("- 'p' should be distractor (smiling) in condition 1\n")
cat("- 'q' should be distractor (frowning) in condition 2\n\n")

# My current coding
cat("My coding (from the script):\n")
cat("- 'b' -> Frowning\n")
cat("- 'c' -> Smiling\n")
cat("- 'p' -> Distractor (condition 1)\n\n")

cat("Actual choices in the data:\n")
print(table(data$Choice))
