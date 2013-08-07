library(Matching)
library(ggplot2)
library(cem)
library(survey)
library(hexbin)
library(plyr)

# Import data: 
## one dataset for breastfeeding analysis (includes treatment and control obs)
## one dataset includes the full NSCH dataset and weights (for general population statistics)

setwd("/mnt/data/NSCH/data")
breast <- read.csv("breastfeeding_data.csv")
pop <- read.csv("breast_pop_comparison.csv")

breast$RE <- relevel(breast$RE, ref = "WhiteNH") # change racial reference category for ease of analysis
breast$momsage <- floor(breast$MomsAgeBirth) # simplify age decimal - decimal reporting may have differed between treatment and control
pop$RE <- relevel(pop$RE, ref = "WhiteNH")
pop$momsage <- floor(pop$MomsAgeBirth)

# Need factor values for plotting:
pop$highschool <- factor(pop$highschool)
pop$married <- factor(pop$married)
pop$english <- factor(pop$english)
pop$highered <- factor(pop$highered)
pop$breastfed <- factor(pop$breastfed)
breast$highschool <- factor(breast$highschool)
breast$married <- factor(breast$married)
breast$english <- factor(breast$english)
breast$highered <- factor(breast$highered)
breast$breastfed_factor <- factor(breast$breastfed) # need to keep primary breastfed variable numeric for models

## Prepare full population sample for general comparison
### Notes about NSCH:
########### Strata: STATE and SAMPLE
########### PSU: ID
########### Weight: NSCHWT
#http://faculty.washington.edu/tlumley/survey/example-design.html

popsvy <- svydesign(id = ~ID, strata = ~State + SAMPLE, weights = ~NSCHWT, data = pop) 
popcomp <- subset(popsvy, AGEYR_CHILD <= 4 & AGEPOS4<=2 & (!is.element(FAM_MAR_COHAB, c(7,8,9))))
# Limited to the population of first time moms

##### Comparing NSCH and NFP Populations

# Mother's Age
par(mfrow = c(1,2))
svyhist(~momsage, popcomp, main = "Mother's Age at Birth - NCHS Population", xlab = "Mother's Age", col = "navy blue", 
	border = 'navy blue', ylim = c(0,0.12), breaks = seq(10, 60, by = 2))
hist(breast$momsage[breast$treatment==1], freq = FALSE, main = "Mother's Age at Birth - NFP Population", 
	xlab = "Mother's Age", col = 'dark red', border = 'dark red', ylim = c(0,0.12), breaks = seq(10, 60, by =2))

svymean(~momsage, popcomp, na.rm = TRUE) # Full population of first time moms
mean(breast$momsage[breast$treatment==1], na.rm = TRUE)  # NFP mothers

# Race
par(mfrow = c(1,2))
barplot(svymean(~RE, popcomp, na.rm = TRUE), names.arg = c('White', 'Black', 'Hispanic', 'Other'), 
	main = "Mother's Race - NCHS Population", col = "navy blue", border = 'navy blue', ylim = c(0,0.55))
barplot(prop.table(table(breast$RE[breast$treatment==1], row.names = revalue(breast$RE, c('WhiteNH' = 'White', 
	'BlackNH' = 'Black'))[breast$treatment==1])), main = "Mother's Race - NFP Population", col = 'dark red', border = 'dark red', ylim = c(0,0.55))

svymean(~RE, popcomp, na.rm = TRUE)
prop.table(table(breast$RE[breast$treatment==1]))
	
# Marital Status
par(mfrow = c(1,2))
barplot(svymean(~married, popcomp, na.rm = TRUE), names.arg = c('Unmarried', 'Married'), 
	main = "Marital Status- NCHS Population", col = "navy blue", border = 'navy blue', ylim = c(0,1))
barplot(prop.table(table(breast$married[breast$treatment==1], row.names = revalue(breast$married, c('0' = 'Unmarried', 
	'1' = 'married'))[breast$treatment==1])), main = "Marital Status - NFP Population", col = 'dark red', border = 'dark red', ylim = c(0,1))

svymean(~married, popcomp, na.rm = TRUE)
prop.table(table(breast$married[breast$treatment==1]))


# High School Attendance
par(mfrow = c(1,2))
barplot(svymean(~highschool, popcomp, na.rm = TRUE), names.arg = c('No HS Degree', 'HS Degree'), 
	main = "Education - NCHS Population", xlab = "Education", col = "navy blue", border = 'navy blue', ylim = c(0,1))
barplot(prop.table(table(breast$highschool[breast$treatment==1], row.names = revalue(breast$highschool, c('0' = 'No HS Degree', '1' = 'HS Degree'))[breast$treatment==1])), 
	main = "Education - NFP Population", xlab = "Education", col = 'dark red', border = 'dark red', ylim = c(0,1))

svymean(~highschool, popcomp, na.rm = TRUE)
prop.table(table(breast$highschool[breast$treatment==1]))

