# Import data: 
## one dataset for breastfeeding analysis (includes treatment and control obs)
## one dataset includes the full NSCH dataset and weights (for general population statistics)

setwd("/mnt/data/NSCH/data")
breast <- read.csv("breastfeeding_data.csv")
pop <- read.csv("breast_pop_comparison.csv")

# Prospensity score matching
library(Matching)

# Outcome 1: Child was ever breastfed
ever_breast1 <- breast[,c(1:13, 15)] # Omit data for other outcome measure
ever_breast <- subset(ever_breast1, complete.cases(ever_breast1))


probit <- glm(ever_breast$treatment ~ ., family = binomial(link = "probit"), data = ever_breast[,!13])
summary(probit)


# Outcome 2: Weeks child was breastfed
weeks_breast <- complete.cases(breast[,c(1:12, 14:15)])



D <- breast$treatment
Z <- subset(breast, select = c('male', 'premature', 'lbw', 'highschool', 'highered', 'marital_status', 
	'MomsAgeBirth', 'State', 'RE', 'english'))
Y1 <- breast$breastfed # Binary variable: 1 if child was ever breastfed, 0 if not
Y2 <- breast$week_end_breast # Numeric variables: age in weeks of child when last breastfed

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
