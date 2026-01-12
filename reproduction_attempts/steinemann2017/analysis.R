#####################################################################################################
#Interactive Narratives Affecting Social Change: A Closer Look at the Relationship between Interactivity and Prosocial Behavior
#Summer 2016
#Created by M.Sc.Sharon Steinemann, University of Basel
#Contact: sharon.steinemann@unibas.ch
#####################################################################################################
#READING IN THE DATA

#set working directory
setwd("set working directory here")

#load data
data <- read.csv("InteractiveNarratives_Dataset used for Analysis in R.csv")

#check sample size
nrow(data) #1278 (incl. dropouts & testrounds of us researchers & incorrect bogus item answers & techn. difficulties)

#####################################################################################################
#####################################################################################################
#DATA EXCLUSION

  # We promised to exclude participants according to these criteria:
  # Technical issues
  # Dropping Out
  # Participating more than once
  # Bogus item incorrectly answered
  # Outliers in completion time (+/- 3 SD from completion time mean)
  # Indicated that they did not carefully answer study questions
  # Text comprehension questions: exclude participants who answer less than 3 out of 6 of our text comprehension questions correctly
  
      #Exclusion by criteria defined in Prereg
      data<- data[!data$Include=="no - test insti",] #our testing rounds
      nrow(data) #1114
      data<- data[!data$storyoff_yn==-77,] #dropouts
      nrow(data) #854
      data<- data[data$BogusItem==7,] # bogus item
      nrow(data) #796
      data<- data[!data$Include=="no - no tracking",] #no tracking
      nrow(data) #789
      data <- data[-which(data$duration>3*sd(data$duration)), ] #3 sd away from mean in completion time
      nrow(data) #708
      data<- data[!data$Data_quality_carefully_answered==2,] # self-indication whether careful or not
      nrow(data) #699
      data<- data[!data$Data_quality_participated_morethanonce==1,] # indicated that they participated more than once
      nrow(data) #674
      data<- data[!data$textcomp < 3,] # must have 3 or more of 6 text comprehension questions right.
      nrow(data) #634
      
      #View(data) #look at the data, opens in new studio tab
      
      #colnames(data)  #look at all the columns
#####################################################################################################
#####################################################################################################
#VARIABLE CODING

  ############################################
  # DVs: Re-poling reverse items & Creating variable sums 

      ######################
      #1. Re-poling reverse items
    
        #empco
        # 1.1 Umpolen von empco items, 7 point scale
        head(data$EmpathicConcern_2_R)
        which(colnames(data)=="EmpathicConcern_2_R") # 5
        data["EmpathicConcern_2_korr"] <- NA
        data$EmpathicConcern_2_korr <- 8 - data$EmpathicConcern_2_R
        data$EmpathicConcern_2_R <- data$EmpathicConcern_2_korr
        head(data$EmpathicConcern_2_R)
        
        head(data$EmpathicConcern_5_R)
        which(colnames(data)=="EmpathicConcern_5_R") # 8
        data["EmpathicConcern_5_R_korr"] <- NA
        data$EmpathicConcern_5_R_korr <- 8 - data$EmpathicConcern_5_R
        data$EmpathicConcern_5_R <- data$EmpathicConcern_5_R_korr
        head(data$EmpathicConcern_5_R)
        
        head(data$EmpathicConcern_6_R)
        which(colnames(data)=="EmpathicConcern_6_R") # 9
        data["EmpathicConcern_6_R_korr"] <- NA
        data$EmpathicConcern_6_R_korr <- 8 - data$EmpathicConcern_6_R
        data$EmpathicConcern_6_R <- data$EmpathicConcern_6_R_korr
        head(data$EmpathicConcern_6_R)
        
        #nareng
        # 1.2 Umpolen von nareng items, 7 point scale
        head(data$NarrativeEngagement_1_R)
        which(colnames(data)=="NarrativeEngagement_1_R") # 5
        data["NarrativeEngagement_1_R_korr"] <- NA
        data$NarrativeEngagement_1_R_korr <- 8 - data$NarrativeEngagement_1_R
        data$NarrativeEngagement_1_R <- data$NarrativeEngagement_1_R_korr
        head(data$NarrativeEngagement_1_R)
        
        head(data$NarrativeEngagement_2_R)
        which(colnames(data)=="NarrativeEngagement_2_R") # 9
        data["NarrativeEngagement_2_R_korr"] <- NA
        data$NarrativeEngagement_2_R_korr <- 8 - data$NarrativeEngagement_2_R
        data$NarrativeEngagement_2_R <- data$NarrativeEngagement_2_R_korr
        head(data$NarrativeEngagement_2_R)   
        
        head(data$NarrativeEngagement_3_R)
        which(colnames(data)=="NarrativeEngagement_3_R") # 9
        data["NarrativeEngagement_3_R_korr"] <- NA
        data$NarrativeEngagement_3_R_korr <- 8 - data$NarrativeEngagement_3_R
        data$NarrativeEngagement_3_R <- data$NarrativeEngagement_3_R_korr
        head(data$NarrativeEngagement_3_R)            
        
        head(data$NarrativeEngagement_4_R)
        which(colnames(data)=="NarrativeEngagement_4_R") # 9
        data["NarrativeEngagement_4_R_korr"] <- NA
        data$NarrativeEngagement_4_R_korr <- 8 - data$NarrativeEngagement_4_R
        data$NarrativeEngagement_4_R <- data$NarrativeEngagement_4_R_korr
        head(data$NarrativeEngagement_4_R)
        
        head(data$NarrativeEngagement_5_R)
        which(colnames(data)=="NarrativeEngagement_5_R") # 9
        data["NarrativeEngagement_5_R_korr"] <- NA
        data$NarrativeEngagement_5_R_korr <- 8 - data$NarrativeEngagement_5_R
        data$NarrativeEngagement_5_R <- data$NarrativeEngagement_5_R_korr
        head(data$NarrativeEngagement_5_R)
        
        head(data$NarrativeEngagement_6_R)
        which(colnames(data)=="NarrativeEngagement_6_R") # 9
        data["NarrativeEngagement_6_R_korr"] <- NA
        data$NarrativeEngagement_6_R_korr <- 8 - data$NarrativeEngagement_6_R
        data$NarrativeEngagement_6_R <- data$NarrativeEngagement_6_R_korr
        head(data$NarrativeEngagement_6_R)            
    
      ######################
      #2. Creating variable sums 
    
        # 2.1 empco
        #Creating empco variable sums
        data["empco"] <- NA
        data$empco <- rowMeans(data[,14:20]) #IMPORTANT: CHECK THAT THESE ROW NUMBERS ARE STILL ACCURATE!
        # Cronbach's Alpha
        library(ltm)
        cronbach.empco <- data[,14:20]
        cronbach.alpha(cronbach.empco)
        
        
        # 2.2 nareng
        #Creating nareng variable sums
        data["nareng"] <- NA
        data$nareng <- rowMeans(data[,41:52])  #IMPORTANT: CHECK THAT THESE ROW NUMBERS ARE STILL ACCURATE!         
        head(data$nareng)
        
        cronbach.nareng <- data[,41:52]
        cronbach.alpha(cronbach.nareng)
        
        #2.3 enjoyment            
        # Creating enjoyment variable sums
        data["enjoyment"] <- NA
        data$enjoyment <- rowMeans(data[,38:40]) #IMPORTANT: CHECK THAT THESE ROW NUMBERS ARE STILL ACCURATE!          
        head(data$enjoyment) 
        
        cronbach.enjoyment <- data[,38:40]
        cronbach.alpha(cronbach.enjoyment)
        
        #2.4 appreciation            
        # Creating appreciation variable sums
        data["appreciation"] <- NA
        data$appreciation <- rowMeans(data[,35:37]) #IMPORTANT: CHECK THAT THESE ROW NUMBERS ARE STILL ACCURATE!          
        head(data$appreciation)  
        
        cronbach.appreciation <- data[,35:37]
        cronbach.alpha(cronbach.appreciation)
        
        #2.5 identification            
        # Creating identification variable sums
        data["identification"] <- NA
        data$identification <- rowMeans(data[,23:32])  #IMPORTANT: CHECK THAT THESE ROW NUMBERS ARE STILL ACCURATE!         
        head(data$identification)              
        
        cronbach.identification <- data[,23:32]
        cronbach.alpha(cronbach.identification)
        
        #2.6 responsibility            
        # Creating responsibility variable sums
        data["responsibility"] <- NA
        data$responsibility <- rowMeans(data[,33:34]) #IMPORTANT: CHECK THAT THESE ROW NUMBERS ARE STILL ACCURATE!          
        head(data$responsibility)                         
        
        cronbach.responsibility <- data[,33:34]
        cronbach.alpha(cronbach.responsibility)
        
        #2.7 donation            
        # replacing 1s with 0s
        head(data$percentagedonated)
        data["donation"] <- NA
        data$donation <- data$percentagedonated    
        head(data$donation)
        data$donation[data$donation==1] <- 0
        head(data$donation)
        data$donation <- data$donation/100
        head(data$donation)

  ############################################
  # DVs & CVs: making sure the dependent variables are recognized as numeric. 
  #If not, check "," in csv (left or right bound)        

    class(data$textcomp)
    
    class(data$empco)
    class(data$enjoyment)
    class(data$nareng)
    
    class(data$identification)
    class(data$responsibility)
    class(data$appreciation)
    
    class(data$donation)

  ############################################
  # IV: Defining condition
    
    data["condition"] <- NA
    data$condition <- data$Condition_Tracking
    data$condition[data$condition == "Nicht Interaktiv" ] <- 1
    data$condition[data$condition == "Interaktiv" ] <- 2
    
    nlevels(data$condition)
    class(data$condition)
    #Making sure the independent variables' levels are identified. This turns condition into a factor (not numeric anymore). If you need a numeric vector, just leave this step out.
    data$condition <- factor(data$condition,
                             levels = c(1,2),
                             labels = c("noninteractive", "interactive"))
    nlevels(data$condition)

