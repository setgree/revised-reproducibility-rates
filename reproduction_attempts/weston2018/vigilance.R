# ---- options ----

options(width = 120)

set.seed(7916)

# ---- packages ----

library(knitr)
library(psych)
library(pwr)
library(GPArotation)
library(boot)
library(pwr)
library(tidyverse)
library(lavaan)
library(stargazer)
library(sjPlot)

write_bib(c("psych", "boot", "pwr", "GPArotation", "tidyverse", "lavaan", "stargazer", "sjPlot", "R"), 
          file = "vigPackages.bib")

# ---- num-function ----

# the num() function prints numbers in the correct form, based on whether 

# the value is an integer how many digits it should be rounded to

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
        y <- paste(y, paste(rep(0, digits - nchar(z[[1]][2])), collapse = ""), 
                   sep = "") else if (!grepl("\\.", y) & int == F & digits != 0) 
        y <- paste(y, ".", paste(rep(0, digits), collapse = ""), sep = "")
    return(y)
}

# ---- data ----

vigdata <- read.csv("data/Neuroticism+%26+Vigilance+-+Final+Version_August+22%2C+2017_17.36_skip23.csv", 
                    stringsAsFactors = F)

# ---- gc-factor ----

vigdata$gc <- factor(vigdata$gc, levels = c(1:4), 
                     labels = c("Good Completes", "Screen Out", "Over Quota", 
                                "Failed Quality Check"))
table(vigdata$gc)

# save sample sizes for inclusion in the manuscript
(N_total <- nrow(vigdata))
(N_final <- table(vigdata$gc)["Good Completes"])
(N_screen <- table(vigdata$gc)["Screen Out"])
(N_fail <- table(vigdata$gc)["Failed Quality Check"])

# ---- power ----

pwr.90 <- pwr.r.test(n = N_final, sig.level = 0.05, power = 0.9)
pwr.90

# ---- clean ----

vigdata <- subset(vigdata, gc == "Good Completes")

# clean SPI column names for ease of use
colnames(vigdata) <- gsub("SPI.135_1_", "", colnames(vigdata))
colnames(vigdata) <- gsub("SPI.135_2_", "", colnames(vigdata))
colnames(vigdata) <- gsub("SPI.135_3_", "", colnames(vigdata))

#calculate percent male and percent female
# option choice 1 is for male, 2 is for female, 3 is for other
(per_female = table(vigdata$Gender)["2"]/N_final)
(per_male = table(vigdata$Gender)["1"]/N_final)

#reassign all non-males to non-male category, Make male category 0 as reference.
vigdata$Gender <- ifelse(vigdata$Gender == 1, 0, 1)

#identify neuroticism items in data frame
neur.items = c("SPI_578", "SPI_4252", "SPI_979", "SPI_811", "SPI_1989", "SPI_1683", 
               "SPI_4249", "SPI_793", "SPI_1585", "SPI_1505", "SPI_797", 
               "SPI_176", "SPI_808", "SPI_1840")

# estimate Cronbach's alpha for the scale
alpha.n <- psych::alpha(vigdata[, neur.items], check.keys = T)
alpha.n
# capture the keys vector to ensure items are coded in the correct way
n.keys <- alpha.n$keys
n.alpha <- alpha.n$total[1, "raw_alpha"]

# estimate omega heirarchical for the neuroticism scale
omega.n <- omega(vigdata[, neur.items], key = n.keys, plot = FALSE)
omega.n
n.omega <- omega.n$omega_h

# score personality
scoreNeur = scoreItems(keys = n.keys, items = vigdata[, neur.items])
vigdata$neuroticism = scoreNeur$scores[, "A1"]

# calculate BMI
vigdata$BMI = (vigdata$Weight * 0.45)/((vigdata$Height * 0.025)^2)

# add comma to end of all HC text expressions
HC_mod <- paste(vigdata$HC, ",", sep = "")
HC_count <- sapply(gregexpr(",", HC_mod), length)
# change to 0 if nothing is there
HC_count[vigdata$HC == ""] <- 0
vigdata$HC_count = HC_count
vigdata$HC_binary = ifelse(HC_count > 0, 1, 0)

# check how many participants have at least two HCs
n2plus <- length(which(vigdata$HC_count > 1))
p2plus <- length(which(vigdata$HC_count > 1))/N_final
p2plus

# if participant reports smoking never, give them a 0 for smoking now
vigdata$CigNow[vigdata$CigEver == 0] <- 0
# calculate percentage of current smokers
psmokenow = length(which(vigdata$CigNow == 1))/N_final
psmokenow

# what is the correlation between the two alcohol items?
alcohol.cor <- cor(vigdata$AlDay_1, vigdata$AlBng_1, use = "pairwise")
alcohol.cor
#average responses to two alcohol items
vigdata$alcohol = rowMeans(vigdata[, c("AlDay_1", "AlBng_1")], na.rm = T)

# convert medication adherence variable to numeric
adhere_num <- vigdata$Adhere
adhere_num[grepl("no", adhere_num)] <- 0
adhere_num[grepl("No", adhere_num)] <- 0
adhere_num[grepl("NO", adhere_num)] <- 0
adhere_num[grepl("never", adhere_num)] <- 0
adhere_num[grepl("Never", adhere_num)] <- 0
adhere_num[adhere_num == "A lot"] <- NA
adhere_num[adhere_num == "3 days"] <- 3
adhere_num[adhere_num == "3-Feb"] <- 3
adhere_num[adhere_num == "I don't take every day.  As needed"] <- NA
adhere_num[adhere_num == "most-taken as needed"] <- NA
adhere_num[adhere_num == "Q0"] <- NA
adhere_num <- as.numeric(adhere_num)
vigdata$adhere_num <- adhere_num

