###########################################
##           Partner Programming         ##
##            Matching Examples          ##
##                                       ##
##                Joe Walsh              ##
##               Emily Rowe              ##
##              Adam Fishman             ##
##               Nick Mader              ##
###########################################

# We want to work through toy examples using various matching algorithms 
# to make sure that understand them.  We start with a really simple 
# data-generating process (DGP), where the two explanatory variables (D and X)
# are dichotomous and exogenously and independently determined, and 
# exact-matching, where we match observations that have equal values on 
# the explanatory variable not of interest.

n <- 1000  #number of observations to test

## generate sample data
e <- rnorm(n)                 # error term
d <- rbinom(n,size=1,p=.5)    # treatment (1=yes, 0=no)
x <- rbinom(n,size=1,p=.5)-1  # other independent cause of Y
y <- -3 - 2*d + x + e       # DGP



##############
# Naive estimator

# The naive estimator takes the average outcome for the treatment group and subtracts
# the average outcome for the control group.  It works in this case because we don't 
# need to control for other variables.
mean(y[d==1]) - mean(y[d==0])



##############
# OLS 
lm(y~d+x)
# OLS estimates d well even if we exclude x (because D and X are independent)
lm(y~d)



##############
## Stratification

# Stratification creates blocks of data that are equal on confounding variables.
# Estimates are then generated for each strata (by OLS, differences in means, or
# something else).  To get the average treatment effect (ATE) unconditional on
# strata, weight those estimates across strata.

D0Xneg1 <- d==0 & x==-1
D0X0    <- d==0 & x== 0
D1Xneg1 <- d==1 & x==-1
D1X0    <- d==1 & x== 0

# ATE conditional on X=-1
ateXneg1 <- mean(y[D1Xneg1]) - mean(y[D0Xneg1])
# ATE conditional on X=0
ateX0    <- mean(y[D1X0]) - mean(y[D0X0])

# ATE unconditional on X
prob.X0 <- sum(x==0)/length(x)  # sample proportion where x=0
ATE <- ateXneg1*(1-prob.X0) + ateX0*(prob.X0)
ATE



##############
## Matching

# Matching is a type of stratification.  The difference is in how many units are being
# compared at once.  With stratification we look at the difference in outcomes between
# the treatment group and the control group at one time for all observations where X=x,
# but with matching we look at the difference in outcomes at one time between one observation 
# where X=x and k members of the control group where X=x.

# it is easier to sample from a matrix for this example
data <- cbind(d,x,y)
#split into two samples
data1 <- subset(data, d==1)   #treatment group
data2 <- subset(data, d==0)   #control group

# number of matched cases for each observation.  Simplest is 1 to 1, but we can match to several
k <- 5

# We will match k observations from the control group to 1 observation from the 
# treatment group.  To do that, I store k differences in outcomes for each observation
# in the treatment group.
difference <- matrix(NA, nrow(data1), k)  

# cycle through each treatment observation
for(i in 1:nrow(data1)){
  # find k matches on x from sample 2
  # because there are more than k matches, I randomly select k matches with replacement
  match_y <- sample(data2[,3][data2[,2]==data1[i,2]], size=k, replace=TRUE)

  # store the differences in outcomes between the treatment observation and the control obs.
  difference[i,] <- data1[i,3] - match_y
}
mean(difference)  #point estimate for effect of d on y


# R's Matching package gives similar results.  The results are unlikely to be exactly
# the same because we each randomly select observations from the control group.
library(Matching)
match1 <- Match(Y=y, Tr=d, X=x, estimand="ATE", M=k, ties=FALSE)
summary(match1)



##############
# Propensity Score Matching