# Higher Education
par(mfrow = c(1,2))
barplot(svymean(~highered, popcomp, na.rm = TRUE), names.arg = c('No Post-HS Education', 'Some Post-HS Education'), 
	main = "Higher Education - NCHS Population", col = "navy blue", border = 'navy blue', ylim = c(0,1))
barplot(prop.table(table(breast$highered[breast$treatment==1], row.names = revalue(breast$highered, c('0' = 'No Post-HS Education', 
	'1' = 'Some Post-HS Education'))[breast$treatment==1])), main = "Higher Education - NFP Population", col = 'dark red', 
	border = 'dark red', ylim = c(0,1))

svymean(~highered, popcomp, na.rm = TRUE)
prop.table(table(breast$highered[breast$treatment==1]))

# English Language Household
par(mfrow = c(1,2))
barplot(svymean(~english, popcomp, na.rm = TRUE), names.arg = c('Non-English Household', 'English Household'), 
	main = "English Language Status - NCHS Population", col = "navy blue", border = 'navy blue', ylim = c(0,1))
barplot(prop.table(table(breast$english[breast$treatment==1], row.names = revalue(breast$english, c('0' = 'Non-English Household', 
	'1' = 'English Household'))[breast$treatment==1])), main = "English Language Status - NFP Population", col = 'dark red', 
	border = 'dark red', ylim = c(0,1))

svymean(~english, popcomp, na.rm = TRUE)
prop.table(table(breast$english[breast$treatment==1]))

# Ever Breastfed
par(mfrow = c(1,2))
barplot(svymean(~breastfed, popcomp, na.rm = TRUE), names.arg = c('Never Breastfed', 'Ever Breastfed'), 
	main = "Breastfeeding - NCHS Population", col = "navy blue", border = 'navy blue', ylim = c(0,1))
barplot(prop.table(table(breast$breastfed[breast$treatment==1], row.names = revalue(breast$breastfed, c('0' = 'Never Breastfed', 
	'1' = 'Ever Breastfed'))[breast$treatment==1])), main = "Breastfeeding - NFP Population", col = 'dark red', 
	border = 'dark red', ylim = c(0,1))

svymean(~breastfed, popcomp, na.rm = TRUE)
prop.table(table(breast$breastfed[breast$treatment == 1]))

# Weeks Breastfed	
par(mfrow = c(1,2))
svyhist(~week_end_breast, popcomp, main = "Weeks Breastfed - NCHS Population", xlab = "Weeks Breastfed", col = "navy blue", 
	border = 'navy blue', ylim = c(0,.09))
hist(breast$week_end_breast[breast$treatment==1], freq = FALSE, main = "Weeks Breastfed - NFP Population",
	xlab = "Weeks Breastfed", col = 'dark red', border = 'dark red', ylim = c(0, .09))

svymean(~week_end_breast, popcomp, na.rm = TRUE) 
mean(breast$week_end_breast[breast$treatment == 1], na.rm = TRUE)


##### Outcome 1: Child was ever breastfed
### Approach 1 - using all complete cases
######## note: matching on complete cases assumes there is no systemic difference btwn nulls and non-nulls

ever_breast1 <- breast[,c(3:13, 15:16)] # Omit data for other outcome measure, also IDs
ever_breast <- subset(ever_breast1, complete.cases(ever_breast1))
matchvars <- c("highschool", "highered", "married", "momsage", "RE", "english")

## PROPENSITY SCORE MATCHING

probit1_1 <- glm(treatment ~ (highschool + married + highered + momsage + RE + english), 
	data = ever_breast, family = binomial(link = "probit"))
# Drop state - too few obs in each state leading to near-perfect separation
summary(probit1_1)

ever_breast$ps <- predict(probit1_1, data = ever_breast, type = "response")
qplot(ever_breast$ps, data = ever_breast, binwidth = .01) + facet_wrap(~treatment)
# Looks pretty good - looks like common support

ever_breastX <- cbind(ever_breast$ps, ever_breast$male, ever_breast$premature, ever_breast$lbw) # Vector of covariates for regression
caliper <- 0.10 # Specify desired caliper for including observations (units are standard deviations)

ever_match1 <- Match(Y = ever_breast$breastfed, Tr = ever_breast$treatment, X = ever_breastX, 
	caliper = caliper, ties = FALSE)
summary(ever_match1) 
MatchBalance(treatment ~ highschool + married + highered + momsage + RE + english, 
	data = ever_breast, match.out=ever_match1, nboots=1000) # Check balance before and after match.
	
#### Propensity matching appears to make balance WORSE in many cases and does not consistently help.  
#### Different models only help when very simple (simple enough that matches are basically exact).
#### See Gary King, Richard Nielsen, Carter Coberley, James E. Pope, and Aaron Wells'
####    "Comparative Effectiveness of Matching Methods for Causal Inference" (12/9/2011, 
####     http://gking.harvard.edu/files/gking/files/psparadox.pdf) for ideas about why.


