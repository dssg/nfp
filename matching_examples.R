###########################################
##           Partner Programming         ##
##            Matching Examples          ##
###########################################

##Baby Matching (simplest matching example possible, build on this)

e <- rnorm(1000)
x <- round(runif(1000, -2, 2))
y <- 5 - 2*x + e

#We know that OLS works well
summary(lm(y~x))

######################
#Stratify
Xneg2 <- x==-2
Xneg1 <- x==-1
X0 <- x==0
X1 <- x==1
X2 <- x==2

ATEneg2 <- mean(y[Xneg2]) * length(y[Xneg2])/length(y)
ATEneg1 <- mean(y[Xneg1]) * length(y[Xneg1])/length(y)
ATE0 <- mean(y[X0]) * length(y[X0])/length(y)
ATE1 <- mean(y[X1]) * length(y[X1])/length(y)
ATE2 <- mean(y[X2]) * length(y[X2])/length(y)

#Here's the point estimate for the intercept
ATE <- ATEneg2 + ATEneg1 + ATE0 + ATE1 + ATE2



######################
#Let's try matching!

###put x and y into a matrix because it's easier to sample from
data <- cbind(x,y)
#split into two samples
r <- sample(1:1000,500,replace=FALSE)
#samples
data1 <- data[r,]
data2 <- data[-r,]


###match sample 1 observations with sample 2 observations

#how many matches?  (i.e. k?)
k=5

#this is where we'll store the observed difference between the sample and the match
difference <- matrix(NA,500,k)  

for(i in 1:nrow(data1)){
  #find five matches on x from sample 2
  match_y <- sample(data2[,2][data2[,1]==data1[i,1]], size=k, replace=TRUE)
  difference[i,] <- match_y
}
mean(difference)  #ATE
#As with stratification, we get a decent estimate of the intercept here.


################################
#What about if we have two independent variables? We're interested in the effect of x2.
e <- rnorm(1000)
x1 <- round(runif(1000,-2,1))
x2 <- round(runif(1000,-1,3))
y <- -3 + x1 + x2 + e

data <- cbind(x1,x2,y)
#split into two samples
r <- sample(1:1000,500,replace=FALSE)
#samples
data1 <- data[r,]
data2 <- data[-r,]


###match sample 1 observations with sample 2 observations

#this is where we'll store the observed difference between the sample and the match
difference <- matrix(NA,500,k)  

for(i in 1:nrow(data1)){
  #find five matches on x1 and x2 from sample 2
  match_y <- sample(data2[,3][data2[,1]==data1[i,1] & data2[,2]==data1[i,2]], 
                    size=k, replace=TRUE)
  difference[i,] <- match_y
}
mean(difference)  #ATE
