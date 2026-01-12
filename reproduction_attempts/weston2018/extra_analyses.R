#----packages------

library(knitr)
library(psych)
library(GPArotation)
library(boot)
library(pwr)
library(tidyverse)
library(lavaan)
library(stargazer)

#---- options ----

options(width = 120)

set.seed(7916)

##----num-----

num <- function(x, digits = 2, int = F) {
  if (int == TRUE) 
    digits = 0
  if (int == FALSE) 
    y <- prettyNum(round(x, digits))
  if (int == TRUE) 
    y <- prettyNum(round(x), big.mark = ",")
  if (grepl("\\.", y)) 
    z <- strsplit(y, "\\.")
  if (grepl("\\.", y) & int == F) 
    y <- paste(y, paste(rep(0, digits - nchar(z[[1]][2])), collapse = ""), sep = "") else if (!grepl("\\.", y) & int == F & digits != 0) 
      y <- paste(y, ".", paste(rep(0, digits), collapse = ""), sep = "")
    return(y)
}

#----data------

load("cleaned.Rdata")

#----score-conscientiousness----
con.items = c("SPI_369", "SPI_1867", "SPI_1744", "SPI_1976", "SPI_904", "SPI_1444", "SPI_1452", 
              "SPI_1201", "SPI_1290", "SPI_1254", "SPI_1483", "SPI_530", "SPI_1694", "SPI_1915")

(alpha.c <- psych::alpha(vigdata[, con.items], check.keys = T))
c.keys <- alpha.c$keys

scoreCon = scoreItems(keys = c.keys, items = vigdata[, con.items])
vigdata$con = scoreCon$scores[, "A1"]

vigdata$z_con = as.numeric(scale(vigdata$con))

#---score-lower----
# score anxiety
anxiety.items = c("SPI_808", "SPI_1505", "SPI_1989", "SPI_4249", "SPI_4252")
(alpha.ax <- psych::alpha(vigdata[, anxiety.items], check.keys = T))
ax.keys <- alpha.ax$keys
scoreAnxiety = scoreItems(keys = ax.keys, items = vigdata[, anxiety.items])
vigdata$anxiety = scoreAnxiety$scores[, "A1"]

# score emotional stability
emotionalstability.items = c("SPI_174", "SPI_797", "SPI_1840", "SPI_793", "SPI_979")
(alpha.es <- psych::alpha(vigdata[, emotionalstability.items], check.keys = T))
es.keys <- alpha.es$keys
scoreStability = scoreItems(keys = es.keys, items = vigdata[, emotionalstability.items])
vigdata$stability = scoreStability$scores[, "A1"]

# score industry
industry.items = c("SPI_1744", "SPI_1976", "SPI_904", "SPI_1444", "SPI_1452")
(alpha.in <- psych::alpha(vigdata[, industry.items], check.keys = T))
in.keys <- alpha.in$keys*-1
scoreIndustry = scoreItems(keys = in.keys, items = vigdata[, industry.items])
vigdata$industry = scoreIndustry$scores[, "A1"]

# score irritability
irritability.items = c("SPI_952", "SPI_1357", "SPI_176", "SPI_1585", "SPI_1683")
(alpha.ir <- psych::alpha(vigdata[, irritability.items], check.keys = T))
ir.keys <- alpha.ir$keys*-1
scoreIrritable = scoreItems(keys = ir.keys, items = vigdata[, irritability.items])
vigdata$irritable = scoreIrritable$scores[, "A1"]

# score order
order.items = c("SPI_1201", "SPI_1290", "SPI_169", "SPI_1254", "SPI_1483")
(alpha.or <- psych::alpha(vigdata[, order.items], check.keys = T))
or.keys <- alpha.or$keys*-1
scoreOrder = scoreItems(keys = or.keys, items = vigdata[, order.items])
vigdata$order = scoreOrder$scores[, "A1"]

# score perfectionism
perfectionism.items = c("SPI_142", "SPI_571", "SPI_530", "SPI_1694", "SPI_1915")
(alpha.pf <- psych::alpha(vigdata[, perfectionism.items], check.keys = T))
pf.keys <- alpha.pf$keys
scorePerfect = scoreItems(keys = pf.keys, items = vigdata[, perfectionism.items])
vigdata$perfect = scorePerfect$scores[, "A1"]

