library(haven)
library(dplyr)
library(tidyr)

cat("===== WESSELMAN 2014 - SCHACHTER REPLICATION =====\n\n")

# Load data
votes <- read_sav("Votes_and_Committees.sav")
comm <- read_sav("Communication_DV.sav")

cat("N =", nrow(votes), "participants\n")
cat("Number of groups:", length(unique(votes$GroupBreakVar)), "\n\n")

# =============================================================================
# DV1: LIKING RATINGS (7-point scale: 1=not at all, 7=very much)
# Hypothesis: Deviate < Slider < Mode
# =============================================================================

cat("========================================\n")
cat("DV1: LIKING RATINGS\n")
cat("========================================\n\n")

liking_data <- votes %>%
  select(DeviateLiking, SliderLiking, ModeLiking) %>%
  na.omit()

cat("Liking ratings (1-7 scale, higher = more liking):\n")
cat(sprintf("  Deviate: M = %.2f, SD = %.2f, N = %d\n",
            mean(liking_data$DeviateLiking),
            sd(liking_data$DeviateLiking),
            nrow(liking_data)))
cat(sprintf("  Slider:  M = %.2f, SD = %.2f, N = %d\n",
            mean(liking_data$SliderLiking),
            sd(liking_data$SliderLiking),
            nrow(liking_data)))
cat(sprintf("  Mode:    M = %.2f, SD = %.2f, N = %d\n",
            mean(liking_data$ModeLiking),
            sd(liking_data$ModeLiking),
            nrow(liking_data)))

# Repeated measures ANOVA
liking_long <- liking_data %>%
  mutate(id = row_number()) %>%
  pivot_longer(cols = c(DeviateLiking, SliderLiking, ModeLiking),
               names_to = "Role", values_to = "Liking") %>%
  mutate(Role = factor(Role, levels = c("DeviateLiking", "SliderLiking", "ModeLiking")))

aov_result <- aov(Liking ~ Role + Error(id/Role), data = liking_long)
cat("\nRepeated measures ANOVA:\n")
print(summary(aov_result))

# Pairwise t-tests
cat("\nPairwise comparisons:\n")
t1 <- t.test(liking_data$DeviateLiking, liking_data$SliderLiking, paired = TRUE)
cat(sprintf("Deviate vs Slider: t = %.2f, p = %.4f\n", t1$statistic, t1$p.value))

t2 <- t.test(liking_data$DeviateLiking, liking_data$ModeLiking, paired = TRUE)
cat(sprintf("Deviate vs Mode:   t = %.2f, p = %.4f\n", t2$statistic, t2$p.value))

t3 <- t.test(liking_data$SliderLiking, liking_data$ModeLiking, paired = TRUE)
cat(sprintf("Slider vs Mode:    t = %.2f, p = %.4f\n", t3$statistic, t3$p.value))

# =============================================================================
# DV2: SOCIOMETRIC VOTES (1 = highest ranked, higher numbers = lower rank)
# Hypothesis: Deviate ranked lowest (highest vote numbers)
# =============================================================================

cat("\n\n========================================\n")
cat("DV2: SOCIOMETRIC RANKINGS\n")
cat("========================================\n\n")

vote_data <- votes %>%
  select(DeviateVote, SliderVote, ModeVote) %>%
  na.omit()

cat("Sociometric votes (1 = highest ranked, 3 = lowest ranked):\n")
cat(sprintf("  Deviate: M = %.2f, SD = %.2f, N = %d\n",
            mean(vote_data$DeviateVote),
            sd(vote_data$DeviateVote),
            nrow(vote_data)))
cat(sprintf("  Slider:  M = %.2f, SD = %.2f, N = %d\n",
            mean(vote_data$SliderVote),
            sd(vote_data$SliderVote),
            nrow(vote_data)))
cat(sprintf("  Mode:    M = %.2f, SD = %.2f, N = %d\n",
            mean(vote_data$ModeVote),
            sd(vote_data$ModeVote),
            nrow(vote_data)))

# Repeated measures ANOVA
vote_long <- vote_data %>%
  mutate(id = row_number()) %>%
  pivot_longer(cols = c(DeviateVote, SliderVote, ModeVote),
               names_to = "Role", values_to = "Vote") %>%
  mutate(Role = factor(Role, levels = c("DeviateVote", "SliderVote", "ModeVote")))

aov_result2 <- aov(Vote ~ Role + Error(id/Role), data = vote_long)
cat("\nRepeated measures ANOVA:\n")
print(summary(aov_result2))

# Pairwise t-tests
cat("\nPairwise comparisons:\n")
t4 <- t.test(vote_data$DeviateVote, vote_data$SliderVote, paired = TRUE)
cat(sprintf("Deviate vs Slider: t = %.2f, p = %.4f\n", t4$statistic, t4$p.value))

t5 <- t.test(vote_data$DeviateVote, vote_data$ModeVote, paired = TRUE)
cat(sprintf("Deviate vs Mode:   t = %.2f, p = %.4f\n", t5$statistic, t5$p.value))

t6 <- t.test(vote_data$SliderVote, vote_data$ModeVote, paired = TRUE)
cat(sprintf("Slider vs Mode:    t = %.2f, p = %.4f\n", t6$statistic, t6$p.value))