#####################################################################################################
#####################################################################################################
  #DETECTING OUTLYERS
    # We promised to:
    # Look at outliers of all other variables:  +/- 3 SD from the mean -> winsorize  (threshold: 95%) with the R package robustHD
    
  ############################################
  #Univariate Winsorization
    # Code for winsorization:
    # Winsorize Data mit winsorize(x)
      library(robustHD)
      
      boxplot(data$empco, main ="empco", col= "#D55E00") # outliers --> winsorize
      mean(data$empco)
      data$empco <- winsorize(data$empco)
      mean(data$empco)
      boxplot(data$empco, main ="empco", col= "#D55E00")
      
      boxplot(data$enjoyment, main ="enjoyment", col= "#D55E00") # no outliers --> do not winsorize
      #mean(data$enjoyment)
      #data$enjoyment <- winsorize(data$enjoyment)
      #mean(data$enjoyment)
      #boxplot(data$enjoyment, main ="enjoyment", col= "#D55E00")
      
      boxplot(data$nareng, main ="nareng", col= "#D55E00")  # outliers --> winsorize
      mean(data$nareng)
      data$nareng <- winsorize(data$nareng)
      mean(data$nareng)
      boxplot(data$nareng, main ="nareng", col= "#D55E00")
      
      boxplot(data$identification, main ="identification", col= "#D55E00") # outliers --> winsorize
      mean(data$identification)
      data$identification <- winsorize(data$identification)
      mean(data$identification)
      boxplot(data$identification, main ="identification", col= "#D55E00")
      
      
      boxplot(data$responsibility, main ="responsibility", col= "#D55E00")  # no outliers --> do not winsorize
      #mean(data$responsibility)
      #data$responsibility <- winsorize(data$responsibility)
      #mean(data$responsibility)
      #boxplot(data$responsibility, main ="responsibility", col= "#D55E00")
      
      boxplot(data$appreciation, main ="appreciation", col= "#D55E00") # outliers --> winsorize
      mean(data$appreciation)
      data$appreciation <- winsorize(data$appreciation)
      mean(data$appreciation)
      boxplot(data$appreciation, main ="appreciation", col= "#D55E00")
      
      boxplot(data$donation, main ="donation", col= "#D55E00") # no outliers --> do not winsorize
      #mean(data$donation)
      #data$donation <- winsorize(data$donation)
      #mean(data$donation)
      #boxplot(data$donation, main ="donation", col= "#D55E00")
  
    
  ############################################
  # Outliers according to Mahalanobis distance
      library(mvoutlier)
      # create data, without donation:
      x <- cbind(data$responsibility, data$identification, data$appreciation, data$enjoyment, data$nareng, data$empco)
      # execute:
      dd.plot(x)$outliers
      
      #outliers with donation
      y <- cbind(data$responsibility, data$identification, data$appreciation, data$enjoyment, data$nareng, data$empco, data$donation)
      #execute:
      dd.plot(y)$outliers
  
#####################################################################################################
#####################################################################################################
#TESTING FOR NORMALITY

    
  ############################################    
  #1 QQ-Plots
    #http://data.library.virginia.edu/understanding-q-q-plots/
    #several plots in one window
    par(mfrow=c(4,2),mar=c(3,2,2,2), oma=c(4,4,2,2))
    
    #donation
    qqnorm(data$donation, main = "donation:Normal Q-Q Plot",
           xlab = "Theoretical Quantiles", ylab = "Sample Quantiles",
           plot.it = TRUE, datax = FALSE)
    qqline(data$donation) # to add the line :)          
    
    #empco
    qqnorm(data$empco, main = "empco:Normal Q-Q Plot",
           xlab = "Theoretical Quantiles", ylab = "Sample Quantiles",
           plot.it = TRUE, datax = FALSE)
    qqline(data$empco) # to add the line :)
    
    #enjoyment
    qqnorm(data$enjoyment, main = "enjoyment:Normal Q-Q Plot",
           xlab = "Theoretical Quantiles", ylab = "Sample Quantiles",
           plot.it = TRUE, datax = FALSE)
    qqline(data$enjoyment) # to add the line :)
    
    #nareng
    qqnorm(data$nareng, main = "nareng:Normal Q-Q Plot",
           xlab = "Theoretical Quantiles", ylab = "Sample Quantiles",
           plot.it = TRUE, datax = FALSE)
    qqline(data$nareng) # to add the line :)
    
    #identification
    qqnorm(data$identification, main = "identification:Normal Q-Q Plot",
           xlab = "Theoretical Quantiles", ylab = "Sample Quantiles",
           plot.it = TRUE, datax = FALSE)
    qqline(data$identification) # to add the line :)
    
    #responsibility
    qqnorm(data$responsibility, main = "responsibility:Normal Q-Q Plot",
           xlab = "Theoretical Quantiles", ylab = "Sample Quantiles",
           plot.it = TRUE, datax = FALSE)
    qqline(data$responsibility) # to add the line :)
    
    #appreciation
    qqnorm(data$appreciation, main = "appreciation:Normal Q-Q Plot",
           xlab = "Theoretical Quantiles", ylab = "Sample Quantiles",
           plot.it = TRUE, datax = FALSE)
    qqline(data$appreciation) # to add the line :)
    
    #textcomp
    qqnorm(data$textcomp, main = "textcomp:Normal Q-Q Plot",
           xlab = "Theoretical Quantiles", ylab = "Sample Quantiles",
           plot.it = TRUE, datax = FALSE)
    qqline(data$textcomp) # to add the line :)
    
  ############################################
  #2 Histograms
    library(lattice)
    ?histogram
    cbPalette <- c("#0072B2", "#D55E00","#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#CC79A7")
    par(mfrow=c(4,2),mar=c(4,4,2,2), oma=c(4,4,2,2)))

      hist(data$donation, main ="donation", col= "#F0E442", breaks=11)
      
      hist(data$empco, main ="empco", col= "#E69F00", breaks=1:(max(data$empco)+1), xaxt="n", right=FALSE, freq=FALSE)
      axis(1, at=(1.5:7.5), labels=1:7)
      
      hist(data$enjoyment, main ="enjoyment", col= "#D55E00", breaks=1:(max(data$empco)+1), xaxt="n", right=FALSE, freq=FALSE)
      axis(1, at=(1.5:7.5), labels=1:7)
      
      hist(data$nareng, main ="nareng", col= "#CC79A7", breaks=1:(max(data$empco)+1), xaxt="n", right=FALSE, freq=FALSE)
      axis(1, at=(1.5:7.5), labels=1:7)
      
      hist(data$identification, main ="identification", col= "#0072B2", breaks=1:(max(data$empco)+1), xaxt="n", right=FALSE, freq=FALSE)
      axis(1, at=(1.5:7.5), labels=1:7)
      
      hist(data$responsibility, main ="responsibility", col= "#009E73", breaks=1:(max(data$empco)+1), xaxt="n", right=FALSE, freq=FALSE)
      axis(1, at=(1.5:7.5), labels=1:7)
      
      hist(data$appreciation, main ="appreciation", col= "#56B4E9", breaks=1:(max(data$empco)+1), xaxt="n", right=FALSE, freq=FALSE)
      axis(1, at=(1.5:7.5), labels=1:7)
      
      hist(data$textcomp, main ="textcomp", col= "#999999", breaks=1:(max(data$empco)+1), xaxt="n", right=FALSE, freq=FALSE)
      axis(1, at=(1.5:7.5), labels=1:7)

