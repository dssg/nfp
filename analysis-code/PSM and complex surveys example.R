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
  mean(stratum1$x1[stratum1$d==1]) - mean(stratum1$x1[stratum1$d==0])
  mean(stratum1$x2[stratum1$d==1]) - mean(stratum1$x2[stratum1$d==0])
  sum(stratum1$d==1); sum(stratum1$d==0)
  ate1 <- mean(stratum1$y[stratum1$d==1]) - mean(stratum1$y[stratum1$d==0])

  term.a <- (stratum1$y[stratum1$d==1] - mean(stratum1$y[stratum1$d==1]))^2 / sum(stratum1$d==1)
  term.b <- (stratum1$y[stratum1$d==0] - mean(stratum1$y[stratum1$d==0]))^2 / sum(stratum1$d==0)
  sd.part1 <- sum(stratum1$d==0)^2 / sum(d==0)^2 * (sum(term.a) + sum(term.b))
  
stratum2 <- data.frame(subset(data, p.hat>=strata.cutoffs[1] & p.hat<strata.cutoffs[2]))
  mean(stratum2$x1[stratum2$d==1]) - mean(stratum2$x1[stratum2$d==0])
  mean(stratum2$x2[stratum2$d==1]) - mean(stratum2$x2[stratum2$d==0])
  sum(stratum2$d==1); sum(stratum2$d==0)
  ate2 <- mean(stratum2$y[stratum2$d==1]) - mean(stratum2$y[stratum2$d==0])

  term.a <- (stratum2$y[stratum2$d==1] - mean(stratum2$y[stratum2$d==1]))^2 / sum(stratum2$d==1)
  term.b <- (stratum2$y[stratum2$d==0] - mean(stratum2$y[stratum2$d==0]))^2 / sum(stratum2$d==0)
  sd.part2 <- sum(stratum2$d==0)^2 / sum(d==0)^2 * (sum(term.a) + sum(term.b))

stratum3 <- data.frame(subset(data, p.hat>=strata.cutoffs[2] & p.hat<strata.cutoffs[3]))
  mean(stratum3$x1[stratum3$d==1]) - mean(stratum3$x1[stratum3$d==0])
  mean(stratum3$x2[stratum3$d==1]) - mean(stratum3$x2[stratum3$d==0])
  sum(stratum3$d==1); sum(stratum3$d==0)
  ate3 <- mean(stratum3$y[stratum3$d==1]) - mean(stratum3$y[stratum3$d==0])

  term.a <- (stratum3$y[stratum3$d==1] - mean(stratum3$y[stratum3$d==1]))^2 / sum(stratum3$d==1)
  term.b <- (stratum3$y[stratum3$d==0] - mean(stratum3$y[stratum3$d==0]))^2 / sum(stratum3$d==0)
  sd.part3 <- sum(stratum3$d==0)^2 / sum(d==0)^2 * (sum(term.a) + sum(term.b))

stratum4 <- data.frame(subset(data, p.hat>=strata.cutoffs[3] & p.hat<strata.cutoffs[4]))
  mean(stratum4$x1[stratum4$d==1]) - mean(stratum4$x1[stratum4$d==0])
  mean(stratum4$x2[stratum4$d==1]) - mean(stratum4$x2[stratum4$d==0])
  sum(stratum4$d==1); sum(stratum4$d==0)
  ate4 <- mean(stratum4$y[stratum4$d==1]) - mean(stratum4$y[stratum4$d==0])

  term.a <- (stratum4$y[stratum4$d==1] - mean(stratum4$y[stratum4$d==1]))^2 / sum(stratum4$d==1)
  term.b <- (stratum4$y[stratum4$d==0] - mean(stratum4$y[stratum4$d==0]))^2 / sum(stratum4$d==0)
  sd.part4 <- sum(stratum4$d==0)^2 / sum(d==0)^2 * (sum(term.a) + sum(term.b))

stratum5 <- data.frame(subset(data, p.hat>=strata.cutoffs[4]))
  mean(stratum5$x1[stratum5$d==1]) - mean(stratum5$x1[stratum5$d==0])
  mean(stratum5$x2[stratum5$d==1]) - mean(stratum5$x2[stratum5$d==0])
  sum(stratum5$d==1); sum(stratum5$d==0)
  ate5 <- mean(stratum5$y[stratum5$d==1]) - mean(stratum5$y[stratum5$d==0])

  term.a <- (stratum5$y[stratum5$d==1] - mean(stratum5$y[stratum5$d==1]))^2 / sum(stratum5$d==1)
  term.b <- (stratum5$y[stratum5$d==0] - mean(stratum5$y[stratum5$d==0]))^2 / sum(stratum5$d==0)
  sd.part5 <- sum(stratum5$d==0)^2 / sum(d==0)^2 * (sum(term.a) + sum(term.b))

ate <- ate1*dim(stratum1)[1]/n + 
       ate2*dim(stratum2)[1]/n + 
       ate3*dim(stratum3)[1]/n + 
       ate4*dim(stratum4)[1]/n + 
       ate5*dim(stratum5)[1]/n 
ate

ate.sd <- sqrt(sd.part1 + sd.part2 + sd.part3 + sd.part4 + sd.part5)
ate.sd