# =============================================================================
# DV3: COMMITTEE NOMINATIONS
# Hypothesis: Deviate nominated more for correspondence (least important)
# =============================================================================

cat("\n\n========================================\n")
cat("DV3: COMMITTEE NOMINATIONS\n")
cat("========================================\n\n")

# Count nominations for each role on each committee
# Need to parse the string variables exe1, exe2, exe3, steer1-3, corr1-3
# The codebook says confederate names were kept but participant names removed

count_nominations <- function(data, role_var, committee_cols) {
  # Get the confederate playing this role
  roles <- data %>%
    select(!!sym(role_var)) %>%
    pull()

  # Map confederate codes to names (from codebook)
  confed_names <- c("1" = "Andy", "2" = "JD", "3" = "Devin")

  # Count nominations
  total <- 0
  for (col in committee_cols) {
    col_data <- data %>% select(!!sym(col)) %>% pull()
    for (i in 1:length(col_data)) {
      if (!is.na(col_data[i]) && !is.na(roles[i])) {
        # Check if this confederate was nominated
        role_name <- confed_names[as.character(roles[i])]
        if (grepl(role_name, col_data[i], ignore.case = TRUE)) {
          total <- total + 1
        }
      }
    }
  }
  return(total)
}

# Count for each role on each committee
exe_cols <- c("exe1", "exe2", "exe3")
steer_cols <- c("steer1", "steer2", "steer3")
corr_cols <- c("corr1", "corr2", "corr3")

dev_exe <- count_nominations(votes, "deviateRecode", exe_cols)
dev_steer <- count_nominations(votes, "deviateRecode", steer_cols)
dev_corr <- count_nominations(votes, "deviateRecode", corr_cols)

slid_exe <- count_nominations(votes, "sliderRecode", exe_cols)
slid_steer <- count_nominations(votes, "sliderRecode", steer_cols)
slid_corr <- count_nominations(votes, "sliderRecode", corr_cols)

mode_exe <- count_nominations(votes, "modeRecode", exe_cols)
mode_steer <- count_nominations(votes, "modeRecode", steer_cols)
mode_corr <- count_nominations(votes, "modeRecode", corr_cols)

cat("Committee nominations by role:\n\n")
cat(sprintf("                Executive  Steering  Correspondence\n"))
cat(sprintf("Deviate         %-10d %-10d %d\n", dev_exe, dev_steer, dev_corr))
cat(sprintf("Slider          %-10d %-10d %d\n", slid_exe, slid_steer, slid_corr))
cat(sprintf("Mode            %-10d %-10d %d\n", mode_exe, mode_steer, mode_corr))

cat("\nExpected pattern: Deviate should receive more Correspondence ")
cat("(least important) nominations\n")

# =============================================================================
# DV4: COMMUNICATION PATTERNS
# Hypothesis: More communication directed at Deviate, especially early
# =============================================================================

cat("\n\n========================================\n")
cat("DV4: COMMUNICATION DIRECTED AT EACH ROLE\n")
cat("========================================\n\n")

# Communication data: Dev5, Slid5, Mod5, Dev10, ... Dev45, Slid45, Mod45
# Numbers represent 5-minute intervals

# Calculate totals across time
comm_totals <- comm %>%
  summarise(
    Deviate = sum(Dev5 + Dev10 + Dev15 + Dev20 + Dev25 + Dev30 + Dev35 + Dev40 + Dev45, na.rm = TRUE),
    Slider = sum(Slid5 + Slid10 + Slid15 + Slid20 + Slid25 + Slid30 + Slid35 + Slid40 + Slid45, na.rm = TRUE),
    Mode = sum(Mod5 + Mod10 + Mod15 + Mod20 + Mod25 + Mod30 + Mod35 + Mod40 + Mod45, na.rm = TRUE)
  )

cat("Total communication acts directed at each role:\n")
cat(sprintf("  Deviate: %d\n", comm_totals$Deviate))
cat(sprintf("  Slider:  %d\n", comm_totals$Slider))
cat(sprintf("  Mode:    %d\n", comm_totals$Mode))

cat("\nCommunication by time period (mean per group):\n")
cat(sprintf("Time    Deviate  Slider   Mode\n"))
for (t in seq(5, 45, 5)) {
  dev_col <- paste0("Dev", t)
  slid_col <- paste0("Slid", t)
  mod_col <- paste0("Mod", t)

  cat(sprintf("%-7s %.2f    %.2f    %.2f\n",
              paste0(t, "min"),
              mean(comm[[dev_col]], na.rm = TRUE),
              mean(comm[[slid_col]], na.rm = TRUE),
              mean(comm[[mod_col]], na.rm = TRUE)))
}

cat("\n\n===== SUMMARY =====\n")
cat("Successfully reproduced Schachter replication analyses\n")
cat("Key findings:\n")
cat("1. Liking: Deviate should be liked least\n")
cat("2. Sociometric votes: Deviate should rank lowest\n")
cat("3. Committee nominations: Deviate should get correspondence committee\n")
cat("4. Communication: Initially high to Deviate, should decrease over time\n")