(num_med = length(which(vigdata$Med == 1)))


#standardize continuous variables
vigdata$z_neur <- as.numeric(scale(vigdata$neuroticism))
vigdata$z_age <- as.numeric(scale(vigdata$Age))
vigdata$z_srh <- as.numeric(scale(vigdata$SRH))
vigdata$z_bmi <- as.numeric(scale(vigdata$BMI))
vigdata$z_exercise <- as.numeric(scale(vigdata$Exercise))
vigdata$z_diet <- as.numeric(scale(vigdata$Diet))
vigdata$z_drinks <- as.numeric(scale(vigdata$AlDay_1)) #number of days drinking per month
vigdata$z_binge <- as.numeric(scale(vigdata$AlBng_1)) #number of days binge drinking per month
vigdata$z_drug <- as.numeric(scale(vigdata$Drg_1)) #number of days use illicit drugs per month
vigdata$z_alcohol <- as.numeric(scale(vigdata$alcohol)) #alcohol composite
vigdata$z_adhere <- as.numeric(scale(vigdata$Drg_1)) #number of days use illicit drugs per month
vigdata$z_numcond <- as.numeric(scale(vigdata$HC_count)) #number of health conditions
vigdata$z_adhere <- as.numeric(scale(vigdata$adhere_num)) #number of health conditions

#---- behavior -----
behaviors <- "
behaviors =~ Exercise_1 + Diet + CigNow + alcohol + Drg_1
"
behavior.fit = cfa(behaviors, data = vigdata, missing = "fiml")
(rmsea.behavior <- inspect(behavior.fit, "fit.measures")["rmsea"])

vigdata$behavior <- predict(behavior.fit)[,1]

behavior.unstand <- parameterEstimates(behavior.fit)
behavior.stand <- standardizedSolution(behavior.fit)

# ---- vigilance-fa ----

# the fourth item in the body vigilance scale is the average of 15 responses.
vigdata$BVS4 = rowMeans(vigdata[, c("BVS4_BVS4_1", "BVS4_BVS4_2", "BVS4_BVS4_3", 
                                    "BVS4_BVS4_4", "BVS4_BVS4_5", "BVS4_BVS4_6", 
                                    "BVS4_BVS4_7", "BVS4_BVS4_8", "BVS4_BVS4_9", 
                                    "BVS4_BVS4_10", "BVS4_BVS4_11", "BVS4_BVS4_12", 
                                    "BVS4_BVS4_13", "BVS4_BVS4_14", "BVS4_BVS4_15")], 
                        na.rm = T)

vig.items = c("BAQ01", "BAQ02", "BAQ03", "BAQ04", "BAQ05", "BAQ06", "BAQ07", 
              "BAQ08", "BAQ09", "BAQ10", "BAQ11", "BAQ12", "BAQ13", "BAQ14", 
              "BAQ15", "BAQ16", "BAQ17", "BAQ18", "PBCS01", "PBCS02", "PBCS03", 
              "PBCS04", "PBCS05", "SBA01", "SBA02", "SBA03", "SBA04", "BRQ01", 
              "BRQ02", "BRQ03", "BRQ04", "BRQ05", "BRQ06", "BRQ07", "BVS1", 
              "BVS2", "BVS3", "BVS4")
vig.text <- read.csv("data/vig.text.csv", row.names = 1)
nfactors(vigdata[, vig.items])

fa.2 <- fa(vigdata[, vig.items], nfactors = 2)
fa.3 <- fa(vigdata[, vig.items], nfactors = 3)
fa.6 <- fa(vigdata[, vig.items], nfactors = 6)

fa.lookup(fa.6, dictionary = vig.text)

fa.lookup(fa.3, dictionary = vig.text)

fa.lookup(fa.2, dictionary = vig.text)

# estimate measures of internal reliability for each factor in each solution
rel.estimates <- data.frame(solution = numeric(length(2 + 3 + 6)), 
                            factor = numeric(length(2 + 3 + 6)), 
                            alpha = numeric(length(2 + 3 + 6)), 
                            omega_h = numeric(length(2 + 3 + 6)), 
                            unidim = numeric(length(2 + 3 + 6)))

n <- 0

for (i in c(2, 3, 6)) {
    keys <- as.matrix(get(paste("fa", i, sep = "."))$loadings)
    keys[keys < 0.2] <- 0
    keys[keys >= 0.2] <- 1
    
    for (j in 1:i) {
        n <- n + 1
        
        num_items <- length(which(keys[, j] == 1))
        
        # if fewer than 4 items, can't estimate omega hierarchical, 
        #which requires 3+ factors
        
        rel.estimates[n, "solution"] <- i
        rel.estimates[n, "factor"] <- j
        
        rel.estimates[n, "alpha"] <- psych::alpha(vigdata[, vig.items[keys[, j] == 1]])$total$raw_alpha
        rel.estimates[n, "unidim"] <- psych::alpha(vigdata[, vig.items[keys[, j] == 1]])$Unidim$Unidim
        if (num_items > 3) {
            rel.estimates[n, "omega_h"] <- omega(vigdata[, vig.items[keys[, j] == 1]], plot = F)$omega_h
        }
        
        
    }
}

