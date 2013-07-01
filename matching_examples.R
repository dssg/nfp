###########################################
##           Partner Programming         ##
##            Matching Examples          ##
###########################################

##Baby Matching (simple matching example, build on this)

e <- rnorm(1000)
x1 <- round(runif(1000,0,1))
x2 <- round(runif(1000,-1,0))
y <- -3 - 2*x1 + x2 + e

#we know that OLS works well
summary(lm(y~x1))
summary(lm(y~x1+x2))


##############
## estimate coefficient for x1

# Because x2 is a discrete variable, it can only take a finite number of values (in this case, 2).
# There are also lots of observations for each combination of x1 and x2.
# Stratification works well in this case.
# Stratification creates blocks of data that are equal on confounding variables.
# Estimates are then generated for each strata, and usually those estimates are weighted across strata.

x0neg1 <- x1==0 & x2==-1
x00 <- x1==0 & x2==0
x1neg1 <- x1==1 & x2==-1
x10 <- x1==1 & x2==0

ATE2neg1 <- (mean(y[x1neg1])-mean(y[x0neg1])) * length(y[x2==-1])/length(y)
ATE20 <- (mean(y[x10])-mean(y[x00])) * length(y[x2==0])/length(y)

ATE <- ATE2neg1 + ATE20   #point estimate 
ATE


# Matching pairs one or more observations 
#Match on x2

data <- cbind(x1,x2,y)
#split into two samples
#r <- sample(1:1000,500,replace=FALSE)
#samples
data1 <- subset(data, x1==1)   #data[r,]
data2 <- subset(data, x1==0)   #data[-r,]

# number of matched cases for each observation
k <- 5
###match sample 1 observations with sample 2 observations

#this is where we'll store the observed difference between the sample and the match
difference <- matrix(NA, nrow(data1), k)  

for(i in 1:nrow(data1)){
  #find k matches on x2 from sample 2
  match_y <- sample(data2[,3][data2[,2]==data1[i,2]], size=k, replace=TRUE)
  difference[i,] <- data1[i,3] - match_y
}
mean(difference)  #point estimate for effect of x1 on y


library(Matching)
match1 <- Match(Y=y, Tr=x1, X=x2, estimand="ATE", M=k, ties=FALSE)
summary(match1)


###########################################
## x2 causes x1 and y

e <- rnorm(1000)
x2 <- round(runif(1000,-1,0))
x1 <- rep(NA, 1000)
x1[x2==-1] <- rbinom(length(x1[x2==-1]),1,.7)
x1[x2==0] <- rbinom(length(x1[x2==0]),1,.3)
y <- -3 - 2*x1 + x2 + e

# regressing on x1 without x2 leads to a biased estimate
lm(y~x1)
lm(y~x1 + x2)


##############
## estimate coefficient for x1

# Stratification

x0neg1 <- x1==0 & x2==-1
x00 <- x1==0 & x2==0
x1neg1 <- x1==1 & x2==-1
x10 <- x1==1 & x2==0

ATE2neg1 <- (mean(y[x1neg1])-mean(y[x0neg1])) * length(y[x2==-1])/length(y)
ATE20 <- (mean(y[x10])-mean(y[x00])) * length(y[x2==0])/length(y)

ATE <- ATE2neg1 + ATE20   #point estimate 
ATE


# Matching pairs one or more observations 
#Match on x2

data <- cbind(x1,x2,y)
#split into two samples
data1 <- subset(data, x1==1)   #data[r,]
data2 <- subset(data, x1==0)   #data[-r,]

# number of matched cases for each observation
k <- 25

###match sample 1 observations with sample 2 observations

#this is where we'll store the observed difference between the sample and the match
difference <- matrix(NA, nrow(data1), k)  

for(i in 1:nrow(data1)){
  #find k matches on x2 from sample 2
  match_y <- sample(data2[,3][data2[,2]==data1[i,2]], size=k, replace=TRUE)
  difference[i,] <- data1[i,3] - match_y
}
mean(difference)  #point estimate for effect of x1 on y


# R package Matching
match2 <- Match(Y=y, Tr=x1, X=x2, estimand="ATE", M=k, ties=FALSE)
summary(match2)





# Propensity score matching

p.hat <- 1 / (1 + exp(-predict(glm(x1~x2, family='binomial'))))
hist(p.hat)


# Matching pairs one or more observations 
#Match on x2

data <- cbind(x1,x2,y,p.hat)
#split into two samples
data1 <- subset(data, x1==1)   #data[r,]
data2 <- subset(data, x1==0)   #data[-r,]

# number of matched cases for each observation
k <- 5
###match sample 1 observations with sample 2 observations

#this is where we'll store the observed difference between the sample and the match
difference <- matrix(NA, nrow(data1), k)  

for(i in 1:nrow(data1)){
  #find k matches on p.hat from sample 2
  match_y <- sample(data2[,3][data2[,4]==data1[i,4]], size=k, replace=TRUE)
  difference[i,] <- data1[i,3] - match_y
}
lm(y~x1+x2)
mean(difference)  #point estimate for effect of x1 on y



#library Matching
match3 <- Match(Y=y, Tr=x1, X=p.hat, estimand="ATE", M=k, ties=FALSE)
summary(match3)