# Our previous matching example used exact matching, where observations were matched on
# identical values of x.  Unfortunately, exact matching often fails for continuous X or
# X with many categories (because there will be few, if any, cases to match with).  One
# way to deal with that sparseness is to match on propensity score.  The propensity score
# is the probability that an individual receives the treatment.  So, for example, 
#
#   1) if income, age, and education determine the probability of a pregnant woman 
#      enrolling in NFP;
#   2) an enrolled 20-year-old woman with a high-school diploma and an income of $50,000 
#      had a probability of 0.70 of enrolling; and 
#   3) a non-enrolled 30-year-old with a college education and an income of $35,000 had
#      a probability of 0.70 of enrolling,
#
# we could get a good estimate by matching them.
#
# Here's PSM using the same example.

# Predicted probability of treatment for each person using logistic regression,
# where we regress treatment on x
treatment_regression <- glm(d~x, family=binomial(link="logit"))
p.hat <- 1 / (1 + exp(-predict(treatment_regression)))
hist(p.hat)

# Matching pairs one or more observations 
data <- cbind(d,x,y,p.hat)
#split into two samples
data1 <- subset(data, d==1)   # treatment group
data2 <- subset(data, d==0)   # control group

#this is where we'll store the observed difference between the sample and the match
difference <- matrix(NA, nrow(data1), k)  

# cycle through each observation in the treatment group
for(i in 1:nrow(data1)){
  # find k matches on p.hat from the control group
  # because there are more than k potential matches, we randomly select k of them
  match_y <- sample(data2[,3][data2[,4]==data1[i,4]], size=k, replace=TRUE)
  
  # store the differences
  difference[i,] <- data1[i,3] - match_y
}
mean(difference)  #point estimate for effect of x1 on y


# R's Matching library doing PSM
match3 <- Match(Y=y, Tr=d, X=p.hat, estimand="ATE", M=k, ties=FALSE)
summary(match3)






###########################################
## More Complicated Data-Generating Process

# In the previous DGP, treatment (D) was assigned independently from X, but that's
# rarely true for observational data.  In this example X causes D and Y.

e <- rnorm(n)                     # error term
x <- rbinom(n, size=1, p=.5)-1    # sample X
d <- rep(NA, n)                   # probability of treatment varies with X
d[x==-1] <- rbinom(length(d[x==-1]),1,.7)
d[x== 0] <- rbinom(length(d[x== 0]),1,.3)
y <- -3 - 2*d + x + e           # DGP




##############
# Naive estimator

# The naive estimator doesn't work well here because it does not control for X,
# a common cause of D and Y.
mean(y[d==1]) - mean(y[d==0])




##############
# OLS 
lm(y~d+x)
# Regressing only on d leads to a biased estimate.  Need to control for x
lm(y~d)




##############
# Stratification

D0Xneg1 <- d==0 & x==-1
D0X0    <- d==0 & x== 0
D1Xneg1 <- d==1 & x==-1
D1X0    <- d==1 & x== 0

# ATE conditional on X=-1
ateXneg1 <- mean(y[D1Xneg1]) - mean(y[D0Xneg1])
# ATE conditional on X=0
ateX0    <- mean(y[D1X0]) - mean(y[D0X0])

# ATE unconditional on X
prob.X0 <- sum(x==0)/length(x)  # sample proportion where x=0
ATE <- ateXneg1*(1-prob.X0) + ateX0*(prob.X0)
ATE




##############
# Matching

data <- cbind(d,x,y)
# split into two samples
data1 <- subset(data, d==1)
data2 <- subset(data, d==0) 

# number of matched cases for each observation
k <- 5

# this is where we'll store the observed difference between the sample and the match
difference <- matrix(NA, nrow(data1), k)  

# cycle through each observation in the treatment group
for(i in 1:nrow(data1)){
  # find k matches on x from sample 2
  # because we have more than k possible matches, we randomly select k of them
  match_y <- sample(data2[,3][data2[,2]==data1[i,2]], size=k, replace=TRUE)

  # store the difference
  difference[i,] <- data1[i,3] - match_y
}
mean(difference)  #point estimate for effect of d on y


# compare to R's Matching results
match2 <- Match(Y=y, Tr=d, X=x, estimand="ATE", M=k, ties=FALSE)
summary(match2)





##############
# Propensity Score Matching

