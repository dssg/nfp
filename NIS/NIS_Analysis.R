##################################
##    Data Preparation File     ##
## National Immunization Survey ##
##         Joe Walsh            ##
##         Emily Rowe           ##
##        Adam Fishman          ##
##################################


load("/mnt/data/NIS/immunizations_analysis.RData")




##########################################
## Plot states with NFP programs
library(maps)
m <- map("state", interior = FALSE, plot=FALSE)

m$my.colors <- 0
m$names
m$my.colors[m$names %in% c("alabama","arizona","california","colorado","delaware",
                           "florida","iowa","illinois","kentucky","louisiana",
                           "maryland","michigan:north","michigan:south",
                           "minnesota","missouri","north carolina:main",
                           "north carolina:knotts","north carolina:spit",
                           "north dakota","new jersey","nevada","new york:main",
                           "new york:manhattan","new york:staten island",
                           "new york:long island","ohio","oklahoma","oregon",
                           "pennsylvania","rhode island","south carolina",
                           "south dakota","tennessee","texas","utah",
                           "washington:main","washington:lopez island",
                           "washington:san juan island","washington:orcas island",
                           "washington:whidbey island","wisconsin","wyoming")] <- "gray50"
m$my.colors[m$names %in% c("arkansas","connecticut","district of columbia",
                           "georgia","idaho","indiana","kansas","maine",
                           "massachusetts:main","massachusetts:martha's vineyard",
                           "massachusetts:nantucket","mississippi","montana",
                           "nebraska","new hampshire","new mexico","vermont",
                           "virginia:main","virginia:chesapeake",
                           "virginia:chicoteague","virginia:san juan island",
                           "west virginia")] <- "gray80"

m.world <- map("world", c("USA","hawaii"), xlim=c(-180,-65), ylim=c(19,72),interior = FALSE)
title("NFP States")

map("state", boundary = TRUE, col=m$my.colors, add = TRUE, fill=TRUE )
map("world", c("hawaii"), boundary = TRUE, col='gray80', add = TRUE, fill=TRUE )
map("world", c("USA:Alaska"), boundary = TRUE, col='gray80', add = TRUE, fill=TRUE )
legend("topright", legend=c("NFP state", "Not an NFP state"), pch=15, 
       col=c("gray50","gray80"), ncol=1, cex=1.2)





##################################
## EXPLORATORY ANALYSIS

summary(immunizations)

# Matching: Income
results <- table(immunizations$income_recode, immunizations$treatment)
results <- results[-nrow(results),]
colnames(results) <- c("not NFP", "NFP")
rownames(results) <- c("$0-7.5k", "$7.5-20k", "20-30k", "$30-40k", "$40k+")
par(las=3, mar=c(2.2,3,2,1))
mosaicplot(results,
           color = c("gray60", "gray80"),
           main="Income Distributions",
           xlab="income category",
           ylab="NFP enrollment")

text(.07,.75,results[1,1],cex=.75)
text(.07,.29,results[1,2],cex=.75)
text(.25,.7,results[2,1],cex=.75)
text(.25,.25,results[2,2],cex=.75)
text(.435,.65,results[3,1],cex=.75)
text(.435,.2,results[3,2],cex=.75)
text(.54,.5,results[4,1],cex=.75)
text(.54,.06,results[4,2],cex=.75)
text(.8,.4,results[5,1],cex=.75)
text(.8,0,results[5,2],cex=.75)






# Matching: Mother's Education
results <- table(immunizations$HSgrad, immunizations$treatment)
rownames(results) <- c("~HS grad", "HS grad")
colnames(results) <- c("not NFP", "NFP")
par(las=3, mar=c(2.2,3,2,1))
mosaicplot(results,
           color = c("gray60", "gray80"),
           main="Matching: Mother's Education",
           xlab="whether mother finished high school",
           ylab="NFP enrollment")
