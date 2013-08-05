library(Matching)
library(ggplot2)
library(cem)
library(survey)

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

## Prepare full population sample for general comparison
### Notes about NSCH:
########### Strata: STATE and SAMPLE
########### PSU: ID
########### Weight: NSCHWT
#http://faculty.washington.edu/tlumley/survey/example-design.html

popsvy <- svydesign(id = ~ID, strata = ~State * SAMPLE, weights = ~NSCHWT, data = pop) 
popcomp <- subset(popsvy, AGEYR_CHILD <= 4 & AGEPOS4<=2 & (!is.element(FAM_MAR_COHAB, c(7,8,9))))
# Limited to the population of first time moms

# Population level comparisons of breastfeeding outcomes!
svymean(~breastfed, popcomp, na.rm = TRUE) # Full population of first time moms
mean(breast$breastfed[breast$treatment == 1], na.rm = TRUE)  # NFP mothers

svymean(~week_end_breast, popcomp, na.rm = TRUE) 
mean(breast$week_end_breast[breast$treatment == 1], na.rm = TRUE)

##### Outcome 1: Child was ever breastfed
### Approach 1 - using all complete cases
######## NOTE THAT THIS ASSUMES THERE IS NO BIAS - NO SYSTEMIC DIFFERENCE BTWN NULLS AND NON-NULLS

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
	
#### Propensity matching appears to make balance WORSE in many cases.  
#### Different models only help when very simple (simple enough that matches are basically exact).
#### See Gary King, Richard Nielsen, Carter Coberley, James E. Pope, and Aaron Wells'
####    "Comparative Effectiveness of Matching Methods for Causal Inference" (12/9/2011, 
####     http://gking.harvard.edu/files/gking/files/psparadox.pdf) for ideas about why.


## COURSENED EXACT MATCHING - http://gking.harvard.edu/files/gking/files/cem.pdf
matchvars <- c("highschool", "highered", "married", "momsage", "RE", "english")
imbalance(group = ever_breast$treatment, data = ever_breast[matchvars]) # Data are similar, but not balanced

# For purposes of CEM, we should set the 1/0 variables to factors -- reduce the number of possible strata
ever_breast$highschool <- factor(ever_breast$highschool)
ever_breast$highered <- factor(ever_breast$highered)
ever_breast$married <- factor(ever_breast$married)
ever_breast$english <- factor(ever_breast$english)
# RE is already grouped as finely as we would like (WhiteNH, BlackNH, Hispanic, Other)
# Mom's age is very important at low values, but less important as mother ages - create manual cutpoints
agecut <- c(0,12,14,15,16,17,18,19,20,23,26,30,35,40)
cemmatch <- cem(treatment = "treatment", data = ever_breast[c("highschool", "highered", "married", "momsage", "RE", "english", 
		"treatment")], eval.imbalance = TRUE, cutpoints = list(momsage = agecut))
cemmatch # summary of results - balance is much improved
# How to see how data points were stratified, if we hadn't set the cutoffs/groups ourselves:
##cemmatch$breaks$highschool
##cemmatch$breaks$highered
##cemmatch$breaks$married
##cemmatch$breaks$momsage
##cemmatch$breaks$english

estimate1_1 <- att(cemmatch, breastfed ~ treatment, data = ever_breast)

	

##### Outcome 1: Child was ever breastfed (still)
### Approach 2 - drop higher ed indicator (lots of NAs), THEN use all complete cases
ever_breast2 <- breast[,c(3:6,8:13,15)]
ever_breast_restricted <- subset(ever_breast2, complete.cases(ever_breast2))





# Outcome 2: Weeks child was breastfed
weeks_breast <- complete.cases(breast[,c(1:12, 14:15)])