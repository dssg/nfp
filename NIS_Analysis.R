##################################
##    Data Preparation File     ##
## National Immunization Survey ##
##         Joe Walsh            ##
##         Emily Rowe           ##
##        Adam Fishman          ##
##################################


##################################
## NIS-reported immunization rates seem too low
## See if I can get more reasonable estimates than simple averages

load("/mnt/data/NIS/modified_data/NISPUF_2008_2009_2010.RData")
#load("/mnt/data/NIS/modified_data/NISPUF08.RData")

# NISPUF includes lots of older kids (24-36 months)
length(NISPUF_08_09_10$AGEGRP[NISPUF_08_09_10$AGEGRP==2 | NISPUF_08_09_10$AGEGRP==3]) / length(NISPUF_08_09_10$AGEGRP)


# NISPUF includes kids w/o adequate records
length(NISPUF_08_09_10$PDAT[NISPUF_08_09_10$PDAT==2]) / length(NISPUF_08_09_10$PDAT)


## Create dataset with only comparable data
# PDAT==1: adequate provider data
# AGEGRP==1: 19-23 months, so it is comparative
data <- subset(NISPUF_08_09_10, subset=c(PDAT==1)) # & AGEGRP==1))


# DTaP immunizations up to date
data$DTaP6 <- 0
  data$DTaP6[data$DDTP3<=366/2+30] <- 1
data$DTaP12 <- 0
  data$DTaP12[data$DDTP3<=366+30] <- 1
data$DTaP18 <- 0
  data$DTaP18[data$DDTP4<=3/2*366+30] <- 1
data$DTaP24 <- 0
  data$DTaP24[data$DDTP4<=2*366+30] <- 1

# Polio immunizations up to date
data$Polio6 <- 0
data$Polio6[data$DPOLIO2<=366/2+30] <- 1
data$Polio12 <- 0
  data$Polio12[data$DPOLIO2<=366+30] <- 1
data$Polio18 <- 0
  data$Polio18[data$DPOLIO3<=3/2*366+30] <- 1
data$Polio24 <- 0
  data$Polio24[data$DPOLIO3<=2*366+30] <- 1

# MMR immunization up to date
data$MMR6 <- 1
data$MMR12 <- 1
data$MMR18 <- 0
  data$MMR18[data$DMMR1<=3/2*366+30] <- 1
data$MMR24 <- 1
  data$MMR24[data$DMMR1<=2*366+30] <- 1

# 4:3:1 UTD, as determined by FISPUF age variables
data$UTD6 <- 0
  data$UTD6[data$DTaP6==1 & data$Polio6==1 & data$MMR6==1] <- 1
data$UTD12 <- 0
  data$UTD12[data$DTaP12==1 & data$Polio12==1 & data$MMR12==1] <- 1
data$UTD18 <- 0
  data$UTD18[data$DTaP18==1 & data$Polio18==1 & data$MMR18==1] <- 1
data$UTD24 <- 0
  data$UTD24[data$DTaP24==1 & data$Polio24==1 & data$MMR24==1] <- 1

# How do my UTD measures compare with the dataset's?
# I marked 4% of cases as UTD where the dataset says they are not
library(gmodels)
CrossTable(data$UTD24, data$P_UTD431)

# Is it possible that an earlier shot is missing for some of these?
# For example, the child has only received three shots but the third 
# shot is marked as the fourth
# NO!
length(data$DTaP24[data$DTaP24==1 & is.na(data$DDTP3) & is.na(data$DDTP2)] & is.na(data$DDTP1)) / length(data$DTaP24[data$DTaP24==1])
length(data$Polio24[data$Polio24==1 & is.na(data$DPOLIO2) & is.na(data$DPOLIO1)]) / length(data$Polio24[data$Polio24==1])

# Drop conflicting observations
data <- subset(data, subset=((UTD24==0 & P_UTD431==0) | (UTD24==1 & P_UTD431==1)))

# Weighted UTD 4:3:1 for 2010
sum(data$PROVWT[data$P_UTD431==1 & data$YEAR==2010], na.rm=TRUE) / sum(data$PROVWT[data$YEAR==2010], na.rm=TRUE)
sum(data$PROVWT[data$UTD24==1 & data$YEAR==2010], na.rm=TRUE) / sum(data$PROVWT[data$YEAR==2010], na.rm=TRUE)

# Raw mean UTD at 6, 12, 18, and 24 months for 2010
mean(data$UTD6[data$YEAR==2010])
mean(data$UTD12[data$YEAR==2010])
mean(data$UTD18[data$YEAR==2010])
mean(data$UTD24[data$YEAR==2010])