# score selfcontrol
selfcontrol.items = c("SPI_1461", "SPI_1462", "SPI_56", "SPI_736", "SPI_1590")
(alpha.sc <- psych::alpha(vigdata[, selfcontrol.items], check.keys = T))
sc.keys <- alpha.sc$keys
scoreSelfcontrol = scoreItems(keys = sc.keys, items = vigdata[, selfcontrol.items])
vigdata$selfcontrol = scoreSelfcontrol$scores[, "A1"]

#---cor-partial---- 

r_est_c1 <- cor.ci(x = subset(vigdata, select = c(con, sensation)), n.iter = 1000, plot = FALSE)

(r_estimate_c1 <- median(r_est_c1$replicates[,1]))
(lower_r_c1 = quantile(r_est_c1$replicates[,1], probs = .025))
(upper_r_c1 = quantile(r_est_c1$replicates[,1], probs = .975))

r_est_c2 <- cor.ci(x = subset(vigdata, select = c(con, change)), n.iter = 1000, plot = FALSE)

(r_estimate_c2 <- median(r_est_c2$replicates[,1]))
(lower_r_c2 = quantile(r_est_c2$replicates[,1], probs = .025))
(upper_r_c2 = quantile(r_est_c2$replicates[,1], probs = .975))


boot.partialr <- function(data, indices) {
  newdata <- data[indices, ]
  pr <- partial.r(newdata, which(colnames(newdata) %in% c("con", "sensation")), 
                  which(colnames(newdata) %in% c("Age", "Gender")))
  cp <- corr.p(pr, n = nrow(newdata) - 2)
  r_est <- cp$r["con", "sensation"]
  return(r_est)
}


partial_r_est_c <- boot(data = subset(vigdata, select = c(con, sensation, Age, Gender)), statistic = boot.partialr, R = 1000)
(r_part_sensation_c <- mean(partial_r_est_c$t))
(boot_part_sensation_c <- boot.ci(partial_r_est_c, type = "perc"))

boot.partialr <- function(data, indices) {
  newdata <- data[indices, ]
  pr <- partial.r(newdata, which(colnames(newdata) %in% c("con", "change")), which(colnames(newdata) %in% c("Age", "Gender")))
  cp <- corr.p(pr, n = nrow(newdata) - 2)
  r_est <- cp$r["con", "change"]
  return(r_est)
}

# run the bootstrap function
partial_r_est_c2 <- boot(data = subset(vigdata, select = c(con, change, Age, Gender)), statistic = boot.partialr, R = 1000)

# extract mean estimate
(r_part_change_c <- mean(partial_r_est_c2$t))
# extract confidence interval using percentile method
(boot_part_change_c <- boot.ci(partial_r_est_c2, type = "perc"))


#----mediation-SAB------

load("mediationFun.Rdata")

med.srh.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_con", y = "z_srh", med = "sensation")
med.bmi.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_con", y = "z_bmi", med = "sensation")
# behaviors
med.exercise.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_con", y = "z_exercise", med = "sensation")
med.diet.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_con", y = "z_diet", med = "sensation")
med.alcohol.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_con", y = "z_alcohol", med = "sensation")
med.drug.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_con", y = "z_drug", med = "sensation")
med.adhere.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_con", y = "z_adhere", med = "sensation")
med.drinks.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_con", y = "z_drinks", med = "sensation")
med.binge.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_con", y = "z_binge", med = "sensation")
med.behavior.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_con", y = "behavior", med = "sensation")

# binary
med.smoke.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_con", y = "CigNow", med = "sensation", binary = TRUE)
med.cond.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_con", y = "HC_binary", med = "sensation", binary = TRUE)

outcomes = c("srh", "bmi", "cond", "exercise", "diet", "smoke", "alcohol", "drinks", "binge", "drug", "adhere", "behavior")

tab.rows = length(outcomes)*2

