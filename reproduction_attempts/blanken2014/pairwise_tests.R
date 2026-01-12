library(haven)
library(dplyr)

data <- read_sav('Study3_mturk_clean.sav') %>%
  filter(!is.na(donation_amount), !is.na(Condition))

cat('===== PAIRWISE COMPARISONS =====\n\n')

# Positive vs Negative
pos_neg <- data %>% filter(Condition %in% c(1,2))
test1 <- t.test(donation_amount ~ Condition, data=pos_neg)
cat('Positive vs Negative words:\n')
cat('  Positive: M=', round(mean(pos_neg$donation_amount[pos_neg$Condition==1], na.rm=TRUE), 2), '\n', sep='')
cat('  Negative: M=', round(mean(pos_neg$donation_amount[pos_neg$Condition==2], na.rm=TRUE), 2), '\n', sep='')
cat('  t(', test1$parameter, ') = ', round(test1$statistic, 3), ', p = ', format.pval(test1$p.value, digits=3), '\n\n', sep='')

# Positive vs Neutral
pos_neut <- data %>% filter(Condition %in% c(1,3))
test2 <- t.test(donation_amount ~ Condition, data=pos_neut)
cat('Positive vs Neutral words:\n')
cat('  Positive: M=', round(mean(pos_neut$donation_amount[pos_neut$Condition==1], na.rm=TRUE), 2), '\n', sep='')
cat('  Neutral: M=', round(mean(pos_neut$donation_amount[pos_neut$Condition==3], na.rm=TRUE), 2), '\n', sep='')
cat('  t(', test2$parameter, ') = ', round(test2$statistic, 3), ', p = ', format.pval(test2$p.value, digits=3), '\n\n', sep='')

# Negative vs Neutral
neg_neut <- data %>% filter(Condition %in% c(2,3))
test3 <- t.test(donation_amount ~ Condition, data=neg_neut)
cat('Negative vs Neutral words:\n')
cat('  Negative: M=', round(mean(neg_neut$donation_amount[neg_neut$Condition==2], na.rm=TRUE), 2), '\n', sep='')
cat('  Neutral: M=', round(mean(neg_neut$donation_amount[neg_neut$Condition==3], na.rm=TRUE), 2), '\n', sep='')
cat('  t(', test3$parameter, ') = ', round(test3$statistic, 3), ', p = ', format.pval(test3$p.value, digits=3), '\n\n', sep='')

cat('Overall ANOVA:\n')
aov_result <- aov(donation_amount ~ as.factor(Condition), data=data)
print(summary(aov_result))