#####################################################################################################
#####################################################################################################
#TESTING FOR LINEARITY & HOMOSCEDASTICITY
      
  #Linearity         
      #1 Scatterplots
      #http://www.statmethods.net/graphs/scatterplot.html
      plot(data$donation, data$appreciation, main="donation:empco", xlab="donation ", ylab="empco", pch=19)
      
      # Basic Scatterplot Matrix
      pairs(data[155:161],main="Simple Scatterplot Matrix")
      
      # Scatterplot Matrices from the glus Package 
      #rearranges variables: higher correlations are closer to the principal diagonal. 
      #Color codes the cells to reflect the size of the correlations. 
      library(gclus)
      dta <- data[155:161] # get data 
      dta.r <- abs(cor(dta)) # get correlations
      dta.col <- dmat.color(dta.r) # get colors
      # reorder variables so those with highest correlation
      # are closest to the diagonal
      dta.o <- order.single(dta.r) 
      cpairs(dta, dta.o, panel.colors=dta.col, gap=.5,
             main="Variables Ordered and Colored by Correlation" )
      
      
   #Homoscedasticity
      
      #1 Residual Plot (Residuals Plotted against Predictor Variable)
        #Comment: Technically you should do this with your IV, not a predictor. But it only works if both variables are intervall scaled (which condition is not)
        #http://www.r-tutor.com/elementary-statistics/simple-linear-regression/residual-plot
        #http://docs.statwing.com/interpreting-residual-plots-to-improve-your-regression/
          par(mfrow=c(1,1),mar=c(3,2,2,2), oma=c(4,4,2,2))
          
          donation.lm = lm(donation ~ condition, data = data)
          donation.res = resid(donation.lm)
          
          plot(data$appreciation, donation.res,
               ylab="Residuals", xlab="Appreciation",
               main="Donation")
          abline(0,0) #the horizon
      
      
      #2  Density plots
      library(ggplot2)
        ggplot(data, aes(x=data$donation, colour=data$condition)) + geom_density()
        ggplot(data, aes(x=data$appreciation, colour=data$condition)) + geom_density()
        ggplot(data, aes(x=data$identification, colour=data$condition)) + geom_density()
        ggplot(data, aes(x=data$responsibility, colour=data$condition)) + geom_density()
        ggplot(data, aes(x=data$enjoyment, colour=data$condition)) + geom_density()
        ggplot(data, aes(x=data$empco, colour=data$condition)) + geom_density()
        ggplot(data, aes(x=data$nareng, colour=data$condition)) + geom_density()
        ggplot(data, aes(x=data$textcomp, colour=data$condition)) + geom_density()
      
      #3 Homogeneity of Variance 
        plot(donation ~ condition, data=data, main ="donation ~ condition")
        plot(appreciation ~ condition, data=data, main ="appreciation ~ condition")
        plot(identification ~ condition, data=data, main ="identification ~ condition")
        plot(responsibility ~ condition, data=data, main ="responsibility ~ condition")
        plot(enjoyment ~ condition, data=data, main ="enjoyment ~ condition")
        plot(empco ~ condition, data=data, main ="empco ~ condition")
        plot(nareng ~ condition, data=data, main ="nareng ~ condition")
        plot(textcomp ~ condition, data=data, main ="textcomp ~ condition")
      
      #4  Individual Levene Tests
      library(car)
        leveneTest(donation ~ condition, data=data)
        leveneTest(appreciation ~ condition, data=data)
        leveneTest(identification ~ condition, data=data)
        leveneTest(responsibility ~ condition, data=data)
        leveneTest(enjoyment ~ condition, data=data)
        leveneTest(empco ~ condition, data=data)
        leveneTest(nareng ~ condition, data=data) 
        leveneTest(textcomp ~ condition, data=data) 
      
      
#####################################################################################################      
#####################################################################################################
#POTENTIAL CONFOUNDING EFFECTS: PLATFORM AND/OR TEXT COMPREHENSION DIFFERENT BETWEEN GROUPS?
      
  # Do MTurk and Crowdflower users react differently to the conditions?
    
    # 2x2 Factorial MANOVA with 3 Dependent Variables. 
    Y <- cbind(data$donation,data$identification,data$responsibility,data$appreciation)
    fit <- manova(Y ~ data$MTurkorCrowdflower*data$condition)
    summary(fit, test="Pillai")
  
    
    # Two-way Interaction Plot 
    datacomp <- data[!data$MTurkorCrowdflower == 6,]
    datacomp$MTurkorCrowdflower[datacomp$MTurkorCrowdflower == -77] <- 2
    
    library(psych)
    describeBy(datacomp[155:161], datacomp$MTurkorCrowdflower) #DVs by condition
    condition <- factor(datacomp$condition)
    MTurkorCrowdflower <- factor(datacomp$MTurkorCrowdflower)
    interaction.plot(MTurkorCrowdflower, condition, datacomp$identification, type="b", col=c(1:3), 
                     leg.bty="o", leg.bg="beige", lwd=2, pch=c(18,24,22),	
                     xlab="MTurkorCrowdflower", 
                     ylab="Donation", 
                     main="Interaction Plot")
        
  # Did textcomp differ between to the conditions?
    #for textcomp by condition
    with(data, t.test(textcomp[condition == "interactive"], textcomp[condition == "noninteractive"], alternative="greater"))
     
    
    