# Weighted mean UTD 6, 12, 18, and 24 months for 2010
sum(data$PROVWT[data$UTD6==1 & data$YEAR==2010], na.rm=TRUE) / sum(data$PROVWT[data$YEAR==2010], na.rm=TRUE)
sum(data$PROVWT[data$UTD12==1 & data$YEAR==2010], na.rm=TRUE) / sum(data$PROVWT[data$YEAR==2010], na.rm=TRUE)
sum(data$PROVWT[data$UTD18==1 & data$YEAR==2010], na.rm=TRUE) / sum(data$PROVWT[data$YEAR==2010], na.rm=TRUE)
sum(data$PROVWT[data$UTD24==1 & data$YEAR==2010], na.rm=TRUE) / sum(data$PROVWT[data$YEAR==2010], na.rm=TRUE)






##################################
## EXPLORATORY ANALYSIS

#load("/mnt/data/NIS/modified_data/NISPUF.RData")

load("/mnt/data/NIS/immunizations_analysis.RData")

summary(immunizations)

# Matching: Income
results <- table(immunizations$income_recode, immunizations$treatment)
colnames(results) <- c("not NFP", "NFP")
rownames(results) <- c("$0-7.5k", "$7.5-20k", "20-30k",
                       "$30-40k", "$40k+", "parents")
par(las=3, mar=c(2.2,3,2,1))
mosaicplot(results,
           color = c("gray60", "gray80"),
           main="Matching: Income",
           xlab="income category",
           ylab="NFP enrollment")

text(.05,.7,"4221",cex=.75)
text(.05,.2,"3571",cex=.75)
text(.18,.65,"12953",cex=.75)
text(.18,.15,"6691",cex=.75)
text(.325,.6,"8813",cex=.75)
text(.325,.1,"2271",cex=.75)
text(.425,.5,"7672",cex=.75)
text(.425,.03,"946",cex=.75)
text(.72,.5,"59895",cex=.75)
text(.72,0,"686",cex=.75)
text(.98,0,"27",cex=.75)





# Matching: Mother's Education
results <- table(immunizations$HSgrad, immunizations$treatment)
rownames(results) <- c("~HS grad", "HS grad")
colnames(results) <- c("not NFP", "NFP")
par(las=3, mar=c(2.2,3,2,1))
mosaicplot(results,
           color = c("gray60", "gray80"),
           main="Matching: Mother's Education",
           xlab="whether mother finished high school",
           ylab="NFP enrollment")
text(.09,.65,"10947", cex=.75)
text(.09,.18,"9351", cex=.75)
text(.6,.5,"91560", cex=.75)
text(.6,.025,"11109",cex=.75)




names(immunizations)
# Mother Married
results <- table(immunizations$married, immunizations$treatment)
rownames(results) <- c("~married", "married")
colnames(results) <- c("not NFP", "NFP")
par(las=3, mar=c(2.2,3,2,1))
mosaicplot(results,
           color = c("gray60", "gray80"),
           main="Matching: Mother's Marriage Status",
           xlab="whether mother is currently married",
           ylab="NFP enrollment")
text(.2,.65,"10947", cex=.75)
text(.2,.18,"9351", cex=.75)
text(.6,.5,"91560", cex=.75)
text(.6,.025,"11109",cex=.75)


names(immunizations)

temp <- subset(immunizations, 
               subset=c(!is.na(immunizations$income_recode) & 
                          !is.na(immunizations$language) &
                          !is.na(immunizations$MAge) & 
                          !is.na(immunizations$RE) & 
                          !is.na(immunizations$male) & 
                          !is.na(immunizations$married) & 
                          !is.na(immunizations$HSgrad)))

reg <- glm(treatment ~ factor(income_recode) + factor(language) + 
             factor(MAge) + factor(RE) + male + married + HSgrad, 
           data=temp, family=binomial)

p <- reg$fitted
p.t <- p[temp$treatment==1& p>.05]
p.c <- p[temp$treatment==0& p>.05]

#SHOW WITH MATCHES
par(mfrow=c(2,1))
plot1 <- hist(p[temp$treatment==1],prob=TRUE,xlim=c(0,1), ylim=c(0,15),plot=F)
plot2 <- hist(p[temp$treatment==0],prob=TRUE,xlim=c(0,1), ylim=c(0,15),plot=F)

plot3 <- hist(p[temp$treatment==1 & p>.05],prob=TRUE,xlim=c(0,1), ylim=c(0,6),plot=F)
plot4 <- hist(p[temp$treatment==0 & p>.05],prob=TRUE, xlim=c(0,1), ylim=c(0,6),plot=F)


load("/mnt/data/NIS/modified_data/NISPUF.RData")
# Overall immunizations up to date
sort(names(NISPUF))

Immunizations_UptoDate_6 <- sum(NISPUF$PDAT==1 & NISPUF$DTaP6==1 & NISPUF$Polio6==1 & NISPUF$MMR6==1) / sum(NISPUF$PDAT==1)
Immunizations_UptoDate_12 <- sum(NISPUF$PDAT==1 & NISPUF$DTaP12==1 & NISPUF$Polio12==1 & NISPUF$MMR12==1) / sum(NISPUF$PDAT==1)
Immunizations_UptoDate_18 <- sum(NISPUF$PDAT==1 & NISPUF$DTaP18==1 & NISPUF$Polio18==1 & NISPUF$MMR18==1) / sum(NISPUF$PDAT==1)
Immunizations_UptoDate_24 <- sum(NISPUF$PDAT==1 & NISPUF$DTaP24==1 & NISPUF$Polio24==1 & NISPUF$MMR24==1) / sum(NISPUF$PDAT==1)

