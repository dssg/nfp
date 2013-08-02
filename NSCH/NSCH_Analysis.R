# Import data: 
## one dataset for breastfeeding analysis (includes treatment and control obs)
## one dataset includes the full NSCH dataset and weights (for general population statistics)

setwd("/mnt/data/NSCH/data")
breast <- read.csv("breastfeeding_data.csv")
pop <- read.csv("breast_pop_comparison.csv")

breast$RE <- relevel(breast$RE, ref = "WhiteNH") # change racial reference category for ease of analysis
m_age <- floor(MomsAgeBirth) # simplify age decimal - decimal reporting may have differed between treatment and control

# Propensity score matching
library(Matching)
library(ggplot2)

##### Outcome 1: Child was ever breastfed

### Approach 1 - using all complete cases

ever_breast1 <- breast[,c(3:13, 15)] # Omit data for other outcome measure, also IDs
ever_breast <- subset(ever_breast1, complete.cases(ever_breast1))

# Start over and build from simple!  This model works:

probit <- glm(treatment ~ (highschool + married + highered), data = ever_breast, family = binomial(link = "probit"))
summary(probit)

ever_breast$ps <- predict(probit, data = ever_breast, type = "response")
qplot(ever_breast$ps, data = ever_breast, binwidth = .01) + facet_wrap(~treatment)

ever_breastX <- cbind(ever_breast$ps, ever_breast$male, ever_breast$premature, ever_breast$lbw) # Vector of covariates for regression
caliper <- 0.1 # Specify desired caliper for including observations (units are standard deviations)

ever_match1 <- Match(Y = ever_breast$breastfed, Tr = ever_breast$treatment, X = ever_breastX, caliper = caliper, ties = FALSE)
summary(ever_match1) 
MatchBalance(treatment ~ (highschool + highered + married), 
	data = ever_breast, match.out=ever_match1, nboots=1000)
	
	
# Start elsewhere - this also works

probit <- glm(treatment ~ (RE + highschool + married), data = ever_breast, family = binomial(link = "probit"))
summary(probit)

ever_breast$ps <- predict(probit, data = ever_breast, type = "response")
qplot(ever_breast$ps, data = ever_breast, binwidth = .01) + facet_wrap(~treatment)

ever_breastX <- cbind(ever_breast$ps, ever_breast$male, ever_breast$premature, ever_breast$lbw) # Vector of covariates for regression
caliper <- 0.05 # Specify desired caliper for including observations (units are standard deviations)

ever_match1 <- Match(Y = ever_breast$breastfed, Tr = ever_breast$treatment, X = ever_breastX, Weight = 2, caliper = caliper, ties = FALSE)
summary(ever_match1) 
MatchBalance(treatment ~ (RE + highschool + married), 
	data = ever_breast, match.out=ever_match1, nboots=1000)


# Start again - try age buckets

ever_breast$MAge[ever_breast$MomsAgeBirth < 20] <- "Teenager"
ever_breast$MAge[20 <= ever_breast$MomsAgeBirth] <- "Twenties"
ever_breast$MAge[30 <= ever_breast$MomsAgeBirth] <- "Thirty Plus"
ever_breast$MAge <- factor(ever_breast$MAge)

probit <- glm(treatment ~ (MAge + RE), data = ever_breast, family = binomial(link = "probit"))
summary(probit)

ever_breast$ps <- predict(probit, data = ever_breast, type = "response")
qplot(ever_breast$ps, data = ever_breast, binwidth = .01) + facet_wrap(~treatment)

ever_breastX <- cbind(ever_breast$ps, ever_breast$male, ever_breast$premature, ever_breast$lbw) # Vector of covariates for regression
caliper <- 0.05 # Specify desired caliper for including observations (units are standard deviations)

ever_match1 <- Match(Y = ever_breast$breastfed, Tr = ever_breast$treatment, X = ever_breastX, Weight = 2, caliper = caliper, ties = FALSE)
summary(ever_match1) 
MatchBalance(treatment ~ (MAge + RE), 
	data = ever_breast, match.out=ever_match1, nboots=1000)


## Time to try GenMatch

MatchVars <- cbind(ever_breast$highschool, ever_breast$married, ever_breast$highered, ever_breast$MomsAgeBirth, ever_breast$RE, ever_breast$english)