med.sensation.table <- data.frame(outcome = character(tab.rows), 
                                  total = character(tab.rows), 
                                  direct = character(tab.rows), 
                                  indirect = character(tab.rows), 
                                  a.path = character(tab.rows), 
                                  b.path = character(tab.rows), 
                                  stringsAsFactors = F)

n = 0
for (i in outcomes) {
  
  if (i == "srh") 
    out = "Self-Rated Health"
  if (i == "bmi") 
    out = "Body Mass Index"
  if (i == "exercise") 
    out = "Exercise"
  if (i == "alcohol") 
    out = "Alcohol Consumption"
  if (i == "diet") 
    out = "Dietary Habits"
  if (i == "drinks") 
    out = "Days Consume Alcohol"
  if (i == "binge") 
    out = "Days Binge Alcohol"
  if (i == "drug") 
    out = "Days Consume Illicit Drugs"
  if (i == "adhere") 
    out = "Medication Nonadherence"
  if (i == "behavior") 
    out = "Healthy Behavior"
  if (i == "smoke") 
    out = "Current Smoker"
  if (i == "cond") 
    out = "Has Chronic Condition"
  
  n = n + 1
  
  x <- get(paste("med", i, "sensation", sep = "."))
  
  total = num(x$t0[1])
  total.ci = boot.ci(x, type = "perc", index = 1)
  total.ci = round(total.ci$percent[4:5], 2)
  if (total.ci[1] > 0 | total.ci[2] < 0) 
    total = paste(total, "*", sep = "")
  total.ci = paste("[", paste(total.ci, collapse = ", "), "]", sep = "")
  
  direct = num(x$t0[2])
  direct.ci = boot.ci(x, type = "perc", index = 2)
  direct.ci = round(direct.ci$percent[4:5], 2)
  if (direct.ci[1] > 0 | direct.ci[2] < 0) 
    direct = paste(direct, "*", sep = "")
  direct.ci = paste("[", paste(direct.ci, collapse = ", "), "]", sep = "")
  
  indirect = num(x$t0[3])
  indirect.ci = boot.ci(x, type = "perc", index = 3)
  indirect.ci = round(indirect.ci$percent[4:5], 2)
  if (indirect.ci[1] > 0 | indirect.ci[2] < 0) 
    indirect = paste(indirect, "*", sep = "")
  indirect.ci = paste("[", paste(indirect.ci, collapse = ", "), "]", sep = "")
  
  a.path = num(x$t0[4])
  a.path.ci = boot.ci(x, type = "perc", index = 4)
  a.path.ci = round(a.path.ci$percent[4:5], 2)
  if (a.path.ci[1] > 0 | a.path.ci[2] < 0) 
    a.path = paste(a.path, "*", sep = "")
  a.path.ci = paste("[", paste(a.path.ci, collapse = ", "), "]", sep = "")
  
  b.path = num(x$t0[5])
  b.path.ci = boot.ci(x, type = "perc", index = 5)
  b.path.ci = round(b.path.ci$percent[4:5], 2)
  if (b.path.ci[1] > 0 | b.path.ci[2] < 0) 
    b.path = paste(b.path, "*", sep = "")
  b.path.ci = paste("[", paste(b.path.ci, collapse = ", "), "]", sep = "")
  
  rownames(med.sensation.table)[n] <- i
  med.sensation.table[n, "outcome"] <- out
  med.sensation.table[n, "total"] <- total
  med.sensation.table[n, "direct"] <- direct
  med.sensation.table[n, "indirect"] <- indirect
  med.sensation.table[n, "a.path"] <- a.path
  med.sensation.table[n, "b.path"] <- b.path
  
  n = n + 1
  rownames(med.sensation.table)[n] <- paste(i, "1")
  med.sensation.table[n, "total"] <- total.ci
  med.sensation.table[n, "direct"] <- direct.ci
  med.sensation.table[n, "indirect"] <- indirect.ci
  med.sensation.table[n, "a.path"] <- a.path.ci
  med.sensation.table[n, "b.path"] <- b.path.ci
}

colnames(med.sensation.table) = c("Outcome", "Total", "Direct", "Indirect", "a Path", "b Path")