## COARSENED EXACT MATCHING - http://gking.harvard.edu/files/gking/files/cem.pdf
## Create strata to "coarsen" data (not requiring exact matches, but exact matches within broadened strata).
## Our data naturally contains some coarse strata, so is amenable to this technique.
matchvars <- c("highschool", "highered", "married", "momsage", "RE", "english")
imbalance(group = ever_breast$treatment, data = ever_breast[matchvars]) # Data are similar, but not balanced

# RE is already grouped as finely as we would like (WhiteNH, BlackNH, Hispanic, Other), and 1/0 factors are natural strata.
# Mom's age is very important at low values, but less important as mother ages - create manual cutpoints
agecut_fine <- c(0,12,14,15,16,17,18,19,20,23,26,30,35,40)
agecut_coarser <- c(0,12,15,18,21,25,35)
agecut_coarsest <- c(0,15,18,25)
cemmatch_fine <- cem(treatment = "treatment", data = ever_breast[c("highschool", "highered", "married", "momsage", "RE", "english", 
		"treatment")], eval.imbalance = TRUE, cutpoints = list(momsage = agecut_fine))
cemmatch_coarse <- cem(treatment = "treatment", data = ever_breast[c("highschool", "highered", "married", "momsage", "RE", "english", 
		"treatment")], eval.imbalance = TRUE, cutpoints = list(momsage = agecut_coarser))
cemmatch_coarsest <- cem(treatment = "treatment", data = ever_breast[c("highschool", "highered", "married", "momsage", "RE", "english", 
		"treatment")], eval.imbalance = TRUE, cutpoints = list(momsage = agecut_coarsest))
cemmatch_fine
cemmatch_coarse
cemmatch_coarsest
# balance is much improved by all models

# How to see how data points were stratified, if we hadn't set the cutoffs/groups ourselves:
##cemmatch$breaks$highschool
##cemmatch$breaks$highered
##cemmatch$breaks$married
##cemmatch$breaks$momsage
##cemmatch$breaks$english

estimate1_1_fine <- att(cemmatch_fine, breastfed ~ treatment, data = ever_breast)
estimate1_1_coarse <- att(cemmatch_coarse, breastfed ~ treatment, data = ever_breast)
estimate1_1_coarsest <- att(cemmatch_coarsest, breastfed ~ treatment, data = ever_breast)
estimate1_1_fine
estimate1_1_coarse
estimate1_1_coarsest
# trade off between # of unmatched obs and precision of match (i.e. how perfectly obs match
# but estimates are generally hovering around the same point

## Need to think about introducing controls for lbw, premature, male, etc. to the estimation process


# Accessing paired dataset
matched1_1 <- pair(cemmatch_fine, ever_breast)


barplot(prop.table(table(breast$breastfed[breast$treatment==1], row.names = revalue(breast$breastfed, c('0' = 'Never Breastfed', 
	'1' = 'Ever Breastfed'))[breast$treatment==1])), main = "Breastfeeding - NFP Population", col = 'dark red', 
	border = 'dark red', ylim = c(0,1))

##### Outcome 1: Child was ever breastfed (still)
### Approach 2 - drop higher ed indicator (lots of NAs), THEN use all complete cases
### Repeat CEM using same approach as above

############ Needs to be cleaned up, troubleshoot data sets.

ever_breast2 <- breast[,c(3:6,8:13,15)]
ever_breast_restricted <- subset(ever_breast2, complete.cases(ever_breast2))

matchvars1_2 <- c("highschool", "married", "momsage", "RE", "english")
imbalance(group = ever_breast_restricted$treatment, data = ever_breast_restricted[matchvars]) # Data are similar, but not balanced

# Same three types of age cut points
cemmatch_fine2 <- cem(treatment = "treatment", data = ever_breast_restricted[c("highschool", "married", "momsage", "RE", "english", 
		"treatment")], eval.imbalance = TRUE, cutpoints = list(momsage = agecut_fine))
cemmatch_coarse2 <- cem(treatment = "treatment", data = ever_breast_restricted[c("highschool", "married", "momsage", "RE", "english", 
		"treatment")], eval.imbalance = TRUE, cutpoints = list(momsage = agecut_coarser))
cemmatch_coarsest2 <- cem(treatment = "treatment", data = ever_breast_restricted[c("highschool", "married", "momsage", "RE", "english", 
		"treatment")], eval.imbalance = TRUE, cutpoints = list(momsage = agecut_coarsest))
cemmatch_fine2
cemmatch_coarse2
cemmatch_coarsest2

estimate1_2_fine <- att(cemmatch_fine2, breastfed ~ treatment, data = ever_breast)
estimate1_2_coarse <- att(cemmatch_coarse2, breastfed ~ treatment, data = ever_breast)
estimate1_2_coarsest <- att(cemmatch_coarsest2, breastfed ~ treatment, data = ever_breast)
estimate1_2_fine
estimate1_2_coarse
estimate1_2_coarsest




# Outcome 2: Weeks child was breastfed
weeks_breast <- complete.cases(breast[,c(1:12, 14:15)])