#####################################################################################################
#####################################################################################################
#DESCRIPTIVE STATISTICS   
    
    #how many participants per condition?
    table(data$condition)
    
    
    ######################
    #CREATING A TABLE OF DESCRIPTIVE STATISTICS
    #hella complicated, but also hella awesome descriptive statistics:
    #source: https://cran.r-project.org/web/packages/apaStyle/apaStyle.pdf
    library(psych)
    library(apaStyle)
    
    #########
    #1 create two matrix of all descritive stats by condition
    descriptive.bycondition <- describeBy(data[155:161], data$condition) 
    descriptive.bycondition
    
    #########
    #2 separate the two matrix.
    ###
    #2.1 create matrix just for interactive
    descriptive.int = as.matrix(descriptive.bycondition[[2]][c(2,3,4)])
    descriptive.int
    class(descriptive.int)
    
    #2.2 create matrix just for noninteractive
    descriptive.nonint = as.matrix(descriptive.bycondition[[1]][c(2,3,4)])
    descriptive.nonint
    class(descriptive.nonint)
    
    
    #########
    #3 per condition, create vectors for means, sd, and n containing all DVs.
    
    #3.1 interactive: create vectors for means, sd, and n
    means.int <- c(
      descriptive.int["donation","mean"],
      descriptive.int["identification","mean"],
      descriptive.int["responsibility","mean"],
      descriptive.int["appreciation","mean"],
      descriptive.int["empco","mean"],
      descriptive.int["enjoyment","mean"],
      descriptive.int["nareng","mean"])
    
    sd.int <- c(
      descriptive.int["donation","sd"],
      descriptive.int["identification","sd"],
      descriptive.int["responsibility","sd"],
      descriptive.int["appreciation","sd"],
      descriptive.int["empco","sd"],
      descriptive.int["enjoyment","sd"],
      descriptive.int["nareng","sd"])
    
    n.int <- c(
      descriptive.int["donation","n"],
      descriptive.int["identification","n"],
      descriptive.int["responsibility","n"],
      descriptive.int["appreciation","n"],
      descriptive.int["empco","n"],
      descriptive.int["enjoyment","n"],
      descriptive.int["nareng","n"])
    
    #3.1 noninteractive: create vectors for mean, sd, and n
    means.nonint <- c(
      descriptive.nonint["donation","mean"],
      descriptive.nonint["identification","mean"],
      descriptive.nonint["responsibility","mean"],
      descriptive.nonint["appreciation","mean"],
      descriptive.nonint["empco","mean"],
      descriptive.nonint["enjoyment","mean"],
      descriptive.nonint["nareng","mean"])
    
    sd.nonint <- c(
      descriptive.nonint["donation","sd"],
      descriptive.nonint["identification","sd"],
      descriptive.nonint["responsibility","sd"],
      descriptive.nonint["appreciation","sd"],
      descriptive.nonint["empco","sd"],
      descriptive.nonint["enjoyment","sd"],
      descriptive.nonint["nareng","sd"])
    
    n.nonint <- c(
      descriptive.nonint["donation","n"],
      descriptive.nonint["identification","n"],
      descriptive.nonint["responsibility","n"],
      descriptive.nonint["appreciation","n"],
      descriptive.nonint["empco","n"],
      descriptive.nonint["enjoyment","n"],
      descriptive.nonint["nareng","n"])
    
    #########
    #4 THE DESCRIPTIVE STATISTICS TABLE
    
    #4.1 stick everything into a dataframe
    example <- data.frame(
      c("Donation", "Identification", "Responsibility", "Appreciation", "Empathic Concern", "Enjoyment", "Narrative Engagement"),
      means.int,
      sd.int,
      n.int,
      means.nonint,
      sd.nonint,
      n.nonint
    )
    
    options(digits=3) #technically, this means all DVs only have three digits in the end, but it only works partwise.
    
    # Run method and preview table
    apa.table(
      data = example,
      level1.header = c("", "Interactive Narrative", "Noninteractive Narrative"),
      level1.colspan = c(1, 3, 3), #aka 1 column belongs to "" (i.e."Variable"), 3 to "Interactive Narrative" (i.e. M, SD, and n), etc.
      level2.header = c("Variable", "M", "SD", "n", "M", "SD", "n")
    )$table
    
    
#####################################################################################################    
#####################################################################################################
#ASSESSING MULTICOLLINEARITY
    
    vif(lm(donation ~ identification + appreciation + nareng, data = data))
    
    1/vif(lm(donation ~ identification + appreciation + nareng, data = data))   
    
#####################################################################################################    
#####################################################################################################    
#DEMOGRAPHIC DATA  
    
  #Gender   
    data$Gender <- factor(data$Gender,
                          levels = c(1,2,3,4,5),
                          labels = c("Female", "Male", "Trans*", "Fill in the blank", "Prefer not to say"))
    
    summary(data$Gender)
    summary(data$gender_other)
    
  #Occupation
    data$Occupation_unemployed <- factor(data$Occupation_unemployed,
                                         levels = c(0,1),
                                         labels = c("No", "Yes"))
    
    summary(data$Occupation_unemployed)
    
    data$Occupation_student <- factor(data$Occupation_student,
                                      levels = c(0,1),
                                      labels = c("No", "Yes"))
    
    summary(data$Occupation_student)
    
    data$Occupation_bluecollar_service <- factor(data$Occupation_bluecollar_service,
                                                 levels = c(0,1),
                                                 labels = c("No", "Yes"))
    
    summary(data$Occupation_bluecollar_service)
    
    data$Occupation_clerical <- factor(data$Occupation_clerical,
                                       levels = c(0,1),
                                       labels = c("No", "Yes"))
    
    summary(data$Occupation_clerical)
    
    data$Occupation_selfemployed <- factor(data$Occupation_selfemployed,
                                           levels = c(0,1),
                                           labels = c("No", "Yes"))
    
    summary(data$Occupation_selfemployed)
    
    data$Occupation_professionalmanagerial <- factor(data$Occupation_professionalmanagerial,
                                                     levels = c(0,1),
                                                     labels = c("No", "Yes"))
    
    summary(data$Occupation_professionalmanagerial)
    
    data$Occupation_otheryn <- factor(data$Occupation_otheryn,
                                      levels = c(0,1),
                                      labels = c("No", "Yes"))
    
    summary(data$Occupation_otheryn)
    
    
    data["exphomeless"] <- NA
    data$exphomeless[data$LivedHomeless == 1] <- 1    
    data$exphomeless[data$LivedHomeless > 1] <- 0
    
    table(data$exphomeless)
    table(data$exphomeless, data$condition)
    