med.sensation.table

#----mediation-CAB------

med.srh.change <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_con", y = "z_srh", med = "change")
med.bmi.change <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_con", y = "z_bmi", med = "change")

# behaviors
med.exercise.change <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_exercise", med = "change")
med.diet.change <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_diet", med = "change")
med.alcohol.change <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_alcohol", med = "change")
med.drug.change <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_drug", med = "change")
med.adhere.change <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_adhere", med = "change")
med.drinks.change <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_drinks", med = "change")
med.binge.change <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_binge", med = "change")
med.behavior.change <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "behavior", med = "change")

# binary
med.smoke.change <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_con", y = "CigNow", med = "change", binary = TRUE)
med.cond.change <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_con", y = "HC_binary", med = "change", binary = TRUE)


med.change.table <- data.frame(outcome = character(tab.rows), 
                               total = character(tab.rows), 
                               direct = character(tab.rows), 
                               indirect = character(tab.rows), 
                               a.path = character(tab.rows), 
                               b.path = character(tab.rows), 
                               stringsAsFactors = F)

n = 0

for (i in outcomes) {
  
  if (i == "srh") 
    out = "Self-Rated Health"
  if (i == "bmi") 
    out = "Body Mass Index"
  if (i == "exercise") 
    out = "Exercise"
  if (i == "alcohol") 
    out = "Alcohol Consumption"
  if (i == "diet") 
    out = "Dietary Habits"
  if (i == "drinks") 
    out = "Days Consume Alcohol"
  if (i == "binge") 
    out = "Days Binge Alcohol"
  if (i == "drug") 
    out = "Days Consume Illicit Drugs"
  if (i == "adhere") 
    out = "Medication Nonadherence"
  if (i == "behavior") 
    out = "Healthy Behavior"
  if (i == "smoke") 
    out = "Current Smoker"
  if (i == "cond") 
    out = "Has Chronic Condition"
  
  n = n + 1
  
  x <- get(paste("med", i, "change", sep = "."))
  
  total = num(x$t0[1])
  total.ci = boot.ci(x, type = "perc", index = 1)
  total.ci = round(total.ci$percent[4:5], 2)
  if (total.ci[1] > 0 | total.ci[2] < 0) 
    total = paste(total, "*", sep = "")
  total.ci = paste("[", paste(total.ci, collapse = ", "), "]", sep = "")
  
  direct = num(x$t0[2])
  direct.ci = boot.ci(x, type = "perc", index = 2)
  direct.ci = round(direct.ci$percent[4:5], 2)
  if (direct.ci[1] > 0 | direct.ci[2] < 0) 
    direct = paste(direct, "*", sep = "")
  direct.ci = paste("[", paste(direct.ci, collapse = ", "), "]", sep = "")
  
  indirect = num(x$t0[3])
  indirect.ci = boot.ci(x, type = "perc", index = 3)
  indirect.ci = round(indirect.ci$percent[4:5], 2)
  if (indirect.ci[1] > 0 | indirect.ci[2] < 0) 
    indirect = paste(indirect, "*", sep = "")
  indirect.ci = paste("[", paste(indirect.ci, collapse = ", "), "]", sep = "")
  
  a.path = num(x$t0[4])
  a.path.ci = boot.ci(x, type = "perc", index = 4)
  a.path.ci = round(a.path.ci$percent[4:5], 2)
  if (a.path.ci[1] > 0 | a.path.ci[2] < 0) 
    a.path = paste(a.path, "*", sep = "")
  a.path.ci = paste("[", paste(a.path.ci, collapse = ", "), "]", sep = "")
  
  b.path = num(x$t0[5])
  b.path.ci = boot.ci(x, type = "perc", index = 5)
  b.path.ci = round(b.path.ci$percent[4:5], 2)
  if (b.path.ci[1] > 0 | b.path.ci[2] < 0) 
    b.path = paste(b.path, "*", sep = "")
  b.path.ci = paste("[", paste(b.path.ci, collapse = ", "), "]", sep = "")
  
  rownames(med.change.table)[n] <- i
  med.change.table[n, "outcome"] <- out
  med.change.table[n, "total"] <- total
  med.change.table[n, "direct"] <- direct
  med.change.table[n, "indirect"] <- indirect
  med.change.table[n, "a.path"] <- a.path
  med.change.table[n, "b.path"] <- b.path
  
  n = n + 1
  rownames(med.change.table)[n] <- paste(i, "1")
  med.change.table[n, "total"] <- total.ci
  med.change.table[n, "direct"] <- direct.ci
  med.change.table[n, "indirect"] <- indirect.ci
  med.change.table[n, "a.path"] <- a.path.ci
  med.change.table[n, "b.path"] <- b.path.ci
}