text(.09,.65,"10947", cex=.75)
text(.09,.18,"9351", cex=.75)
text(.6,.5,"91560", cex=.75)
text(.6,.025,"11109",cex=.75)




names(immunizations)
# Mother Married
results <- table(immunizations$married, immunizations$treatment)
rownames(results) <- c("~married", "married")
colnames(results) <- c("not NFP", "NFP")
par(las=3, mar=c(2.2,3,2,1))
mosaicplot(results,
           color = c("gray60", "gray80"),
           main="Matching: Mother's Marriage Status",
           xlab="whether mother is currently married",
           ylab="NFP enrollment")
text(.2,.65,"10947", cex=.75)
text(.2,.18,"9351", cex=.75)
text(.6,.5,"91560", cex=.75)
text(.6,.025,"11109",cex=.75)


names(immunizations)

temp <- subset(immunizations, 
               subset=c(!is.na(immunizations$income_recode) & 
                          !is.na(immunizations$language) &
                          !is.na(immunizations$MAge) & 
                          !is.na(immunizations$RE) & 
                          !is.na(immunizations$male) & 
                          !is.na(immunizations$married) & 
                          !is.na(immunizations$HSgrad)))

reg <- glm(treatment ~ factor(income_recode) + factor(language) + 
             factor(MAge) + factor(RE) + male + married + HSgrad, 
           data=temp, family=binomial)

p <- reg$fitted
p.t <- p[temp$treatment==1& p>.05]
p.c <- p[temp$treatment==0& p>.05]

#SHOW WITH MATCHES
par(mfrow=c(2,1))
plot1 <- hist(p[temp$treatment==1],prob=TRUE,xlim=c(0,1), ylim=c(0,15),plot=F)
plot2 <- hist(p[temp$treatment==0],prob=TRUE,xlim=c(0,1), ylim=c(0,15),plot=F)

plot3 <- hist(p[temp$treatment==1 & p>.05],prob=TRUE,xlim=c(0,1), ylim=c(0,6),plot=F)
plot4 <- hist(p[temp$treatment==0 & p>.05],prob=TRUE, xlim=c(0,1), ylim=c(0,6),plot=F)


load("/mnt/data/NIS/modified_data/NISPUF.RData")
# Overall immunizations up to date
sort(names(NISPUF))

Immunizations_UptoDate_6 <- sum(NISPUF$PDAT==1 & NISPUF$DTaP6==1 & NISPUF$Polio6==1 & NISPUF$MMR6==1) / sum(NISPUF$PDAT==1)
Immunizations_UptoDate_12 <- sum(NISPUF$PDAT==1 & NISPUF$DTaP12==1 & NISPUF$Polio12==1 & NISPUF$MMR12==1) / sum(NISPUF$PDAT==1)
Immunizations_UptoDate_18 <- sum(NISPUF$PDAT==1 & NISPUF$DTaP18==1 & NISPUF$Polio18==1 & NISPUF$MMR18==1) / sum(NISPUF$PDAT==1)
Immunizations_UptoDate_24 <- sum(NISPUF$PDAT==1 & NISPUF$DTaP24==1 & NISPUF$Polio24==1 & NISPUF$MMR24==1) / sum(NISPUF$PDAT==1)

y.coord <- c(Immunizations_UptoDate_6,
             Immunizations_UptoDate_12,
             Immunizations_UptoDate_18,
             Immunizations_UptoDate_24)
plot(c(6,12,18,24), y.coord, pch=19, xlim=c(6,24), ylim=c(0,1), axes=F,
     main='Up-to-Date Vaccination Rates (MMR, DTaP, Polio)',
     xlab='months since birth', 
     ylab='proportion of children up to date')
axis(1,at=c(6,12,18,24))
axis(2)
box()

nfp.data <- read.csv("/mnt/data/csv_data/growth_immunization_outcomes.csv",
                     header=TRUE)