rel.estimates

rel.estimates %>% group_by(solution) %>% 
  summarize(alpha = mean(alpha, na.rm = T), 
            unidim = mean(unidim, na.rm = T), 
            omega_h = mean(omega_h, na.rm = T))

vig.items <- vig.items[which(!(vig.items %in% c("BVS4", "BRQ01", "BRQ05")))]
nfactors(vigdata[, vig.items])

fa.final <- fa(vigdata[, vig.items], nfactors = 2)
fa.table <- fa.lookup(fa.final, dictionary = vig.text)
vigdata$sensation = fa.final$scores[, 1]
vigdata$change = fa.final$scores[, 2]

stargazer(fa.table[, c(ncol(fa.table), 1:ncol(fa.table) - 1)], 
          summary = F, title = "Factor solution for body vigilance items", 
          label = "vig.fa", 
    font.size = "tiny", out = "tables/vigFA.tex")


# ---- vigFA-factor ----

(vig.factor.cor <- fa.final$r.scores[1,2])

(cor.vig.health <- corr.test(y = vigdata[,c("sensation","change")], 
                            x = vigdata[,c("z_srh", "z_bmi", "z_exercise", "z_diet", "z_alcohol", "z_drinks", "z_binge", 
                                           "z_drug", "z_adhere", "behavior", "CigNow", "HC_binary")],
                            adjust = "none"))



save(vigdata, file="cleaned.Rdata")


# ---- cor ----

r_est1 <- cor.ci(x = subset(vigdata, select = c(neuroticism, sensation)), 
                 n.iter = 1000, plot = FALSE)

r_estimate1 <- median(r_est1$replicates[,1])
lower_r1 = quantile(r_est1$replicates[,1], probs = .025)
upper_r1 = quantile(r_est1$replicates[,1], probs = .975)

r_est2 <- cor.ci(x = subset(vigdata, select = c(neuroticism, change)), 
                 n.iter = 1000, plot = FALSE)

r_estimate2 <- median(r_est2$replicates[,1])
lower_r2 = quantile(r_est2$replicates[,1], probs = .025)
upper_r2 = quantile(r_est2$replicates[,1], probs = .975)

# ---- partial-cor ----

# create a function to estimate the partial correlation between neuroticism and sensation controlling for age and gender
boot.partialr <- function(data, indices) {
    newdata <- data[indices, ]
    pr <- partial.r(newdata, which(colnames(newdata) %in% c("neuroticism", "sensation")), 
                    which(colnames(newdata) %in% c("Age", "Gender")))
    cp <- corr.p(pr, n = nrow(newdata) - 2)
    r_est <- cp$r["neuroticism", "sensation"]
    return(r_est)
}

# run the bootstrap function
partial_r_est <- boot(data = subset(vigdata, select = c(neuroticism, sensation, Age, Gender)), statistic = boot.partialr, R = 1000)

# extract mean estimate
(r_part_sensation <- mean(partial_r_est$t))
# extract confidence interval using percentile method
(boot_part_sensation <- boot.ci(partial_r_est, type = "perc"))

# create a function to estimate the partial correlation between neuroticism and sensation controlling for age and gender
boot.partialr <- function(data, indices) {
    newdata <- data[indices, ]
    pr <- partial.r(newdata, which(colnames(newdata) %in% c("neuroticism", "change")), which(colnames(newdata) %in% c("Age", "Gender")))
    cp <- corr.p(pr, n = nrow(newdata) - 2)
    r_est <- cp$r["neuroticism", "change"]
    return(r_est)
}

# run the bootstrap function
partial_r_est2 <- boot(data = subset(vigdata, select = c(neuroticism, change, Age, Gender)), statistic = boot.partialr, R = 1000)

# extract mean estimate
(r_part_change <- mean(partial_r_est2$t))
# extract confidence interval using percentile method
(boot_part_change <- boot.ci(partial_r_est2, type = "perc"))

corplotdata = data.frame(r = c(r_est1$replicates[,1], 
                               r_est2$replicates[,1], 
                               partial_r_est$t,
                               partial_r_est2$t),
                         stat =c(rep("r", 2000),
                                 rep("partial_r",2000)),
                         outcome=c(rep(c(rep("sensation",1000),rep("change",1000)),2)))
corplotdata$stat = factor(corplotdata$stat, levels=c("r","partial_r"), labels=c("r","partial r"))
corplotdata$outcome = factor(corplotdata$outcome, levels=c("sensation","change"))

corplot_lines = corplotdata %>%
  group_by(stat, outcome) %>%
  summarize(med = median(r), lower = quantile(r, probs = .025), upper =quantile(r, probs = .975))

ggplot(corplotdata, aes(x=r, ..density..)) +
  geom_histogram(binwidth = .01, fill="darkgreen", alpha=.3, ) +
  geom_density(alpha = .3)+
  geom_vline(aes(xintercept=med), data=corplot_lines)+
  geom_vline(xintercept = 0, linetype = "dashed")+
  facet_grid(stat~outcome) +
  theme_bw()
ggsave("plots/cordist.pdf", width = 5, height = 5)
  
# ---- mediation-function ----