#####################################################################################################
#####################################################################################################
#CORRELATIONS
    par(mfrow=c(1,1),mar=c(4,4,2,2), oma=c(4,4,2,2))

    ##########
    #CORRELATION TABLE
    #http://www.sthda.com/english/wiki/elegant-correlation-table-using-xtable-r-package
    library(corrplot)
    
    #1. very simple table
    mcor<-round(cor(data[155:161]),2)
    mcor
    

    ################################
    #Add correlation stars for significant results
    library(Hmisc)
    
    #1. Create corstars function.
    corstars <-function(x, method=c("pearson", "spearman"), removeTriangle=c("upper", "lower"),
                        result=c("none", "html", "latex")){
      
      #Compute correlation matrix
      require(Hmisc)
      x <- as.matrix(x)
      correlation_matrix<-rcorr(x, type=method[2])
      R <- correlation_matrix$r # Matrix of correlation coeficients
      p <- correlation_matrix$P # Matrix of p-value 
      
      ## Define notions for significance levels; spacing is important.
      mystars <- ifelse(p < .0001, "****", ifelse(p < .001, "*** ", ifelse(p < .01, "**  ", ifelse(p < .05, "*   ", "    "))))
      
      ## trunctuate the correlation matrix to two decimal
      R <- format(round(cbind(rep(-1.11, ncol(x)), R), 2))[,-1]
      
      ## build a new matrix that includes the correlations with their apropriate stars
      Rnew <- matrix(paste(R, mystars, sep=""), ncol=ncol(x))
      diag(Rnew) <- paste(diag(R), " ", sep="")
      rownames(Rnew) <- colnames(x)
      colnames(Rnew) <- paste(colnames(x), "", sep="")
      
      ## remove upper triangle of correlation matrix
      if(removeTriangle[1]=="upper"){
        Rnew <- as.matrix(Rnew)
        Rnew[upper.tri(Rnew, diag = TRUE)] <- ""
        Rnew <- as.data.frame(Rnew)
      }
      
      ## remove lower triangle of correlation matrix
      else if(removeTriangle[1]=="lower"){
        Rnew <- as.matrix(Rnew)
        Rnew[lower.tri(Rnew, diag = TRUE)] <- ""
        Rnew <- as.data.frame(Rnew)
      }
      
      ## remove last column and return the correlation matrix
      Rnew <- cbind(Rnew[1:length(Rnew)-1])
      if (result[1]=="none") return(Rnew)
      else{
        if(result[1]=="html") print(xtable(Rnew), type="html")
        else print(xtable(Rnew), type="latex") 
      }
      
    } 
    
    #2 Print out the table.
    library(Hmisc)
    corstars(data[,155:161], result="latex") 
    corstars(data[,155:161], result="html") #e.g. here: http://htmledit.squarefree.com/

    
    ####################### 
    #INDIVIDUAL CORRELATIONS        
    
    #Pearson
    #linear relationship, bivariate normal distribution.
    cor.test(data$appreciation, data$donation)
    
    cor.test(data$appreciation, data$donation,
             alternative="greater",
             method= "pearson")    
    #Spearman 
    #interpret rho similar to r
    #http://www.statstutor.ac.uk/resources/uploaded/spearmans.pdf
    cor.test(data$identification, data$donation,
             alternative="greater",
             method= "spearman")    
    
#####################################################################################################
#####################################################################################################
#COVARIANCE MATRIX
    # http://stats.seandolinar.com/making-a-covariance-matrix-in-r/
    #http://www.r-tutor.com/elementary-statistics/numerical-measures/covariance
    library(corrplot)
    
    M2 <- cov(data[155:161], method =c("spearman"))
    M2
    
#####################################################################################################
#####################################################################################################
#PATHWAY ANALYSIS
    #useful resources:
    #https://www.youtube.com/watch?v=-B37sK9NTfI&index=3&list=PLFC6gleWgf9sYSqx1ROJI7IR_CRNqMxaQ
    #http://lavaan.ugent.be/tutorial/cfa.html
    
    
    library(lavaan)
    #library(qgraph)
    #library(semPlot)      
    
    
    
    # model 1: impact of condition (interactive vs noninteractive) on donation
    model1 <- ' 		  donation ~  condition '
    
    fit1 <- sem(model1, data = data,fixed.x=FALSE)
    residuals(fit1)
    summary(fit1, fit.measures=T, standardized=T)
    mi = modificationIndices(fit1)
    head(mi[order(-mi$mi), ], 10)
    
    
    
    # model_orig: Original Model in Figure 2
    
    model_orig <- 'donation ~ condition + identification + responsibility + appreciation + empco + enjoyment + nareng
    identification ~ condition + empco + enjoyment + nareng
    responsibility ~ condition + empco + enjoyment + nareng
    appreciation ~ condition + empco + enjoyment + nareng
    identification ~~ appreciation
    identification ~~ responsibility
    responsibility ~~ appreciation
    empco ~~ 0*condition
    empco ~~ enjoyment
    empco ~~ nareng
    nareng ~~ enjoyment
    enjoyment ~~ 0*condition
    nareng ~~ 0*condition'
    
    fit_orig <- sem(model_orig, data = data,fixed.x=FALSE, test = "satorra.bentler", se="bootstrap")
    residuals(fit_orig)
    summary(fit_orig, fit.measures=T, standardized=T)
    mi = modificationIndices(fit_orig)
    head(mi[order(-mi$mi), ], 10)
    
    
#####################################################################################################    
#The Importance of the Control Variables   
    
    
    CorrDiff <- function(fit.baseline, fit.restricted){
      Corrc2Base <- fitMeasures(fit.baseline)[[6]] # extrahiert aus den zu vergleichenden Modellen den korrigierten sowie den unkorrigierten Chi-Quadrat-Wert & die dazu gehörige df und weist diese dem Objekt Corrc2Base zu
      MLc2Base <- fitMeasures(fit.baseline)[[2]]
      dfBase <- fitMeasures(fit.baseline)[[7]]
      Corrc2Rest <- fitMeasures(fit.restricted)[[6]]
      MLc2Rest <- fitMeasures(fit.restricted)[[2]]
      dfRest <- fitMeasures(fit.restricted)[[7]]
      c0 <- MLc2Rest / Corrc2Rest # Korrekturwer wird hier berechnet, mit dem die Chi-Quadrat-Differenz korrigiert wird
      c1 <- MLc2Base / Corrc2Base # Korrekturwer wird hier berechnet, mit dem die Chi-Quadrat-Differenz korrigiert wird
      cd <- (dfRest*c0-dfBase*c1)/(dfRest-dfBase) # Korrekturwer wird hier berechnet, mit dem die Chi-Quadrat-Differenz korrigiert wird
      CorrDiff <- (MLc2Rest-MLc2Base)/cd
      dfDiff <- dfRest - dfBase
      pDiff <- 1-pchisq(CorrDiff, dfDiff)
      result <- list(Corr.chisq.difference = CorrDiff,
                     df.difference=dfDiff, p.value=pDiff)
      return(result)
    }
    
    
    
    # model_nocontrol: Model with control paths set to 0
    
    model_nocontrol <- 'donation ~ condition + identification + responsibility + appreciation + 0*empco + 0*enjoyment + 0*nareng
    identification ~ condition + 0*empco + 0*enjoyment + 0*nareng
    responsibility ~ condition + 0*empco + 0*enjoyment + 0*nareng
    appreciation ~ condition + 0*empco + 0*enjoyment + 0*nareng
    identification ~~ appreciation
    identification ~~ responsibility
    responsibility ~~ appreciation
    empco ~~ 0*condition
    empco ~~ 0*enjoyment
    empco ~~ 0*nareng
    nareng ~~ 0*enjoyment
    enjoyment ~~ 0*condition
    nareng ~~ 0*condition'
    
    fit_nocontrol <- sem(model_nocontrol, data = data,fixed.x=FALSE, test = "satorra.bentler", se="bootstrap")
    residuals(fit_nocontrol)
    summary(fit_nocontrol, fit.measures=T, standardized=T)
    mi = modificationIndices(fit_nocontrol)
    head(mi[order(-mi$mi), ], 10)   
    
    
    
    CorrDiff(fit_orig, fit_nocontrol)
    
    
    

    