colnames(med.change.table) = c("Outcome", "Total", "Direct", "Indirect", "a Path", "b Path")

med.change.table

#----mediation-BOTH------

med.srh.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_con", y = "z_srh", med = c("sensation", "change"))
med.bmi.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_con", y = "z_bmi", med = c("sensation", "change"))

# behaviors
med.exercise.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_exercise", med = c("sensation","change"))
med.diet.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_diet", med = c("sensation","change"))
med.alcohol.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_alcohol", med = c("sensation","change"))
med.drug.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_drug", med = c("sensation","change"))
med.adhere.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_adhere", med = c("sensation","change"))
med.drinks.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_drinks", med = c("sensation","change"))
med.binge.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_binge", med = c("sensation","change"))
med.behavior.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "behavior", med = c("sensation","change"))

# binary
med.smoke.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_con", y = "CigNow", med = c("sensation", "change"), binary = TRUE)
med.cond.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_con", y = "HC_binary", med = c("sensation", "change"), binary = TRUE)

med.both.table <- data.frame(outcome = character(tab.rows), 
                             total = character(tab.rows), 
                             direct = character(tab.rows), 
                             indirect = character(tab.rows), 
                             a.path.sensation = character(tab.rows), 
                             b.path.sensation = character(tab.rows), 
                             a.path.change = character(tab.rows), 
                             b.path.change = character(tab.rows), 
                             stringsAsFactors = F)
n = 0