mediation.boot <- function(data, indices, x, y, med, binary = FALSE) {
    newdata <- data[indices, ]
    
    total.formula <- as.formula(paste(y, "~", paste(x,"+"), "z_age + Gender", sep = ""))
    if (length(med) == 1) 
        a.formula <- as.formula(paste(med, "~", paste(x,"+"), "z_age + Gender", sep = " "))
    if (length(med) > 1) {
        for (i in 1:length(med)) {
            a.formula <- as.formula(paste(med[i], "~", paste(x,"+"), "z_age + Gender", sep = " "))
            assign(paste("a.formula", i, sep = "_"), a.formula)
        }
    }
    b.formula <- as.formula(paste(y, "~", paste(x,"+"), "z_age + Gender +", paste(med, collapse = " + "), sep = " "))
    
    if (binary == FALSE) 
        total.mod <- lm(total.formula, data = newdata)
    if (binary == FALSE) 
        b.mod <- lm(b.formula, data = newdata)
    
    if (binary == TRUE) 
        total.mod <- glm(total.formula, data = newdata, family = "binomial")
    if (binary == TRUE) 
        b.mod <- glm(b.formula, data = newdata, family = "binomial")
    
    if (length(med) == 1) 
        a.mod <- lm(a.formula, data = newdata)
    if (length(med) == 1) 
        a.path <- coef(a.mod)[x]
    if (length(med) == 1) 
        names(a.path) <- "a.path"
    if (length(med) == 1) 
        b.path <- coef(b.mod)[med]
    if (length(med) == 1) 
        names(b.path) <- "b.path"
    
    if (length(med) > 1) {
        a.path = numeric(length = length(med))
        
        for (i in 1:length(med)) {
            a.mod = lm(get(paste("a.formula", i, sep = "_")), data = newdata)
            
            a.path[i] <- coef(a.mod)[x]
            names(a.path)[i] <- paste("a.path", med[i], sep = "_")
            
        }
    }
    
    
    total.effect <- coef(total.mod)[x]
    
    
    if (length(med) > 1) {
        b.path = numeric(length = length(med))
        for (i in 1:length(med)) {
            b.path[i] <- coef(b.mod)[med[i]]
            names(b.path)[i] <- paste("b.path", med[i], sep = "_")
            
        }
    }
    
    direct.effect <- coef(b.mod)[x]
    
    if (binary == TRUE) {
        # equations from MacKinnon and Dwyer (1993) and Nathaniel Herr's website http://www.nrhpsych.com/mediation/logmed.html
        sd_x = sd(newdata$z_neur, na.rm = T)
        sd_y1 = total.effect^2 * sd_x^2 + ((pi^2)/3)
        
        sd_m = numeric(length(med))
        cov_xm = numeric(length(med))
        
        for (i in 1:length(med)) {
            sd_m[i] = sd(newdata[, med[i]], na.rm = T)
            cov_xm = cov(newdata[,x], newdata[, med[i]], use = "pairwise")
        }
        
        sd_y2 = direct.effect^2 * sd_x^2 + b.path^2 * sd_m^2 + 2 * b.path * direct.effect * cov_xm + ((pi^2)/3)
        
        a.path = a.path * (sd_x/sd_m)
        b.path = b.path * (sd_m/sd_y2)
        total.effect = total.effect * (sd_x/sd_y1)
        direct.effect = direct.effect * (sd_x/sd_y2)
    }
    indirect.effect = total.effect - direct.effect
    
    
    if (length(med) == 1) 
        all.coef <- c(total.effect, direct.effect, indirect.effect, a.path, b.path)
    if (length(med) == 1) 
        names(all.coef)[1:3] = c("total.effect", "direct.effect", "indirect.effect")
    
    if (length(med) > 1) {
        all.coef <- c(total.effect, direct.effect, indirect.effect, a.path, b.path)
        names(all.coef)[1:3] = c("total.effect", "direct.effect", "indirect.effect")
        
    }
    
    return(all.coef)
}
save(mediation.boot, file = "mediationFun.Rdata")

# ---- mediation-sensation ----

med.srh.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_srh", med = "sensation")
med.bmi.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_bmi", med = "sensation")
# behaviors
med.exercise.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_exercise", med = "sensation")
med.diet.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_diet", med = "sensation")
med.alcohol.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_alcohol", med = "sensation")
med.drug.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_drug", med = "sensation")
med.adhere.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_adhere", med = "sensation")
med.drinks.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_drinks", med = "sensation")
med.binge.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_binge", med = "sensation")
med.behavior.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "behavior", med = "sensation")

# binary
med.smoke.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "CigNow", med = "sensation", binary = TRUE)
med.cond.sensation <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "HC_binary", med = "sensation", binary = TRUE)

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
save(med.sensation.table, file="medsensation.Rdata")


colnames(med.sensation.table) = c("Outcome", "Total", "Direct", "Indirect", "a Path", "b Path")

direct.s.behave = boot.ci(med.behavior.sensation, index = 2, type = "perc")$percent
indirect.s.behave = boot.ci(med.behavior.sensation, index = 3, type = "perc")$percent

indirect.s.srh = boot.ci(med.srh.sensation, index = 3, type = "perc")$percent
indirect.s.bmi = boot.ci(med.bmi.sensation, index = 3, type = "perc")$percent
indirect.s.adhere = boot.ci(med.adhere.sensation, index = 3, type = "perc")$percent
indirect.s.cond = boot.ci(med.cond.sensation, index = 3, type = "perc")$percent