#####################################################################################################    
  #Understanding the negative relationship between identification and donation: the effect of
    #experiencing homelessness one's self

    
    
    # model_exphomeless: Original Model with the addition of exphomeless
    model_exphomeless <- 'donation ~ condition + identification + responsibility + appreciation + empco + enjoyment + nareng + exphomeless
    identification ~ condition + empco + enjoyment + nareng + exphomeless
    responsibility ~ condition + empco + enjoyment + nareng + exphomeless
    appreciation ~ condition + empco + enjoyment + nareng + exphomeless
    identification ~~ appreciation
    identification ~~ responsibility
    responsibility ~~ appreciation
    empco ~~ enjoyment
    empco ~~ nareng
    empco ~~ exphomeless
    nareng ~~ enjoyment
    nareng ~~ exphomeless
    enjoyment ~~ exphomeless
    empco ~~ 0*condition
    enjoyment ~~ 0*condition
    nareng ~~ 0*condition'
    
    fit_exphomeless <- sem(model_exphomeless, data = data,fixed.x=FALSE, test = "satorra.bentler", se="bootstrap")
    residuals(fit_exphomeless)
    summary(fit_exphomeless, fit.measures=T, standardized=T)
    mi = modificationIndices(fit_exphomeless)
    head(mi[order(-mi$mi), ], 10) 
    
    
    # model_exphomeless2: take out nonsig relationships with exphomeless
    model_exphomeless2 <- 'donation ~ condition + identification + responsibility + appreciation + empco + enjoyment + nareng + exphomeless
    identification ~ condition + empco + enjoyment + nareng + exphomeless
    responsibility ~ condition + empco + enjoyment + nareng + 0*exphomeless
    appreciation ~ condition + empco + enjoyment + nareng + 0*exphomeless
    identification ~~ appreciation
    identification ~~ responsibility
    responsibility ~~ appreciation
    empco ~~ enjoyment
    empco ~~ nareng
    empco ~~ exphomeless
    nareng ~~ enjoyment
    nareng ~~ exphomeless
    enjoyment ~~ 0*exphomeless
    empco ~~ 0*condition
    enjoyment ~~ 0*condition
    nareng ~~ 0*condition'
    
    fit_exphomeless2 <- sem(model_exphomeless2, data = data,fixed.x=FALSE, test = "satorra.bentler", se="bootstrap")
    residuals(fit_exphomeless2)
    summary(fit_exphomeless2, fit.measures=T, standardized=T)
    mi = modificationIndices(fit_exphomeless2)
    head(mi[order(-mi$mi), ], 10) 

    CorrDiff(fit_exphomeless, fit_exphomeless2)
    
    
    # model_exphomeless3: take out all other nonsig relationships
    model_exphomeless3 <- 'donation ~ 0*condition + 0*identification + 0*responsibility + appreciation + 0*empco + enjoyment + nareng + exphomeless
    identification ~ 0*condition + empco + enjoyment + nareng + exphomeless
    responsibility ~ condition + empco + enjoyment + 0*nareng + 0*exphomeless
    appreciation ~ 0*condition + empco + enjoyment + nareng + 0*exphomeless
    identification ~~ appreciation
    identification ~~ responsibility
    responsibility ~~ appreciation
    empco ~~ enjoyment
    empco ~~ nareng
    empco ~~ exphomeless
    nareng ~~ enjoyment
    nareng ~~ exphomeless
    enjoyment ~~ 0*exphomeless
    empco ~~ 0*condition
    enjoyment ~~ 0*condition
    nareng ~~ 0*condition'
    
    fit_exphomeless3 <- sem(model_exphomeless3, data = data,fixed.x=FALSE, test = "satorra.bentler", se="bootstrap")
    residuals(fit_exphomeless3)
    summary(fit_exphomeless3, fit.measures=T, standardized=T)
    mi = modificationIndices(fit_exphomeless3)
    head(mi[order(-mi$mi), ], 10) 
    
    CorrDiff(fit_exphomeless, fit_exphomeless3)
    
#########################################################################################################     
#########################################################################################################
    #####################################################################################################      
    #####################################################################################################
    #####################################################################################################      
    #####################################################################################################
    #####################################################################################################      
    #####################################################################################################
    #####################################################################################################      
    #####################################################################################################
    #####################################################################################################      
    #####################################################################################################
    #####################################################################################################      
    #####################################################################################################
    #####################################################################################################      
    #####################################################################################################
    #####################################################################################################      
    #####################################################################################################
    #####################################################################################################      
    #####################################################################################################
    #FURTHER ANALYSIS, NOT INCLUDED IN STUDY  
    
     
    ###########################
    #MULTIPLE GROUP COMPARISON
    #http://lavaan.ugent.be/tutorial/groups.html
    
    
    #Testing for a Moderated Mediation
    #Helpful links
    #https://groups.google.com/forum/#!topic/lavaan/RW_3TMARGhY
    #http://lavaan.ugent.be/tutorial/groups.html

    
    #relationship between identification and donation constrained
    model_id_don_constrained <- 'donation ~ condition + c(a,a)*identification + responsibility + appreciation + empco + enjoyment + nareng
    identification ~ condition + empco + enjoyment + nareng
    responsibility ~ condition + empco + enjoyment + nareng
    appreciation ~ condition + empco + enjoyment + nareng
    identification ~~ appreciation
    identification ~~ responsibility
    responsibility ~~ appreciation
    empco ~~ 0*condition
    empco ~~ enjoyment
    empco ~~ nareng
    nareng ~~ enjoyment
    enjoyment ~~ 0*condition
    nareng ~~ 0*condition'
    
    fit_exphomeless_id_don_constrained <- sem(model_id_don_constrained, data = data,fixed.x=FALSE, group = "exphomeless",test = "satorra.bentler", se="bootstrap") #make sure to use original model
    residuals(fit_exphomeless_id_don_constrained)
    summary(fit_exphomeless_id_don_constrained, fit.measures=T, standardized=T)
    mi = modificationIndices(fit_exphomeless_id_don_constrained)
    head(mi[order(-mi$mi), ], 10) 
    

    #relationship between identification and donation not constrained
    model_id_don_notconstrained <- 'donation ~ condition + identification + responsibility + appreciation + empco + enjoyment + nareng
    identification ~ condition + empco + enjoyment + nareng
    responsibility ~ condition + empco + enjoyment + nareng
    appreciation ~ condition + empco + enjoyment + nareng
    identification ~~ appreciation
    identification ~~ responsibility
    responsibility ~~ appreciation
    empco ~~ 0*condition
    empco ~~ enjoyment
    empco ~~ nareng
    nareng ~~ enjoyment
    enjoyment ~~ 0*condition
    nareng ~~ 0*condition'
    
    
    fit_exphomeless_id_don_notconstrained <- sem(model_id_don_notconstrained, data = data,fixed.x=FALSE, group = "exphomeless", test = "satorra.bentler", se="bootstrap")
    summary(fit_exphomeless_id_don_notconstrained, fit.measures=T, standardized=T)
    
    
    describeBy(data$donation, data$exphomeless)
    
    anova(fit_exphomeless_id_don_notconstrained, fit_exphomeless_id_don_constrained)
    
    library(semTools)
    measurementInvariance(model_orig, data = data, group = "exphomeless", strict = TRUE)
    
    CorrDiff(fit_exphomeless_id_don_notconstrained, fit_exphomeless_id_don_constrained)
    
    