names(nfp.data)
y2.coord <- c(sum(nfp.data$final_immun_1=='Yes') / sum(nfp.data$final_immun_1=='Yes' | nfp.data$final_immun_1=='No'),
              sum(nfp.data$final_immun_2=='Yes') / sum(nfp.data$final_immun_2=='Yes' | nfp.data$final_immun_2=='No'),
              sum(nfp.data$final_immun_3=='Yes') / sum(nfp.data$final_immun_3=='Yes' | nfp.data$final_immun_3=='No'),
              sum(nfp.data$final_immun_4=='Yes') / sum(nfp.data$final_immun_4=='Yes' | nfp.data$final_immun_4=='No'))
points(c(6,12,18,24), y2.coord, pch=19, col='red')
legend('bottomright', lty=1, col=c("red","black"), legend=c("NFP","NIS"))



# Compare mother's education levels, etc.
#MOSAICPLOT

# Child variables: whether child is first born, age, WIC, 

# Household-reported vaccination rates
# NFP
# NIS

names(immunizations)
mean(immunizations$Immunizations_UptoDate_6,na.rm=T)

table(immunizations$Immunizations_UptoDate_6,immunizations$treatment)




# What proportion of those who gave permission had adequate provider records?
sum(NISPUF$D7==1 & NISPUF$PDAT==1, na.rm=TRUE) / sum(NISPUF$D7==1, na.rm=TRUE)


# How reliable are household-reported vaccination rates?  Compare HH reports to provider reports in NIS data.
sum(NISPUF$PDAT==1 & NISPUF$HH_DTP>0 & !is.na(NISPUF$DDTP1)) / sum(NISPUF$PDAT==1 & NISPUF$HH_DTP>0)
unique(NISPUF$AGEGRP)


# How reliable are household shot cards?






# How many shots of each vaccine are kids receiving?





# Examine results for 6-month vaccinations
mean(HepB6==1)
mean(DTaP6==1)
mean(Hib6==1)
mean(Polio6==1) 
mean(PCV6==1)
mean(MMR6==1)
mean(Varicella6==1)
mean(HepA6==1)
mean(Rotavirus6==1)


# Examine results for 6-month vaccinations
mean(HepB6==1)
mean(DTaP6==1)
mean(Hib6==1)
mean(Polio6==1) 
mean(PCV6==1)
mean(MMR6==1)
mean(Varicella6==1)
mean(HepA6==1)
mean(Rotavirus6==1)





##################################
## MATCHING

# Install and import packages.
install.packages("Matching", repo="http://cran.rstudio.com")
library(Matching)

setwd("/mnt/data/NIS")
load("immunizations_analysis.RData")

# Define D, X, Y, and Z.
# D is an indicator of whether the observation came from the NFP data set.
# X are controls for the independent variables in the regression of Y on D.
# Y is the outcome of interest.
# Z include all X and the other variables that may impact likelihood of treatment, but do not independently impact the outcome.

D <- immunizations$treatment
X <- subset(immunizations, select = c(income_recode, state, language, MAg, RE, male, married, HSgrad))
Y <- immunizations$Immunizations_UptoDate_6
Z <- subset(immunizations, select = c())

# Regress D on Z to create propensity scores (probit model)

probit <- glm(D ~ ., family = binomial(link = "probit"), data = Z)
summary(probit)

psm <- predict(probit, data = Z, type = "response")

# Create M, a vector of covariates on which to match, including (but not limited to) propensity score

M <- cbind(Z, ps)

# Complete matching!
k <- [insert desired number of matches for each observation]

match <- Match(Y = Y, Tr = D, X = M, M = k, caliper = ? (will we want one?))
summary(match) 
 
##Add "CommonSupport=TRUE" argument to limit to areas of common support , though R documentation recommends setting a caliper instead
## Consider using the GenMatch method - determines weights for each of M in matching with the goal of minimizing the maximum observed discrepancy between paired observations
## Use MatchBalance() to check balance before and after matching with Match (GenMatch automatically finds balance)
## Note that Matchby() function may be useful for stratified matching?

# Calculate weighted average across centers