for (i in outcomes) {
  
  if (i == "srh") 
    out = "Self-Rated Health"
  if (i == "bmi") 
    out = "Body Mass Index"
  if (i == "exercise") 
    out = "Exercise"
  if (i == "alcohol") 
    out = "Alcohol Consumption"
  if (i == "diet") 
    out = "Dietary Habits"
  if (i == "drinks") 
    out = "Days Consume Alcohol"
  if (i == "binge") 
    out = "Days Binge Alcohol"
  if (i == "drug") 
    out = "Days Consume Illicit Drugs"
  if (i == "adhere") 
    out = "Medication Nonadherence"
  if (i == "behavior") 
    out = "Healthy Behavior"
  if (i == "smoke") 
    out = "Current Smoker"
  if (i == "cond") 
    out = "Has Chronic Condition"
  
  n = n + 1
  
  x <- get(paste("med", i, "both", sep = "."))
  
  total = num(x$t0[1])
  total.ci = boot.ci(x, type = "perc", index = 1)
  total.ci = round(total.ci$percent[4:5], 2)
  if (total.ci[1] > 0 | total.ci[2] < 0) 
    total = paste(total, "*", sep = "")
  total.ci = paste("[", paste(total.ci, collapse = ", "), "]", sep = "")
  
  direct = num(x$t0[2])
  direct.ci = boot.ci(x, type = "perc", index = 2)
  direct.ci = round(direct.ci$percent[4:5], 2)
  if (direct.ci[1] > 0 | direct.ci[2] < 0) 
    direct = paste(direct, "*", sep = "")
  direct.ci = paste("[", paste(direct.ci, collapse = ", "), "]", sep = "")
  
  indirect = num(x$t0[3])
  indirect.ci = boot.ci(x, type = "perc", index = 3)
  indirect.ci = round(indirect.ci$percent[4:5], 2)
  if (indirect.ci[1] > 0 | indirect.ci[2] < 0) 
    indirect = paste(indirect, "*", sep = "")
  indirect.ci = paste("[", paste(indirect.ci, collapse = ", "), "]", sep = "")
  
  a.path.s = num(x$t0[4])
  a.path.s.ci = boot.ci(x, type = "perc", index = 4)
  a.path.s.ci = round(a.path.s.ci$percent[4:5], 2)
  if (a.path.s.ci[1] > 0 | a.path.s.ci[2] < 0) 
    a.path.s = paste(a.path.s, "*", sep = "")
  a.path.s.ci = paste("[", paste(a.path.s.ci, collapse = ", "), "]", sep = "")
  
  a.path.c = num(x$t0[5])
  a.path.c.ci = boot.ci(x, type = "perc", index = 5)
  a.path.c.ci = round(a.path.c.ci$percent[4:5], 2)
  if (a.path.c.ci[1] > 0 | a.path.c.ci[2] < 0) 
    a.path.c = paste(a.path.c, "*", sep = "")
  a.path.c.ci = paste("[", paste(a.path.c.ci, collapse = ", "), "]", sep = "")
  
  b.path.s = num(x$t0[6])
  b.path.s.ci = boot.ci(x, type = "perc", index = 6)
  b.path.s.ci = round(b.path.s.ci$percent[4:5], 2)
  if (b.path.s.ci[1] > 0 | b.path.s.ci[2] < 0) 
    b.path.s = paste(b.path.s, "*", sep = "")
  b.path.s.ci = paste("[", paste(b.path.s.ci, collapse = ", "), "]", sep = "")
  
  b.path.c = num(x$t0[7])
  b.path.c.ci = boot.ci(x, type = "perc", index = 7)
  b.path.c.ci = round(b.path.c.ci$percent[4:5], 2)
  if (b.path.c.ci[1] > 0 | b.path.c.ci[2] < 0) 
    b.path.c = paste(b.path.c, "*", sep = "")
  b.path.c.ci = paste("[", paste(b.path.c.ci, collapse = ", "), "]", sep = "")
  
  rownames(med.both.table)[n] <- i
  med.both.table[n, "outcome"] <- out
  med.both.table[n, "total"] <- total
  med.both.table[n, "direct"] <- direct
  med.both.table[n, "indirect"] <- indirect
  med.both.table[n, "a.path.sensation"] <- a.path.s
  med.both.table[n, "a.path.change"] <- a.path.c
  med.both.table[n, "b.path.sensation"] <- b.path.s
  med.both.table[n, "b.path.change"] <- b.path.c
  
  n = n + 1
  rownames(med.both.table)[n] <- paste(i, "1")
  med.both.table[n, "total"] <- total.ci
  med.both.table[n, "direct"] <- direct.ci
  med.both.table[n, "indirect"] <- indirect.ci
  med.both.table[n, "a.path.sensation"] <- a.path.s.ci
  med.both.table[n, "a.path.change"] <- a.path.c.ci
  med.both.table[n, "b.path.sensation"] <- b.path.s.ci
  med.both.table[n, "b.path.change"] <- b.path.c.ci
}

colnames(med.both.table) = c("Outcome", "Total", "Direct", "Indirect", "a Path sensation", "b Path sensation", "a Path change", "b Path change")

med.both.table

#----interactions -----

s.hn <- lm(sensation ~ z_neur*z_con + z_age + Gender, data=vigdata)
c.hn <- lm(change ~ z_neur*z_con + z_age + Gender, data=vigdata)

summary(s.hn)
summary(c.hn)

library(sjPlot)

sjp.int(s.hn, type = "eff", swap.pred = T, mdrt.values = "meansd")
sjp.int(c.hn, type = "eff", swap.pred = T, mdrt.values = "meansd")

#---correlation-matrix----

R.lower = corr.test(vigdata[,c("neuroticism","con","anxiety","stability","irritable","perfect","industry","order", 
                               "selfcontrol","sensation","change")])
corPlot(R.lower$r, numbers = TRUE)


#---bifactor-neuroticism----

