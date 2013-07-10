##################################
##    Data Preparation File     ##
## National Immunization Survey ##
##         Joe Walsh            ##
##         Emily Rowe           ##
##        Adam Fishman          ##
##################################


##################################
## EXPLORATORY ANALYSIS

load("/mnt/data/NIS/modified_data/NISPUF.RData")

summary(NISPUF)







# How many people are being questioned each year?
apply(NISPUF, year, sum)


# Compare mother's education levels, etc.
#MOSAICPLOT
hist(NISPUF$EDUC1)
hist(

# Child variables: whether child is first born, age, WIC, 

# Household-reported vaccination rates
# NFP
# NIS


# How reliable are household-reported vaccination rates?  Compare HH reports to provider reports in NIS data.


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
