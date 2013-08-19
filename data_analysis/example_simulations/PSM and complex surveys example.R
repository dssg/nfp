##########################
## Replicate Zanutto (2006)

n <- 1000

x1 <- runif(n, 0, 2)
x2 <- runif(n, 0, 2)

d <- rbinom(n, 1, 1/(1+exp(3-x1-x2)))

y <- 3*d + 2*x1 + 2*x2 + rnorm(n)

# naive estimator
mean(y[d==1]) - mean(y[d==0])

psm_reg <- glm(d ~ x1+x2)
p.hat <- predict(psm_reg)

data <- data.frame(cbind(y, d, x1, x2, p.hat))

strata.cutoffs <- quantile(data$p.hat[data$d==1], 1:4/5)

stratum1 <- data.frame(subset(data, p.hat<strata.cutoffs[1]))
  #mean(stratum1$x1[stratum1$d==1]) - mean(stratum1$x1[stratum1$d==0])
  #mean(stratum1$x2[stratum1$d==1]) - mean(stratum1$x2[stratum1$d==0])
  #sum(stratum1$d==1); sum(stratum1$d==0)

  term.a <- var(stratum1$y[stratum1$d==1])/sum(stratum1$d==1)
  term.b <- var(stratum1$y[stratum1$d==0])/sum(stratum1$d==0)
  sd.part1 <- sum(stratum1$d==1)^2 / sum(d==1)^2 * (term.a + term.b)

  ate1 <- mean(stratum1$y[stratum1$d==1]) - mean(stratum1$y[stratum1$d==0])
  sqrt(term.a + term.b)  # standard error for this stratum

stratum2 <- data.frame(subset(data, p.hat>=strata.cutoffs[1] & p.hat<strata.cutoffs[2]))
  #mean(stratum2$x1[stratum2$d==1]) - mean(stratum2$x1[stratum2$d==0])
  #mean(stratum2$x2[stratum2$d==1]) - mean(stratum2$x2[stratum2$d==0])
  #sum(stratum2$d==1); sum(stratum2$d==0)
  
  term.a <- var(stratum2$y[stratum2$d==1])/sum(stratum2$d==1)
  term.b <- var(stratum2$y[stratum2$d==0])/sum(stratum1$d==0)
  sd.part2 <- sum(stratum2$d==1)^2 / sum(d==1)^2 * (term.a + term.b)

  ate2 <- mean(stratum2$y[stratum2$d==1]) - mean(stratum2$y[stratum2$d==0])
  sqrt(term.a + term.b)  # standard error for this stratum

stratum3 <- data.frame(subset(data, p.hat>=strata.cutoffs[2] & p.hat<strata.cutoffs[3]))
  #mean(stratum3$x1[stratum3$d==1]) - mean(stratum3$x1[stratum3$d==0])
  #mean(stratum3$x2[stratum3$d==1]) - mean(stratum3$x2[stratum3$d==0])
  #sum(stratum3$d==1); sum(stratum3$d==0)

  term.a <- var(stratum3$y[stratum3$d==1])/sum(stratum3$d==1)
  term.b <- var(stratum3$y[stratum3$d==0])/sum(stratum3$d==0)
  sd.part3 <- sum(stratum3$d==1)^2 / sum(d==1)^2 * (term.a + term.b)

  ate3 <- mean(stratum3$y[stratum3$d==1]) - mean(stratum3$y[stratum3$d==0])
  sqrt(term.a + term.b)  # standard error for this stratum

stratum4 <- data.frame(subset(data, p.hat>=strata.cutoffs[3] & p.hat<strata.cutoffs[4]))
  #mean(stratum4$x1[stratum4$d==1]) - mean(stratum4$x1[stratum4$d==0])
  #mean(stratum4$x2[stratum4$d==1]) - mean(stratum4$x2[stratum4$d==0])
  #sum(stratum4$d==1); sum(stratum4$d==0)

  term.a <- var(stratum4$y[stratum4$d==1])/sum(stratum4$d==1)
  term.b <- var(stratum4$y[stratum4$d==0])/sum(stratum4$d==0)
  sd.part4 <- sum(stratum4$d==1)^2 / sum(d==1)^2 * (term.a + term.b)

  ate4 <- mean(stratum4$y[stratum4$d==1]) - mean(stratum4$y[stratum4$d==0])
  sqrt(term.a + term.b)  # standard error for this stratum

stratum5 <- data.frame(subset(data, p.hat>=strata.cutoffs[4]))
  #mean(stratum5$x1[stratum5$d==1]) - mean(stratum5$x1[stratum5$d==0])
  #mean(stratum5$x2[stratum5$d==1]) - mean(stratum5$x2[stratum5$d==0])
  #sum(stratum5$d==1); sum(stratum5$d==0)
  
  term.a <- var(stratum5$y[stratum5$d==1])/sum(stratum5$d==1)
  term.b <- var(stratum5$y[stratum5$d==0])/sum(stratum5$d==0)
  sd.part5 <- sum(stratum5$d==1)^2 / sum(d==1)^2 * (term.a + term.b)

  ate5 <- mean(stratum5$y[stratum5$d==1]) - mean(stratum5$y[stratum5$d==0])
  sqrt(term.a + term.b)  # standard error for this stratum


ate <- ate1*dim(stratum1)[1]/n + 
       ate2*dim(stratum2)[1]/n + 
       ate3*dim(stratum3)[1]/n + 
       ate4*dim(stratum4)[1]/n + 
       ate5*dim(stratum5)[1]/n 
ate

ate.sd <- sqrt(sd.part1 + sd.part2 + sd.part3 + sd.part4 + sd.part5)
ate.sd


summary(lm(y~d+x1+x2))







##########################
## Simulate NFP analysis
##
## Zanutto (2006) argues that we need to use sample weights after propensity score matching.
## But she is using a single, pre-weighted sample.  We are using a census of enrolled mothers
## and a matched set of mothers from the general population, who come from a pre-weighted 
## sample of the general population.  
## 
## For simplicity, assume there is a superpopulation of mothers with a skewed income distribution
## Low-income mothers are eligible to enroll in NFP
## Their education and marital status influence whether they enroll
## We observe all enrolled mothers and a complex sample of the other mothers

## Define superpopulation
library(mvtnorm)
sigma <- matrix(c(1,.5,.5, .5,1,.5, .5,.5,1), ncol=3)
mu <- c(5,1,-1)

## Generate population
N <- 1000000
population <- data.frame(rmvnorm(N, mean=mu, sigma=sigma))
  names(population) <- c("income", "HS", "married")
  population$income <- 2000*1.5^(population$income)
  population$HS <- rbinom(N, 1, prob=pnorm(population$HS))
  population$married <- rbinom(N, 1, prob=pnorm(population$married))
  population$NFP <- 0

## Assignment to NFP
## Eligible if bottom 25% in income.  HS grad, married affect self selection.
population$NFP[population$income < quantile(population$income,.25)] <- 
  rbinom(sum(population$income < quantile(population$income,.25)), 1, 
         prob=1/(1+exp(1 + .1*population$HS + .1*population$married)))

## NFP census
NFP <- subset(population, NFP==1)

## Sample from general population
rows <- sample(1:N, 5000, replace=TRUE)
general_pop_sample <- population[rows,]