n.bifactor <- '
neur =~ SPI_578 + SPI_4252 + SPI_979 + SPI_811 + SPI_1989 + SPI_1683 + SPI_4249 + SPI_793 + 
SPI_1585 + SPI_1505 + SPI_797 + SPI_176 + SPI_808 + SPI_1840 + SPI_174 + SPI_979 +
SPI_952 + SPI_1357 + SPI_142 + SPI_571 + SPI_530 + SPI_1694 + SPI_1915

anxiety =~ SPI_808 + SPI_1505 + SPI_1989 + SPI_4249 + SPI_4252

stability =~ SPI_174 + SPI_797 + SPI_1840 + SPI_793 + SPI_979

irritable =~ SPI_952 + SPI_1357 + SPI_176 + SPI_1585 + SPI_1683

perfect =~ SPI_142 + SPI_571 + SPI_530 + SPI_1694 + SPI_1915


'

neur.fit = cfa(n.bifactor, data=vigdata, orthogonal=T)
summary(neur.fit, fit.measures =T)


n.reg <- '
neur =~ SPI_578 + SPI_4252 + SPI_979 + SPI_811 + SPI_1989 + SPI_1683 + SPI_4249 + SPI_793 + 
SPI_1585 + SPI_1505 + SPI_797 + SPI_176 + SPI_808 + SPI_1840 + SPI_174 + SPI_979 +
SPI_952 + SPI_1357 + SPI_142 + SPI_571 + SPI_530 + SPI_1694 + SPI_1915

anxiety =~ SPI_808 + SPI_1505 + SPI_1989 + SPI_4249 + SPI_4252

stability =~ SPI_174 + SPI_797 + SPI_1840 + SPI_793 + SPI_979

irritable =~ SPI_952 + SPI_1357 + SPI_176 + SPI_1585 + SPI_1683

perfect =~ SPI_142 + SPI_571 + SPI_530 + SPI_1694 + SPI_1915

sensation ~ neur + anxiety + stability + irritable + perfect

change ~ neur + anxiety + stability + irritable + perfect

'



neur.reg = cfa(n.reg, data=vigdata, orthogonal=T)
summary(neur.reg, fit.measures=T, standardized =T)

#---bifactor-conscientiousness----


c.bifactor <- '
con =~ SPI_369 + SPI_1867 + SPI_1744 + SPI_1976 + SPI_904 + SPI_1444 + SPI_1452 + 
SPI_1201 + SPI_1290 + SPI_1254 + SPI_1483 + SPI_530 + SPI_1694 + SPI_1915 + SPI_169 + 
SPI_1461 + SPI_1462 + SPI_56  + SPI_736 + SPI_1590 + SPI_142 + SPI_571

industry =~ SPI_1744 + SPI_1976 + SPI_904 + SPI_1444 + SPI_1452

order =~ SPI_1201 + SPI_1290 + SPI_169 + SPI_1254 + SPI_1483

selfcontrol =~ SPI_1461 + SPI_1462 + SPI_56 + SPI_736 + SPI_1590

perfect =~ SPI_142 + SPI_571 + SPI_530 + SPI_1694 + SPI_1915


'

con.fit = cfa(c.bifactor, data=vigdata, orthogonal=T)
summary(con.fit, fit.measures = T)


c.reg <- '
con =~ SPI_369 + SPI_1867 + SPI_1744 + SPI_1976 + SPI_904 + SPI_1444 + SPI_1452 + 
SPI_1201 + SPI_1290 + SPI_1254 + SPI_1483 + SPI_530 + SPI_1694 + SPI_1915 + SPI_169 + 
SPI_1461 + SPI_1462 + SPI_56  + SPI_736 + SPI_1590 + SPI_142 + SPI_571

industry =~ SPI_1744 + SPI_1976 + SPI_904 + SPI_1444 + SPI_1452

order =~ SPI_1201 + SPI_1290 + SPI_169 + SPI_1254 + SPI_1483

selfcontrol =~ SPI_1461 + SPI_1462 + SPI_56 + SPI_736 + SPI_1590

perfect =~ SPI_142 + SPI_571 + SPI_530 + SPI_1694 + SPI_1915

sensation ~ con + industry + order + selfcontrol + perfect