y.coord <- c(Immunizations_UptoDate_6,
             Immunizations_UptoDate_12,
             Immunizations_UptoDate_18,
             Immunizations_UptoDate_24)
plot(c(6,12,18,24), y.coord, pch=19, xlim=c(6,24), ylim=c(0,1), axes=F,
     main='Up-to-Date Vaccination Rates (MMR, DTaP, Polio)',
     xlab='months since birth', 
     ylab='proportion of children up to date')
axis(1,at=c(6,12,18,24))
axis(2)
box()

nfp.data <- read.csv("/mnt/data/csv_data/growth_immunization_outcomes.csv",
                     header=TRUE)
names(nfp.data)
y2.coord <- c(sum(nfp.data$final_immun_1=='Yes') / sum(nfp.data$final_immun_1=='Yes' | nfp.data$final_immun_1=='No'),
              sum(nfp.data$final_immun_2=='Yes') / sum(nfp.data$final_immun_2=='Yes' | nfp.data$final_immun_2=='No'),
              sum(nfp.data$final_immun_3=='Yes') / sum(nfp.data$final_immun_3=='Yes' | nfp.data$final_immun_3=='No'),
              sum(nfp.data$final_immun_4=='Yes') / sum(nfp.data$final_immun_4=='Yes' | nfp.data$final_immun_4=='No'))
points(c(6,12,18,24), y2.coord, pch=19, col='red')
legend('bottomright', lty=1, col=c("red","black"), legend=c("NFP","NIS"))



# Compare mother's education levels, etc.
#MOSAICPLOT

# Child variables: whether child is first born, age, WIC, 

# Household-reported vaccination rates
# NFP
# NIS

names(immunizations)
mean(immunizations$Immunizations_UptoDate_6,na.rm=T)

table(immunizations$Immunizations_UptoDate_6,immunizations$treatment)




# What proportion of those who gave permission had adequate provider records?
sum(NISPUF$D7==1 & NISPUF$PDAT==1, na.rm=TRUE) / sum(NISPUF$D7==1, na.rm=TRUE)


# How reliable are household-reported vaccination rates?  Compare HH reports to provider reports in NIS data.
sum(NISPUF$PDAT==1 & NISPUF$HH_DTP>0 & !is.na(NISPUF$DDTP1)) / sum(NISPUF$PDAT==1 & NISPUF$HH_DTP>0)
unique(NISPUF$AGEGRP)


# How reliable are household shot cards?






# How many shots of each vaccine are kids receiving?





# Examine results for 6-month vaccinations
mean(HepB6==1)
mean(DTaP6==1)
mean(Hib6==1)
mean(Polio6==1) 
mean(PCV6==1)
mean(MMR6==1)
mean(Varicella6==1)
mean(HepA6==1)
mean(Rotavirus6==1)


# Examine results for 6-month vaccinations
mean(HepB6==1)
mean(DTaP6==1)
mean(Hib6==1)
mean(Polio6==1) 
mean(PCV6==1)
mean(MMR6==1)
mean(Varicella6==1)
mean(HepA6==1)
mean(Rotavirus6==1)





##################################
## MATCHING

# Install and import packages.
install.packages("Matching", repo="http://cran.rstudio.com")
library(Matching)

setwd("/mnt/data/NIS")
load("immunizations_analysis.RData")

# Define D, X, Y, and Z.
# D is an indicator of whether the observation came from the NFP data set.
# X are controls for the independent variables in the regression of Y on D.
# Y is the outcome of interest.
# Z include all X and the other variables that may impact likelihood of treatment, but do not independently impact the outcome.

D <- immunizations$treatment
X <- subset(immunizations, select = c(income_recode, state, language, MAg, RE, male, married, HSgrad))
Y <- immunizations$Immunizations_UptoDate_6
Z <- subset(immunizations, select = c())

# Regress D on Z to create propensity scores (probit model)

probit <- glm(D ~ ., family = binomial(link = "probit"), data = Z)
summary(probit)

psm <- predict(probit, data = Z, type = "response")

# Create M, a vector of covariates on which to match, including (but not limited to) propensity score

M <- cbind(Z, ps)

# Complete matching!
k <- [insert desired number of matches for each observation]

match <- Match(Y = Y, Tr = D, X = M, M = k, caliper = ? (will we want one?))
summary(match) 
 
##Add "CommonSupport=TRUE" argument to limit to areas of common support , though R documentation recommends setting a caliper instead
## Consider using the GenMatch method - determines weights for each of M in matching with the goal of minimizing the maximum observed discrepancy between paired observations
## Use MatchBalance() to check balance before and after matching with Match (GenMatch automatically finds balance)
## Note that Matchby() function may be useful for stratified matching?

# Calculate weighted average across centers