# ---- mediation-sensation-table-all ----

stargazer(med.sensation.table, summary = F, 
          title = "Mediation of neuroticism-health relationships by sensation factor of body vigilance. 
          All coefficient estimates are standardized. Bootstrapped confidence intervals are presented. 
          All models control for age and gender.", 
    rownames = F, font.size = "tiny", 
    label = "med.sensation", out = "tables/mediation_sensation.tex")

# ---- mediation-sensation-table-pub ----

pub.outcomes = which(rownames(med.sensation.table) %in% c("srh", "srh 1", "bmi", "bmi 1", "cond", "cond 1",
                                                          "exercise", "exercise 1", "diet", "diet 1",
                                                          "smoke", "smoke 1", "alcohol", "alcohol 1",
                                                          "drug", "drug 1", "adhere", "adhere 1"
                                                          ))

stargazer(med.sensation.table[pub.outcomes, ], 
          summary = F, title = "Mediation of neuroticism-health relationships by sensation factor of body vigilance. All coefficient estimates are standardized. Bootstrapped confidence intervals are presented. All models control for age and gender.", 
    
          rownames = F, font.size = "tiny", label = "med.sensation", out = "tables/mediation_sensation.tex")

# ---- mediation-sensation-table-print ----

cat("\\include{tables/mediation_sensation}")

# ---- mediation-change ----

med.srh.change <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_srh", med = "change")
med.bmi.change <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_bmi", med = "change")

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
med.smoke.change <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "CigNow", med = "change", binary = TRUE)
med.cond.change <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "HC_binary", med = "change", binary = TRUE)


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

save(med.change.table, file="medchange.Rdata")

colnames(med.change.table) = c("Outcome", "Total", "Direct", "Indirect", "a Path", "b Path")



# ---- mediation-change-table-all ----

stargazer(med.change.table, summary = F, 
          title = "Mediation of neuroticism-health relationships by change factor of body vigilance. 
          All coefficient estimates are standardized. Bootstrapped confidence intervals are presented. 
          All models control for age and gender.", 
          rownames = F, font.size = "tiny", label = "med.change", out = "tables/mediation_change.tex")

# ---- mediation-change-table-pub ----

pub.outcomes = which(rownames(med.change.table) %in% c("srh", "srh 1", "bmi", "bmi 1", "cond", "cond 1",
                                                       "exercise", "exercise 1", "diet", "diet 1",
                                                       "smoke", "smoke 1", "alcohol", "alcohol 1",
                                                       "drug", "drug 1", "adhere", "adhere 1"))
stargazer(med.change.table[pub.outcomes, ], 
          summary = F, title = "Mediation of neuroticism-health relationships by change factor of body vigilance. All coefficient estimates are standardized. Bootstrapped confidence intervals are presented. All models control for age and gender.", 
          
          rownames = F, font.size = "tiny", label = "med.change", out = "tables/mediation_change.tex")

# ---- mediation-change-table-print ----

cat("\\include{tables/mediation_change}")


# ---- mediation-both----

med.srh.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_srh", med = c("sensation", "change"))
med.bmi.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_bmi", med = c("sensation", "change"))

# behaviors
med.exercise.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_exercise", med = c("sensation", "change"))
med.diet.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_diet", med = c("sensation", "change"))
med.alcohol.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_alcohol", med = c("sensation", "change"))
med.drinks.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_drinks", med = c("sensation", "change"))
med.binge.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_binge", med = c("sensation", "change"))
med.drug.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_drug", med = c("sensation", "change"))
med.adhere.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "z_adhere", med = c("sensation", "change"))
med.behavior.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, x = "z_neur", y = "behavior", med = c("sensation", "change"))

# binary
med.smoke.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, 
                       x = "z_neur", y = "CigNow", med = c("sensation", "change"), binary = TRUE)
med.cond.both <- boot(data = vigdata, statistic = mediation.boot, R = 1000, 
                      x = "z_neur", y = "HC_binary", med = c("sensation", "change"), binary = TRUE)

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

indirect.b.behave = boot.ci(med.behavior.both, index = 3, type = "perc")$percent
indirect.b.srh = boot.ci(med.srh.both, index = 3, type = "perc")$percent
indirect.b.bmi = boot.ci(med.bmi.both, index = 3, type = "perc")$percent
indirect.b.adhere = boot.ci(med.adhere.both, index = 3, type = "perc")$percent
indirect.b.cond = boot.ci(med.cond.both, index = 3, type = "perc")$percent

# ---- mediation-both-table-all----

stargazer(med.both.table, summary = F, 
          title = "Mediation of neuroticism-health relationships by both vigilance factor of body vigilance. 
          All coefficient estimates are standardized. Bootstrapped confidence intervals are presented. 
          All models control for age and gender.", 
    rownames = F, font.size = "tiny", label = "med.both", out = "tables/mediation_both.tex")

# ---- mediation-both-table-pub----
pub.outcomes = which(rownames(med.both.table) %in% c("srh", "srh 1", "bmi", "bmi 1", "cond", "cond 1",
                                                     "exercise", "exercise 1", "diet", "diet 1",
                                                     "smoke", "smoke 1", "alcohol", "alcohol 1",
                                                     "drug", "drug 1", "adhere", "adhere 1"))