change ~ con + industry + order + selfcontrol + perfect

'



con.reg = cfa(c.reg, data=vigdata, orthogonal=T)
summary(con.reg, fit.measures=T, standardized = T)

library(semPlot)
semPaths(neur.reg)

#---bifactor-both----

b.bifactor <- '
neur =~ SPI_578 + SPI_4252 + SPI_979 + SPI_811 + SPI_1989 + SPI_1683 + SPI_4249 + SPI_793 + 
SPI_1585 + SPI_1505 + SPI_797 + SPI_176 + SPI_808 + SPI_1840 + SPI_174 + SPI_979 +
SPI_952 + SPI_1357 + SPI_142 + SPI_571 + SPI_530 + SPI_1694 + SPI_1915

con =~ SPI_369 + SPI_1867 + SPI_1744 + SPI_1976 + SPI_904 + SPI_1444 + SPI_1452 + 
SPI_1201 + SPI_1290 + SPI_1254 + SPI_1483 + SPI_530 + SPI_1694 + SPI_1915 + SPI_169 + 
SPI_1461 + SPI_1462 + SPI_56  + SPI_736 + SPI_1590 + SPI_142 + SPI_571


anxiety =~ SPI_808 + SPI_1505 + SPI_1989 + SPI_4249 + SPI_4252

stability =~ SPI_174 + SPI_797 + SPI_1840 + SPI_793 + SPI_979

irritable =~ SPI_952 + SPI_1357 + SPI_176 + SPI_1585 + SPI_1683

industry =~ SPI_1744 + SPI_1976 + SPI_904 + SPI_1444 + SPI_1452

order =~ SPI_1201 + SPI_1290 + SPI_169 + SPI_1254 + SPI_1483

selfcontrol =~ SPI_1461 + SPI_1462 + SPI_56 + SPI_736 + SPI_1590

perfect =~ SPI_142 + SPI_571 + SPI_530 + SPI_1694 + SPI_1915

neur ~~ con

'

both.fit = cfa(b.bifactor, data=vigdata, orthogonal=T)
summary(both.fit, fit.measures = T)



b.reg <- '
neur =~ SPI_578 + SPI_4252 + SPI_979 + SPI_811 + SPI_1989 + SPI_1683 + SPI_4249 + SPI_793 + 
SPI_1585 + SPI_1505 + SPI_797 + SPI_176 + SPI_808 + SPI_1840 + SPI_174 + SPI_979 +
SPI_952 + SPI_1357 + SPI_142 + SPI_571 + SPI_530 + SPI_1694 + SPI_1915

con =~ SPI_369 + SPI_1867 + SPI_1744 + SPI_1976 + SPI_904 + SPI_1444 + SPI_1452 + 
SPI_1201 + SPI_1290 + SPI_1254 + SPI_1483 + SPI_530 + SPI_1694 + SPI_1915 + SPI_169 + 
SPI_1461 + SPI_1462 + SPI_56  + SPI_736 + SPI_1590 + SPI_142 + SPI_571


anxiety =~ SPI_808 + SPI_1505 + SPI_1989 + SPI_4249 + SPI_4252

stability =~ SPI_174 + SPI_797 + SPI_1840 + SPI_793 + SPI_979

irritable =~ SPI_952 + SPI_1357 + SPI_176 + SPI_1585 + SPI_1683

industry =~ SPI_1744 + SPI_1976 + SPI_904 + SPI_1444 + SPI_1452

order =~ SPI_1201 + SPI_1290 + SPI_169 + SPI_1254 + SPI_1483

selfcontrol =~ SPI_1461 + SPI_1462 + SPI_56 + SPI_736 + SPI_1590

perfect =~ SPI_142 + SPI_571 + SPI_530 + SPI_1694 + SPI_1915

neur ~~ con

sensation ~ neur + con + anxiety + stability + irritable + industry + order + selfcontrol + perfect

change ~ neur + con + anxiety + stability + irritable + industry + order + selfcontrol + perfect

'

both.reg = cfa(b.reg, data=vigdata, orthogonal=T)
summary(both.reg, fit.measures=T)