treatment_regression <- glm(d~x, family=binomial(link='logit'))
p.hat <- 1 / (1 + exp(-predict(treatment_regression)))
hist(p.hat)

# Again, it's easier to sample from a matrix than from multiple vectors
data <- cbind(d,x,y,p.hat)
#split into two samples
data1 <- subset(data, d==1)   # treatment group
data2 <- subset(data, d==0)   # control group

# number of matched cases for each observation
k <- 5

#this is where we'll store the observed difference between the sample and the match
difference <- matrix(NA, nrow(data1), k)  

# cycle through each treatment observation
for(i in 1:nrow(data1)){
  # find k matches on p.hat from the control group
  # because there are more than k potential matches, we randomly select k of them
  match_y <- sample(data2[,3][data2[,4]==data1[i,4]], size=k, replace=TRUE)

  # store the differences
  difference[i,] <- data1[i,3] - match_y
}
mean(difference)  #point estimate for effect of d on y


# compare to R's Matching library
match3 <- Match(Y=y, Tr=d, X=p.hat, estimand="ATE", M=k, ties=FALSE)
summary(match3)





######################################
## Average treatment effect for the treated (ATET) and control (ATEC)
# So far we have assumed the same treatment effect for the treatment and control groups.
# However, the treatment effect may vary differ for those groups.  For example, only those
# who would benefit the most from college enroll.  Furthermore, the ATET or ATEC might be
# more interesting quantities.  For instance, we might want to know the effect of a drug
# on the people who took it, not the people who did not take it, since it wasn't intended
# for healthy people.  It is also possible that we do not feel comfortable making all the 
# assumptions necessary to estimate the ATE.  
#
# Here is the new data-generating process, where the treatment effect varies and those
# who have a positive treatment effect are more likely to enroll.

e <- rnorm(n)
x <- rbinom(n, size=1, prob=.5)-1
beta <- rbinom(n, size=1, prob=.3)  # effect for some is positive 1, for others -2
  beta[beta==0] <- -10
d <- rbinom(n, size=1, prob=.8)     # ppl with positive effect more likely to enroll
  d[beta==-10] <- rbinom(length(beta[beta==-10]), size=1, prob=.4)
y <- -3 + beta*d + 5*x + e  # DGP
data <- as.data.frame(cbind(d,x,beta,y))


# Note that we cannot estimate the ATET by looking at the treated group only
# because there is no variation on the treatment variable
d.treated <- coef(lm(y~d+x, data=subset(data,d==1)))[2]
d.treated

# Nor can we estimate the ATEC by looking at the control group only
# because there is no variation on the treatment variable
d.control <- coef(lm(y~d+x, data=subset(data,d==0)))[2]
d.control

# How to calculate ATET when we don't observe untreated outcomes for the treated observations?
# "Progress can be made by assuming that selection into treatment depends on observable 
# covariates X" (http://sekhon.berkeley.edu/papers/MatchingJSS.pdf).  Assume that 
# conditioning on X creates exchangability, i.e.
# E[Y(1)|X,D=1] = E[Y(1)|X,D=0]  and  E[Y(0)|X,D=1] = E[Y(0)|X,D=0]





##############
## Stratification

# ATET: E[Y(1)-Y(0)|D=1] = E[Y(1)|D=1] - E[Y(0)|D=1]
# w/ ignorability:       = E[Y(1)|X= 0,D=1] - E[Y(0)|X= 0,D=0] and
#                        = E[Y(1)|X=-1,D=1] - E[Y(0)|X=-1,D=0]
# weight by value of X:  = (E[Y(1)|X= 0,D=1] - E[Y(0)|X= 0,D=0]) * Pr(X= 0|D=1) + 
#                          (E[Y(1)|X=-1,D=1] - E[Y(0)|X=-1,D=0]) * Pr(X=-1|D=1)
(mean(y[x== 0 & d==1]) - mean(y[x== 0 & d==0])) * sum(x== 0 & d==1)/sum(d==1) +
(mean(y[x==-1 & d==1]) - mean(y[x==-1 & d==0])) * sum(x==-1 & d==1)/sum(d==1)