###########################
    #ANOVA TEST OF HYPOTHESES
    #anova
    # load needed packages
    library(car)
    library(compute.es)
    library(effects)
    library(ggplot2)
    library(multcomp)
    library(WRS2)
    library(pastecs)
    
    # MANOVA
    # 2x2 Factorial MANOVA with 3 Dependent Variables. 
    Y <- cbind(data$donation, data$identification, data$responsibility, data$appreciation)
    fit <- manova(Y ~ condition, data=data)
    summary(fit, test="Pillai")
    # Total Effect?
    #             Df   Pillai approx F num Df den Df    Pr(>F)    
    #  condition   1 0.071474   12.104      4    629 1.745e-09 ***
    #  Residuals 632                                              
    #  ---
    #  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
    
    summary.aov(fit, test="Pillai") # zeigt noch, welche Outcomes es gibt für die einzelnen AVs
    #  Response 3 : in Y ist Responsibility an dritter Stelle
    #               Df  Sum Sq Mean Sq F value    Pr(>F)    
    #  condition     1  118.69 118.694  42.646 1.349e-10 ***
    #  Residuals   632 1759.02   2.783                      
    #  ---
    #  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
    
    
    # ANCOVA (only with Responsibility) Source: https://ww2.coastal.edu/kingw/statistics/R-tutorials/ancova.html
    lm.mod1 = lm(donation ~ condition + responsibility, data=data)
    lm.mod2 = lm(donation ~ condition * responsibility, data=data)
    anova(lm.mod1, lm.mod2)
    # I like that. The F-value is near 1, so we can assume the absence of important interactions. That will make our analysis easier. 
    anova(lm.mod1) # nothing sign.!
    summary(lm.mod1) # nothing sign.!
    # Here are the Type II (nonsequential) tests from the "car" package. 
    Anova(lm.mod1) # nothing sign.!
    
    #####################################################################################################    
    #The Importance of the Control Variables   
    
    
    CorrDiff <- function(fit.baseline, fit.restricted){
      Corrc2Base <- fitMeasures(fit.baseline)[[6]] # extrahiert aus den zu vergleichenden Modellen den korrigierten sowie den unkorrigierten Chi-Quadrat-Wert & die dazu gehörige df und weist diese dem Objekt Corrc2Base zu
      MLc2Base <- fitMeasures(fit.baseline)[[2]]
      dfBase <- fitMeasures(fit.baseline)[[7]]
      Corrc2Rest <- fitMeasures(fit.restricted)[[6]]
      MLc2Rest <- fitMeasures(fit.restricted)[[2]]
      dfRest <- fitMeasures(fit.restricted)[[7]]
      c0 <- MLc2Rest / Corrc2Rest # Korrekturwer wird hier berechnet, mit dem die Chi-Quadrat-Differenz korrigiert wird
      c1 <- MLc2Base / Corrc2Base # Korrekturwer wird hier berechnet, mit dem die Chi-Quadrat-Differenz korrigiert wird
      cd <- (dfRest*c0-dfBase*c1)/(dfRest-dfBase) # Korrekturwer wird hier berechnet, mit dem die Chi-Quadrat-Differenz korrigiert wird
      CorrDiff <- (MLc2Rest-MLc2Base)/cd
      dfDiff <- dfRest - dfBase
      pDiff <- 1-pchisq(CorrDiff, dfDiff)
      result <- list(Corr.chisq.difference = CorrDiff,
                     df.difference=dfDiff, p.value=pDiff)
      return(result)
    }
    
    
    
    ################################
    #Enjoyment
    
    # model_noenjoyment.donation: Take out donation ~ enjoyment
    
    model_noenjoyment.donation <- 'donation ~ condition + identification + responsibility + appreciation + empco + 0*enjoyment + nareng
    identification ~ condition + empco + enjoyment + nareng
    responsibility ~ condition + empco + enjoyment + nareng
    appreciation ~ condition + empco + enjoyment + nareng
    identification ~~ appreciation
    identification ~~ responsibility
    responsibility ~~ appreciation
    empco ~~ 0*condition
    empco ~~ enjoyment
    empco ~~ nareng
    nareng ~~ enjoyment
    enjoyment ~~ 0*condition
    nareng ~~ 0*condition'
    
    fit_noenjoyment.donation <- sem(model_noenjoyment.donation, data = data,fixed.x=FALSE, test = "satorra.bentler", se="bootstrap")
    summary(fit_noenjoyment.donation, fit.measures=T, standardized=T)
    
    CorrDiff(fit_orig, fit_noenjoyment.donation)
    
    # model_noenjoyment.identification: Take out identification ~ enjoyment
    
    model_noenjoyment.identification1 <- 'donation ~ condition + identification + responsibility + appreciation + empco + enjoyment + nareng
    identification ~ condition + empco + 0*enjoyment + nareng
    responsibility ~ condition + empco + enjoyment + nareng
    appreciation ~ condition + empco + enjoyment + nareng
    identification ~~ appreciation
    identification ~~ responsibility
    responsibility ~~ appreciation
    empco ~~ 0*condition
    empco ~~ enjoyment
    empco ~~ nareng
    nareng ~~ enjoyment
    enjoyment ~~ 0*condition
    nareng ~~ 0*condition'
    
    fit_noenjoyment.identification <- sem(model_noenjoyment.identification, data = data,fixed.x=FALSE, test = "satorra.bentler", se="bootstrap")
    summary(fit_noenjoyment.identification, fit.measures=T, standardized=T)
    
    CorrDiff(fit_orig, fit_noenjoyment.identification)
    
    # model_noenjoyment.responsibility: Take out responsibility ~ enjoyment
    
    model_noenjoyment.responsibility <- 'donation ~ condition + identification + responsibility + appreciation + empco + enjoyment + nareng
    identification ~ condition + empco + enjoyment + nareng
    responsibility ~ condition + empco + 0*enjoyment + nareng
    appreciation ~ condition + empco + enjoyment + nareng
    identification ~~ appreciation
    identification ~~ responsibility
    responsibility ~~ appreciation
    empco ~~ 0*condition
    empco ~~ enjoyment
    empco ~~ nareng
    nareng ~~ enjoyment
    enjoyment ~~ 0*condition
    nareng ~~ 0*condition'
    
    fit_noenjoyment.responsibility <- sem(model_noenjoyment.responsibility, data = data,fixed.x=FALSE, test = "satorra.bentler", se="bootstrap")
    summary(fit_noenjoyment.donation, fit.measures=T, standardized=T)
    
    CorrDiff(fit_orig, fit_noenjoyment.responsibility)   
    
    
    # model_noenjoyment.appreciation: Take out appreciation ~ enjoyment
    
    model_noenjoyment.appreciation <- 'donation ~ condition + identification + responsibility + appreciation + empco + enjoyment + nareng
    identification ~ condition + empco + enjoyment + nareng
    responsibility ~ condition + empco + enjoyment + nareng
    appreciation ~ condition + empco + 0*enjoyment + nareng
    identification ~~ appreciation
    identification ~~ responsibility
    responsibility ~~ appreciation
    empco ~~ 0*condition
    empco ~~ enjoyment
    empco ~~ nareng
    nareng ~~ enjoyment
    enjoyment ~~ 0*condition
    nareng ~~ 0*condition'
    
    fit_noenjoyment.appreciation <- sem(model_noenjoyment.appreciation, data = data,fixed.x=FALSE, test = "satorra.bentler", se="bootstrap")
    #summary(fit_noenjoyment.appreciation, fit.measures=T, standardized=T)
    
    CorrDiff(fit_orig, fit_noenjoyment.appreciation)   
    
    
    ################################
    #Empathic Concern
    
    # model_noempco.donation: Take out donation ~ enjoyment
    
    model_noempco.donation <- 'donation ~ condition + identification + responsibility + appreciation + 0*empco + enjoyment + nareng
    identification ~ condition + empco + enjoyment + nareng
    responsibility ~ condition + empco + enjoyment + nareng
    appreciation ~ condition + empco + enjoyment + nareng
    identification ~~ appreciation
    identification ~~ responsibility
    responsibility ~~ appreciation
    empco ~~ 0*condition
    empco ~~ enjoyment
    empco ~~ nareng
    nareng ~~ enjoyment
    enjoyment ~~ 0*condition
    nareng ~~ 0*condition'
    
    fit_noempco.donation <- sem(model_noempco.donation, data = data,fixed.x=FALSE, test = "satorra.bentler", se="bootstrap")
    #summary(fit_noenjoyment.donation, fit.measures=T, standardized=T)
    
    CorrDiff(fit_orig, fit_noempco.donation)
    
    # model_noempco.identification: Take out identification ~ enjoyment
    
    model_noempco.identification <- 'donation ~ condition + identification + responsibility + appreciation + empco + enjoyment + nareng
    identification ~ condition + 0*empco + enjoyment + nareng
    responsibility ~ condition + empco + enjoyment + nareng
    appreciation ~ condition + empco + enjoyment + nareng
    identification ~~ appreciation
    identification ~~ responsibility
    responsibility ~~ appreciation
    empco ~~ 0*condition
    empco ~~ enjoyment
    empco ~~ nareng
    nareng ~~ enjoyment
    enjoyment ~~ 0*condition
    nareng ~~ 0*condition'
    
    fit_noempco.identification <- sem(model_noempco.identification, data = data,fixed.x=FALSE, test = "satorra.bentler", se="bootstrap")
    summary(fit_noempco.identification, fit.measures=T, standardized=T)
    
    CorrDiff(fit_orig, fit_noempco.identification)
    
    # model_noenjoyment.responsibility: Take out responsibility ~ enjoyment
    
    model_noempco.responsibility <- 'donation ~ condition + identification + responsibility + appreciation + empco + enjoyment + nareng
    identification ~ condition + empco + enjoyment + nareng
    responsibility ~ condition + 0*empco + enjoyment + nareng
    appreciation ~ condition + empco + enjoyment + nareng
    identification ~~ appreciation
    identification ~~ responsibility
    responsibility ~~ appreciation
    empco ~~ 0*condition
    empco ~~ enjoyment
    empco ~~ nareng
    nareng ~~ enjoyment
    enjoyment ~~ 0*condition
    nareng ~~ 0*condition'
    
    fit_noempco.responsibility <- sem(model_noempco.responsibility, data = data,fixed.x=FALSE, test = "satorra.bentler", se="bootstrap")
    summary(fit_noenjoyment.donation, fit.measures=T, standardized=T)
    
    CorrDiff(fit_orig, fit_noempco.responsibility)   
    
    
    # model_noenjoyment.appreciation: Take out appreciation ~ enjoyment
    
    model_noempco.appreciation <- 'donation ~ condition + identification + responsibility + appreciation + empco + enjoyment + nareng
    identification ~ condition + empco + enjoyment + nareng
    responsibility ~ condition + empco + enjoyment + nareng
    appreciation ~ condition + 0*empco + enjoyment + nareng
    identification ~~ appreciation
    identification ~~ responsibility
    responsibility ~~ appreciation
    empco ~~ 0*condition
    empco ~~ enjoyment
    empco ~~ nareng
    nareng ~~ enjoyment
    enjoyment ~~ 0*condition
    nareng ~~ 0*condition'
    
    fit_noempco.appreciation <- sem(model_noempco.appreciation, data = data,fixed.x=FALSE, test = "satorra.bentler", se="bootstrap")
    #summary(fit_noempco.appreciation, fit.measures=T, standardized=T)
    
    CorrDiff(fit_orig, fit_noempco.appreciation)   
    
    
    
    ################################
    #Narrative Engagement
    
    # model_noenjoyment.donation: Take out donation ~ enjoyment
    
    model_nonareng.donation <- 'donation ~ condition + identification + responsibility + appreciation + empco + enjoyment + 0*nareng
    identification ~ condition + empco + enjoyment + nareng
    responsibility ~ condition + empco + enjoyment + nareng
    appreciation ~ condition + empco + enjoyment + nareng
    identification ~~ appreciation
    identification ~~ responsibility
    responsibility ~~ appreciation
    empco ~~ 0*condition
    empco ~~ enjoyment
    empco ~~ nareng
    nareng ~~ enjoyment
    enjoyment ~~ 0*condition
    nareng ~~ 0*condition'
    
    fit_nonareng.donation <- sem(model_nonareng.donation, data = data,fixed.x=FALSE, test = "satorra.bentler", se="bootstrap")
    #summary(fit_nonareng.donation, fit.measures=T, standardized=T)
    
    CorrDiff(fit_orig, fit_nonareng.donation)
    
    # model_noenjoyment.identification: Take out identification ~ enjoyment
    
    model_nonareng.identification <- 'donation ~ condition + identification + responsibility + appreciation + empco + enjoyment + nareng
    identification ~ condition + empco + enjoyment + 0*nareng
    responsibility ~ condition + empco + enjoyment + nareng
    appreciation ~ condition + empco + enjoyment + nareng
    identification ~~ appreciation
    identification ~~ responsibility
    responsibility ~~ appreciation
    empco ~~ 0*condition
    empco ~~ enjoyment
    empco ~~ nareng
    nareng ~~ enjoyment
    enjoyment ~~ 0*condition
    nareng ~~ 0*condition'
    
    fit_nonareng.identification <- sem(model_nonareng.identification, data = data,fixed.x=FALSE, test = "satorra.bentler", se="bootstrap")
    #summary(fit_nonareng.identification, fit.measures=T, standardized=T)
    
    CorrDiff(fit_orig, fit_nonareng.identification)
    
    # model_noenjoyment.responsibility: Take out responsibility ~ enjoyment
    
    model_nonareng.responsibility <- 'donation ~ condition + identification + responsibility + appreciation + empco + enjoyment + nareng
    identification ~ condition + empco + enjoyment + nareng
    responsibility ~ condition + empco + enjoyment + 0*nareng
    appreciation ~ condition + empco + enjoyment + nareng
    identification ~~ appreciation
    identification ~~ responsibility
    responsibility ~~ appreciation
    empco ~~ 0*condition
    empco ~~ enjoyment
    empco ~~ nareng
    nareng ~~ enjoyment
    enjoyment ~~ 0*condition
    nareng ~~ 0*condition'
    
    fit_nonareng.responsibility <- sem(model_nonareng.responsibility, data = data,fixed.x=FALSE, test = "satorra.bentler", se="bootstrap")
    #summary(fit_nonareng.responsibility, fit.measures=T, standardized=T)
    
    CorrDiff(fit_orig, fit_nonareng.responsibility)   
    
    
    # model_noenjoyment.appreciation: Take out appreciation ~ enjoyment
    
    model_nonareng.appreciation <- 'donation ~ condition + identification + responsibility + appreciation + empco + enjoyment + nareng
    identification ~ condition + empco + enjoyment + nareng
    responsibility ~ condition + empco + enjoyment + nareng
    appreciation ~ condition + empco + enjoyment + 0*nareng
    identification ~~ appreciation
    identification ~~ responsibility
    responsibility ~~ appreciation
    empco ~~ 0*condition
    empco ~~ enjoyment
    empco ~~ nareng
    nareng ~~ enjoyment
    enjoyment ~~ 0*condition
    nareng ~~ 0*condition'
    
    fit_nonareng.appreciation <- sem(model_nonareng.appreciation, data = data,fixed.x=FALSE, test = "satorra.bentler", se="bootstrap")
    #summary(fit_nonareng.appreciation, fit.measures=T, standardized=T)
    
    CorrDiff(fit_orig, fit_nonareng.appreciation)      
    
    
    
    
    #####################################################################################################    
    #New Model: Without Responsiblity ~ Nareng 
    
    # model_f3: Take out responsibility ~ nareng
    
    model_f3 <- 'donation ~ condition + identification + responsibility + appreciation + empco + enjoyment + nareng
    identification ~ condition + empco + enjoyment + nareng
    responsibility ~ condition + empco + enjoyment + 0*nareng
    appreciation ~ condition + empco + enjoyment + nareng
    identification ~~ appreciation
    identification ~~ responsibility
    responsibility ~~ appreciation
    empco ~~ 0*condition
    empco ~~ enjoyment
    empco ~~ nareng
    nareng ~~ enjoyment
    enjoyment ~~ 0*condition
    nareng ~~ 0*condition'
    
    fit_f3 <- sem(model_f3, data = data,fixed.x=FALSE, test = "satorra.bentler", se="bootstrap")
    summary(fit_f3, fit.measures=T, standardized=T)  
  