stargazer(med.both.table[pub.outcomes, ], summary = F, title = "Mediation of neuroticism-health relationships by both vigilance factors of body vigilance. All coefficient estimates are standardized. Bootstrapped confidence intervals are presented. All models control for age and gender.", 
    rownames = F, font.size = "tiny", label = "med.both", out = "tables/mediation_both.tex")

# ---- mediation-both-table-print----
cat("\\include{tables/mediation_both}")

# ---- explore1----
mod.lm.boot <- function(data, indices, formula) {
    d <- data[indices, ]
    fit <- lm(formula, data = d)
    return(coef(fit))
}

# outcomes
boot.srh <- boot(data = vigdata, statistic = mod.lm.boot, R = 1000, formula = z_srh ~ z_age + Gender + z_neur * change)
boot.bmi <- boot(data = vigdata, statistic = mod.lm.boot, R = 1000, formula = z_bmi ~ z_age + Gender + z_neur * change)
boot.num_cond <- boot(data = vigdata, statistic = mod.lm.boot, R = 1000, formula = z_numcond ~ z_age + Gender + z_neur * change)


# behaviors
boot.exercise <- boot(data = vigdata, statistic = mod.lm.boot, R = 1000, formula = z_exercise ~ z_age + Gender + z_neur * change)
boot.diet <- boot(data = vigdata, statistic = mod.lm.boot, R = 1000, formula = z_diet ~ z_age + Gender + z_neur * change)
boot.alcohol <- boot(data = vigdata, statistic = mod.lm.boot, R = 1000, formula = z_alcohol ~ z_age + Gender + z_neur * change)
boot.drinks <- boot(data = vigdata, statistic = mod.lm.boot, R = 1000, formula = z_drinks ~ z_age + Gender + z_neur * change)
boot.binge <- boot(data = vigdata, statistic = mod.lm.boot, R = 1000, formula = z_binge ~ z_age + Gender + z_neur * change)
boot.drug <- boot(data = vigdata, statistic = mod.lm.boot, R = 1000, formula = z_drug ~ z_age + Gender + z_neur * change)
boot.adhere <- boot(data = vigdata, statistic = mod.lm.boot, R = 1000, formula = z_adhere ~ z_age + Gender + z_neur * change)
boot.behavior <- boot(data = vigdata, statistic = mod.lm.boot, R = 1000, formula = behavior ~ z_age + Gender + z_neur * change)


mod.glm.boot <- function(data, indices, formula, fam) {
    d <- data[indices, ]
    fit <- glm(formula, data = d, family = fam)
    return(coef(fit))
}
# binary outcome: currently smoke
boot.smoke <- boot(data = vigdata, statistic = mod.glm.boot, R = 1000, formula = CigNow ~ z_age + Gender + z_neur * change, fam = "binomial")
# binary outcome: have chronic condition
boot.cond <- boot(data = vigdata, statistic = mod.glm.boot, R = 1000, formula = HC_binary ~ z_age + Gender + z_neur * change, fam = "binomial")


# outcomes
mod.srh <- lm(z_srh ~ z_age + Gender + z_neur * change, data = vigdata)
mod.bmi <- lm(z_bmi ~ z_age + Gender + z_neur * change, data = vigdata)
mod.num_cond <- lm(z_numcond ~ z_age + Gender + z_neur * change, data = vigdata)

mod.exercise <- lm(z_exercise ~ z_age + Gender + z_neur * change, data = vigdata)
mod.diet <- lm(z_diet ~ z_age + Gender + z_neur * change, data = vigdata)
mod.alcohol <- lm(z_alcohol ~ z_age + Gender + z_neur * change, data = vigdata)
mod.drinks <- lm(z_drinks ~ z_age + Gender + z_neur * change, data = vigdata)
mod.binge <- lm(z_binge ~ z_age + Gender + z_neur * change, data = vigdata)
mod.drug <- lm(z_drug ~ z_age + Gender + z_neur * change, data = vigdata)
mod.adhere <- lm(z_adhere ~ z_age + Gender + z_neur * change, data = vigdata)
mod.behavior <- lm(behavior ~ z_age + Gender + z_neur * change, data = vigdata)

mod.smoke <- glm(CigNow ~ z_age + Gender + z_neur * change, fam = "binomial", data = vigdata)
mod.cond <- glm(HC_binary ~ z_age + Gender + z_neur * change, fam = "binomial", data = vigdata)

boot.coef = list(mod.srh = boot.srh$t0, mod.bmi = boot.bmi$t0, mod.cond = boot.cond$t0, 
                 mod.exercise = boot.exercise$t0, mod.diet = boot.diet$t0, mod.alcohol = boot.alcohol$t0, 
                 mod.drinks = boot.drinks$t0, mod.binge = boot.binge$t0, mod.smoke = boot.smoke$t0, 
                 mod.drug = boot.drug$t0, mod.adhere = boot.adhere$t0, mod.behavior = boot.behavior$t0)
num.coef = length(boot.srh$t0)