# We can do the same thing for ATEC.
# ATEC: E[Y(1)-Y(0)|D=0] = E[Y(1)|D=0] - E[Y(0)|D=0]
# w/ ignorability:       = E[Y(1)|X= 0,D=1] - E[Y(0)|X= 0,D=0] and
#                          E[Y(1)|X=-1,D=1] - E[Y(0)|X=-1,D=0]
# weight by value of X:  = (E[Y(1)|X= 0,D=1] - E[Y(0)|X= 0,D=0]) * Pr(X= 0|D=0) + 
#                          (E[Y(1)|X=-1,D=1] - E[Y(0)|X=-1,D=0]) * Pr(X=-1|D=0)
(mean(y[x== 0 & d==1]) - mean(y[x== 0 & d==0])) * sum(x== 0 & d==0)/sum(d==0) +
(mean(y[x==-1 & d==1]) - mean(y[x==-1 & d==0])) * sum(x==-1 & d==0)/sum(d==0)





##############
## Matching

# it is easier to sample from a matrix for this example
data <- cbind(d,x,y)
#split into two samples
data1 <- subset(data, d==1)   #treatment group
data2 <- subset(data, d==0)   #control group

# We will match k observations (assigned earlier) from the control group to 1 observation
# from the treatment group.  To do that, I store k differences in outcomes for each 
# observation in the treatment group.
difference <- matrix(NA, nrow(data1), k)  

# cycle through each treatment observation
for(i in 1:nrow(data1)){
  # find k matches on x from sample 2
  # because there are more than k matches, I randomly select k matches with replacement
  match_y <- sample(data2[,3][data2[,2]==data1[i,2]], size=k, replace=TRUE)
  
  # store the differences in outcomes between the treatment observation and the control obs.
  difference[i,] <- data1[i,3] - match_y
}
ATE.X0    <- mean(subset(difference, data1[,2]== 0)) 
ATE.Xneg1 <- mean(subset(difference, data1[,2]==-1)) 


# ATET
# ATET = ATE.XO*Pr(X=0|D=1) + ATE.Xneg1*Pr(X=-1|D=1)
ATET <- ATE.X0 * mean(data1[,2]==0)  +  ATE.Xneg1 * mean(data1[,2]==-1)
ATET

# The Matching package gives similar results
library(Matching)
match4 <- Match(Y=y, Tr=d, X=x, estimand="ATT", M=k, ties=FALSE)
summary(match4)





# ATEC
# ATEC = ATE.XO*Pr(X=0|D=0) + ATE.Xneg1*Pr(X=-1|D=0)
# In other words, we can use the same ATE.X0 and ATE.Xneg1 but weight them
# using Pr(X=0|D=0) and Pr(X=-1|D=0)
ATEC <- ATE.X0 * mean(data2[,2]==0)  +  ATE.Xneg1 * mean(data2[,2]==-1)
ATEC

# The Matching package gives similar results
match5 <- Match(Y=y, Tr=d, X=x, estimand="ATC", M=k, ties=FALSE)
summary(match5)







######################################
## More complex ATET and ATEC example
## The distribution of X varies with treatment 

e <- rnorm(n)
beta <- rbinom(n, size=1, prob=.3)  #effect for some is positive 1, for others -10
  beta[beta==0] <- -10
d <- rbinom(n, size=1, prob=.8)  #ppl with positive effect more likely to enroll
  d[beta==-10] <- rbinom(length(beta[beta==-10]), size=1, prob=.4)
x <- rbinom(n, size=1, prob=.7)-1
  x[d==1] <- rbinom(sum(d==1), size=1, prob=.1)-1
y <- -3 + beta*d + 5*x + e  # DGP
data <- as.data.frame(cbind(d,x,beta,y))



##############
## Stratification