GenMatrix <- GenMatch(Tr = ever_breast$treatment, X = MatchVars, pop.size = 1000) # helpful notes on genmatch: http://cgibbons.us/courses/ps236/GenMatch.r
gen_match <- Match(Y = ever_breast$breastfed, Tr = ever_breast$treatment, X = ever_breastX, Weight.matrix = GenMatrix, ties = FALSE)
MatchBalance(treatment ~ highschool + married + highered + MomsAgeBirth + RE + english, data = ever_breast, match.out=gen_match, nboots=1000)


	
	
	
	
	
## Initial stabs:

probit1_full <- glm(treatment ~ (highschool + married +	highered + MomsAgeBirth + RE + english), data = ever_breast, family = binomial(link = "probit"))
summary(probit1_full)
# Drop state - too few obs in each state leading to near-perfect separation

ever_breast$ps <- predict(probit1_full, data = ever_breast, type = "response")
qplot(ever_breast$ps, data = ever_breast, binwidth = .01) + facet_wrap(~treatment)

ever_breastX <- cbind(ever_breast$ps, ever_breast$male, ever_breast$premature, ever_breast$lbw) # Vector of covariates for regression
caliper <- 0.05 # Specify desired caliper for including observations (units are standard deviations)

ever_match1 <- Match(Y = ever_breast$breastfed, Tr = ever_breast$treatment, X = ever_breastX, caliper = caliper)
summary(ever_match1) 
MatchBalance(treatment ~ highschool + married + highered + MomsAgeBirth + RE + english, 
	data = ever_breast, match.out=ever_match1, nboots=1000) # Check balance before and after match - not good.

	
### Limiting area of common support:	
	
cs1 <- ever_breast[ever_breast$ps < .90,]
cs <- cs1[cs1$ps >.80,]

cs_breastX <- cbind(cs$ps, cs$male, cs$premature, cs$lbw) # Vector of covariates for regression
cs_match1 <- Match(Y = cs$breastfed, Tr = cs$treatment, X = cs_breastX, caliper = caliper)
summary(cs_match1) 
MatchBalance(treatment ~ highschool + highered + married + MomsAgeBirth + RE + english, 
	data = cs, match.out=cs_match1, nboots=1000) # Check balance before and after match - not good.

	
### Approach 2 - drop higher ed indicator (lots of NAs), THEN use all complete cases
ever_breast2 <- breast[,c(3:6,8:13,15)] # Also omits higher ed indicator, which has lots of NAs
ever_breast_restricted <- subset(ever_breast2, complete.cases(ever_breast2))

probit1_restr <- glm(treatment ~ (highschool + married + MomsAgeBirth + 
	RE + english), family = binomial(link = "probit"), data = ever_breast_restricted)
summary(probit1_restr)

ever_breast_restricted$ps <- predict(probit1_restr, data = ever_breast_restricted, type = "response")
qplot(ever_breast_restricted$ps, data = ever_breast_restricted) + facet_wrap(~treatment)

ever_breast_restrX <- cbind(ever_breast_restricted$ps, ever_breast_restricted$male, ever_breast_restricted$premature, 
	ever_breast_restricted$lbw) # Vector of covariates for regression

ever_match_restr1 <- Match(Y = ever_breast_restricted$breastfed, Tr = ever_breast_restricted$treatment, X = ever_breast_restrX, M = k)
summary(ever_match_restr1) 
MatchBalance(treatment ~ highschool + married + MomsAgeBirth + RE + english, 
	data = ever_breast_restricted, match.out=ever_match_restr1, nboots=1000) # Check balance before and after match - not good.	




# Outcome 2: Weeks child was breastfed
weeks_breast <- complete.cases(breast[,c(1:12, 14:15)])

#### Notes about using Matching package: 
##Add "CommonSupport=TRUE" argument to limit to areas of common support , though R documentation recommends setting a caliper instead
## Consider using the GenMatch method - determines weights for each of M in matching with the goal of minimizing the maximum observed discrepancy between paired observations
## Use MatchBalance() to check balance before and after matching with Match (GenMatch automatically finds balance)
## Note that Matchby() function may be useful for stratified matching?

# Calculate weighted average across centers