srh.ci = matrix(nrow = num.coef, ncol = 2, rep(0, 2 * num.coef))
bmi.ci = matrix(nrow = num.coef, ncol = 2, rep(0, 2 * num.coef))
num_cond.ci = matrix(nrow = num.coef, ncol = 2, rep(0, 2 * num.coef))
exercise.ci = matrix(nrow = num.coef, ncol = 2, rep(0, 2 * num.coef))
diet.ci = matrix(nrow = num.coef, ncol = 2, rep(0, 2 * num.coef))
alcohol.ci = matrix(nrow = num.coef, ncol = 2, rep(0, 2 * num.coef))
drinks.ci = matrix(nrow = num.coef, ncol = 2, rep(0, 2 * num.coef))
binge.ci = matrix(nrow = num.coef, ncol = 2, rep(0, 2 * num.coef))
drug.ci = matrix(nrow = num.coef, ncol = 2, rep(0, 2 * num.coef))
adhere.ci = matrix(nrow = num.coef, ncol = 2, rep(0, 2 * num.coef))
behavior.ci = matrix(nrow = num.coef, ncol = 2, rep(0, 2 * num.coef))
smoke.ci = matrix(nrow = num.coef, ncol = 2, rep(0, 2 * num.coef))
cond.ci = matrix(nrow = num.coef, ncol = 2, rep(0, 2 * num.coef))

for (i in 1:num.coef) {
    for (j in 1:2){
      srh.ci[i, j] <- boot.ci(boot.srh, type = "perc", index = i)$percent[j + 3]
      bmi.ci[i, j] <- boot.ci(boot.bmi, type = "perc", index = i)$percent[j + 3]
      num_cond.ci[i, j] <- boot.ci(boot.num_cond, type = "perc", index = i)$percent[j + 3]
      exercise.ci[i, j] <- boot.ci(boot.exercise, type = "perc", index = i)$percent[j + 3]
      diet.ci[i, j] <- boot.ci(boot.diet, type = "perc", index = i)$percent[j + 3]
      alcohol.ci[i, j] <- boot.ci(boot.alcohol, type = "perc", index = i)$percent[j + 3]
      drinks.ci[i, j] <- boot.ci(boot.drinks, type = "perc", index = i)$percent[j + 3]
      binge.ci[i, j] <- boot.ci(boot.binge, type = "perc", index = i)$percent[j + 3]
      drug.ci[i, j] <- boot.ci(boot.drug, type = "perc", index = i)$percent[j + 3]
      adhere.ci[i, j] <- boot.ci(boot.adhere, type = "perc", index = i)$percent[j + 3]
      behavior.ci[i, j] <- boot.ci(boot.behavior, type = "perc", index = i)$percent[j + 3]
      smoke.ci[i, j] <- boot.ci(boot.smoke, type = "perc", index = i)$percent[j + 3]
      cond.ci[i, j] <- boot.ci(boot.cond, type = "perc", index = i)$percent[j + 3]
    }
}

boot.ci = list(mod.srh = srh.ci, mod.bmi = bmi.ci, mod.cond = cond.ci, 
               mod.exercise = exercise.ci, mod.diet = diet.ci, mod.alcohol = alcohol.ci, 
               mod.drinks = drinks.ci, mod.binge = binge.ci, mod.smoke = smoke.ci, 
               mod.drug = drug.ci, mod.adhere = adhere.ci, mod.behavior = behavior.ci)

# ---- explore1-table-extra----
stargazer(mod.srh, mod.bmi, mod.cond, mod.exercise, mod.diet, mod.alcohol,
          coef = boot.coef[1:6], ci.custom = boot.ci[1:6], intercept.bottom = F, intercept.top = T, 
          font.size = "tiny", 
          dep.var.labels = c("Self-Rated Health", "BMI", "Chronic Conditions", "Exercise", 
                             "Healthy Eating", "Alcohol Consumption"), 
          covariate.labels = c("Intercept", "Age", "Gender", "Neuroticism", "change", "Neuroticism x change"), 
          digits = 2, star.cutoffs = c(0.05, NA, NA), out = "tables/explore1_1.tex")

stargazer(mod.drinks, mod.binge, mod.smoke, mod.drug, mod.adhere, mod.behavior,
          coef = boot.coef[7:12], ci.custom = boot.ci[7:12], intercept.bottom = F, intercept.top = T, 
          font.size = "tiny", 
          dep.var.labels = c("Days Consumed Alcohol", "Days Binged Alcohol", 
                             "Illicit Drug Use", "Medication Nonadherence", "Healthy Behavior"), 
          covariate.labels = c("Intercept", "Age", "Gender", "Neuroticism", "change", "Neuroticism x change"), 
          digits = 2, star.cutoffs = c(0.05, NA, NA), out = "tables/explore1_2.tex")

# ---- explore1-graph sig----

sjp.int(mod.diet, swap.pred = T, mdrt.values = "meansd")

sjp.int(mod.alcohol, swap.pred = T, mdrt.values = "meansd")

# ---- explore2----

cor_hc_binary <- psych::biserial(vigdata$neuroticism, vigdata$HC_binary)[1,1]

cor_hc_count <- cor(vigdata$neuroticism, vigdata$HC_count, use = "pairwise")

boot.binary.sensation1 <- boot(data = vigdata, statistic = mod.lm.boot, R = 1000, formula = sensation ~ z_age + Gender + z_neur + HC_binary)
boot.binary.sensation2 <- boot(data = vigdata, statistic = mod.lm.boot, R = 1000, formula = sensation ~ z_age + Gender + z_neur * HC_binary)
boot.binary.change1 <- boot(data = vigdata, statistic = mod.lm.boot, R = 1000, formula = change ~ z_age + Gender + z_neur + HC_binary)
boot.binary.change2 <- boot(data = vigdata, statistic = mod.lm.boot, R = 1000, formula = change ~ z_age + Gender + z_neur * HC_binary)