# ATET: E[Y(1)-Y(0)|D=1] = E[Y(1)|D=1] - E[Y(0)|D=1]
# w/ ignorability:       = E[Y(1)|X= 0,D=1] - E[Y(0)|X= 0,D=0] and
#                          E[Y(1)|X=-1,D=1] - E[Y(0)|X=-1,D=0]
# weight by value of X:  = (E[Y(1)|X= 0,D=1] - E[Y(0)|X= 0,D=0]) * Pr(X= 0|D=1) + 
#                          (E[Y(1)|X=-1,D=1] - E[Y(0)|X=-1,D=0]) * Pr(X=-1|D=1)
(mean(y[x== 0 & d==1]) - mean(y[x== 0 & d==0])) * sum(x== 0 & d==1)/sum(d==1) +
(mean(y[x==-1 & d==1]) - mean(y[x==-1 & d==0])) * sum(x==-1 & d==1)/sum(d==1)



# We can do the same thing for ATEC.
# ATEC: E[Y(1)-Y(0)|D=0] = E[Y(1)|D=0] - E[Y(0)|D=0]
# w/ ignorability:       = E[Y(1)|X= 0,D=1] - E[Y(0)|X= 0,D=0] and
#                          E[Y(1)|X=-1,D=1] - E[Y(0)|X=-1,D=0]
# weight by value of X:  = (E[Y(1)|X= 0,D=1] - E[Y(0)|X= 0,D=0]) * Pr(X= 0|D=0) + 
#                          (E[Y(1)|X=-1,D=1] - E[Y(0)|X=-1,D=0]) * Pr(X=-1|D=0)
(mean(y[x== 0 & d==1]) - mean(y[x== 0 & d==0])) * sum(x== 0 & d==0)/sum(d==0) +
(mean(y[x==-1 & d==1]) - mean(y[x==-1 & d==0])) * sum(x==-1 & d==0)/sum(d==0)





##############
## Matching

# it is easier to sample from a matrix for this example
data <- cbind(d,x,y)
#split into two samples
data1 <- subset(data, d==1)   #treatment group
data2 <- subset(data, d==0)   #control group

# We will match k observations (assigned earlier) from the control group to 1 observation
# from the treatment group.  To do that, I store k differences in outcomes for each 
# observation in the treatment group
difference <- matrix(NA, nrow(data1), k)  

# cycle through each treatment observation
for(i in 1:nrow(data1)){
  # find k matches on x from sample 2
  # because there are more than k matches, I randomly select k matches with replacement
  match.y <- sample(data2[,3][data2[,2]==data1[i,2]], size=k, replace=TRUE)
    
  # store the differences in outcomes between the treatment observation and the control obs.
  difference[i,] <- data1[i,3] - match.y
}
ATE.X0    <- mean(subset(difference, data1[,2]== 0)) 
ATE.Xneg1 <- mean(subset(difference, data1[,2]==-1)) 




# ATET
# ATET = ATE.XO*Pr(X=0|D=1) + ATE.Xneg1*Pr(X=-1|D=1)
ATET <- ATE.X0 * mean(data1[,2]==0)  +  ATE.Xneg1 * mean(data1[,2]==-1)
ATET

# The Matching package gives similar results
library(Matching)
match6 <- Match(Y=y, Tr=d, X=x, estimand="ATT", M=k, ties=FALSE)
summary(match6)




# ATEC
# ATEC = ATEC.XO*Pr(X=0|D=1) + ATEC.Xneg1*Pr(X=-1|D=1)
ATEC <- ATE.X0 * mean(data2[,2]==0)  +  ATE.Xneg1 * mean(data2[,2]==-1)
ATEC

# The Matching package gives similar results
library(Matching)
match7 <- Match(Y=y, Tr=d, X=x, estimand="ATC", M=k, ties=FALSE)
summary(match7)



# ATE
# ATE is a weighted average of ATET and ATEC
# ATE = ATET*Pr(D=1) + ATEC*Pr(D=0)
ATE <- ATET * mean(d==1)  +  ATEC * mean(d==0) 
ATE

# The Matching package gives similar results
library(Matching)
match8 <- Match(Y=y, Tr=d, X=x, estimand="ATE", M=k, ties=FALSE)
summary(match8)
