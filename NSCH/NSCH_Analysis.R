# Import data: 
## one dataset for breastfeeding analysis (includes treatment and control obs)
## one dataset includes the full NSCH dataset and weights (for general population statistics)

setwd("/mnt/data/NSCH/data")
breast <- read.csv("breastfeeding_data.csv")
pop <- read.csv("breast_pop_comparison.csv")

# Prospensity score matching:

library(Matching)

# Define D, X, Y, and Z.
## D is an indicator of whether the observation came from the NFP data set (treatment indicator).
## X are controls for the independent variables in the regression of Y on D.
## Y is the outcome of interest (ever breastfed, weeks of breastfeeding).
## Z include all X and the other variables that may impact likelihood of treatment, but do not independently impact the outcome.

D <- breast$treatment
X <- subset(breast, select = c('male', 'premature', 'lbw', 'highschool', 'highered', 'marital_status', 'MomsAgeBirth', 'State', 'RE', 'english'))
Y1 <- breast$breastfed # Binary variable: 1 if child was ever breastfed, 0 if not
Y2 <- breast$week_end_breast # Numeric variables: age in weeks of child when last breastfed
Z <- X

# Regress D on Z to create propensity scores (probit model)

probit <- glm(D ~ ., family = binomial(link = "probit"), data = Z)
summary(probit)

ps <- predict(probit, data = Z, type = "response")

# Create M, a vector of covariates on which to match, including (but not limited to) propensity score

M <- merge(Z, ps)

# Complete matching!
k <- [insert desired number of matches for each observation]

match <- Match(Y = Y, Tr = D, X = M, M = k, caliper = ? (will we want one?))
summary(match) 
 
##Add "CommonSupport=TRUE" argument to limit to areas of common support , though R documentation recommends setting a caliper instead
## Consider using the GenMatch method - determines weights for each of M in matching with the goal of minimizing the maximum observed discrepancy between paired observations
## Use MatchBalance() to check balance before and after matching with Match (GenMatch automatically finds balance)
## Note that Matchby() function may be useful for stratified matching?

# Calculate weighted average across centers