boot.num.sensation1 <- boot(data = vigdata, statistic = mod.lm.boot, R = 1000, formula = sensation ~ z_age + Gender + z_neur + HC_count)
boot.num.sensation2 <- boot(data = vigdata, statistic = mod.lm.boot, R = 1000, formula = sensation ~ z_age + Gender + z_neur * HC_count)
boot.num.change1 <- boot(data = vigdata, statistic = mod.lm.boot, R = 1000, formula = change ~ z_age + Gender + z_neur + HC_count)
boot.num.change2 <- boot(data = vigdata, statistic = mod.lm.boot, R = 1000, formula = change ~ z_age + Gender + z_neur * HC_count)

mod.b.sensation1 = lm(sensation ~ z_age + Gender + z_neur + HC_binary, data = vigdata)
mod.b.sensation2 = lm(sensation ~ z_age + Gender + z_neur * HC_binary, data = vigdata)
mod.b.change1 = lm(change ~ z_age + Gender + z_neur + HC_binary, data = vigdata)
mod.b.change2 = lm(change ~ z_age + Gender + z_neur * HC_binary, data = vigdata)

mod.n.sensation1 = lm(sensation ~ z_age + Gender + z_neur + HC_count, data = vigdata)
mod.n.sensation2 = lm(sensation ~ z_age + Gender + z_neur * HC_count, data = vigdata)
mod.n.change1 = lm(change ~ z_age + Gender + z_neur + HC_count, data = vigdata)
mod.n.change2 = lm(change ~ z_age + Gender + z_neur * HC_count, data = vigdata)

boot.coef = list(mod.b.sensation1 = boot.binary.sensation1$t0, 
                 mod.b.sensation2 = boot.binary.sensation2$t0, 
                 mod.b.change1 = boot.binary.change1$t0, 
                 mod.b.change2 = boot.binary.change2$t0, 
                 mod.n.sensation1 = boot.num.sensation1$t0, 
                 mod.n.sensation2 = boot.num.sensation2$t0, 
                 mod.n.change1 = boot.num.change1$t0,
                 mod.n.change2 = boot.num.change2$t0)

num.coef = length(boot.binary.sensation2$t0)

b.sensation1.ci = matrix(nrow = num.coef, ncol = 2, rep(0, 2 * num.coef-1))
b.sensation2.ci = matrix(nrow = num.coef, ncol = 2, rep(0, 2 * num.coef))
b.change1.ci = matrix(nrow = num.coef, ncol = 2, rep(0, 2 * num.coef-1))
b.change2.ci = matrix(nrow = num.coef, ncol = 2, rep(0, 2 * num.coef))
n.sensation1.ci = matrix(nrow = num.coef, ncol = 2, rep(0, 2 * num.coef-1))
n.sensation2.ci = matrix(nrow = num.coef, ncol = 2, rep(0, 2 * num.coef))
n.change1.ci = matrix(nrow = num.coef, ncol = 2, rep(0, 2 * num.coef-1))
n.change2.ci = matrix(nrow = num.coef, ncol = 2, rep(0, 2 * num.coef))

for (i in 1:num.coef) {
    for (j in 1:2){ 
      
      if(i < 6){
        b.sensation1.ci[i, j] <- boot.ci(boot.binary.sensation1, type = "perc", index = i)$percent[j + 3]
        b.change1.ci[i, j] <- boot.ci(boot.binary.change1, type = "perc", index = i)$percent[j + 3]
        n.sensation1.ci[i, j] <- boot.ci(boot.num.sensation1, type = "perc", index = i)$percent[j + 3]
        n.change1.ci[i, j] <- boot.ci(boot.num.change1, type = "perc", index = i)$percent[j + 3]
      }
      b.sensation2.ci[i, j] <- boot.ci(boot.binary.sensation2, type = "perc", index = i)$percent[j + 3]
      b.change2.ci[i, j] <- boot.ci(boot.binary.change2, type = "perc", index = i)$percent[j + 3]
      n.sensation2.ci[i, j] <- boot.ci(boot.num.sensation2, type = "perc", index = i)$percent[j + 3]
      n.change2.ci[i, j] <- boot.ci(boot.num.change2, type = "perc", index = i)$percent[j + 3]
      
    }
    
}

boot.ci = list(mod.b.sensation1 = b.sensation1.ci, 
               mod.b.sensation2 = b.sensation2.ci, 
               mod.b.change1 = b.change1.ci, 
               mod.b.change2 = b.change2.ci, 
               mod.n.sensation1 = n.sensation1.ci, 
               mod.n.sensation2 = n.sensation2.ci, 
               mod.n.change1 = n.change1.ci,
               mod.n.change2 = n.change2.ci)


stargazer(mod.b.sensation1, mod.b.sensation2, mod.b.change1, mod.b.change2, 
          mod.n.sensation1, mod.n.sensation2, mod.n.change1, mod.n.change2, 
          coef = boot.coef, ci.custom = boot.ci, 
          intercept.bottom = F, intercept.top = T, font.size = "tiny", 
          covariate.labels = c("Intercept", "Age", "Gender", "Neuroticism", 
                               "Conditions (binary)", "Neur x Cond (binary)", 
                               "Conditions (count)", "Neur x Cond (count)"),
    digits = 2, 
    star.cutoffs = c(0.05, NA, NA), out = "tables/explore2.tex")


