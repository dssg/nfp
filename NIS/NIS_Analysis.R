##################################
##    Data Preparation File     ##
## National Immunization Survey ##
##         Joe Walsh            ##
##         Emily Rowe           ##
##        Adam Fishman          ##
##################################


require(ggplot2)

setwd("/mnt/data/NIS/")

immunizations <- read.csv("/mnt/data/NIS/modified_data/immunizations_analysis.csv")





##########################################
## Plot states with NFP programs
library(maps)
m <- map("state", interior = FALSE, plot=FALSE)

m$my.colors <- 0
m$names
m$my.colors[m$names %in% c("alabama","arizona","california","colorado","delaware",
                           "florida","iowa","illinois","kansas","kentucky","louisiana",
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
                           "georgia","idaho","indiana","maine",
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
dim(immunizations)

# Lots of missing income_recode from the NFP data.  We can impute.
sum(is.na(immunizations$income_recode[immunizations$treatment==1]))
sum(!is.na(immunizations$income_recode[immunizations$treatment==1])) / sum(immunizations$treatment==1)




# Comparing NIS/NFP income
results <- table(immunizations$income_recode, immunizations$treatment)
results <- results[-nrow(results),]
colnames(results) <- c("~NFP", "NFP")
rownames(results) <- c("$0-7.5k", "$7.5-20k", "$20-30k", "$30-40k", "$40k+")
par(las=1, mar=c(2.2,3,2,1))
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






# Comparing NIS/NFP education
results <- table(immunizations$HSgrad, immunizations$treatment)
rownames(results) <- c("~HS grad", "HS grad")
colnames(results) <- c("~NFP", "NFP")
par(las=1,mar=c(2.2,3,2,1))
mosaicplot(results,
           color = c("gray60", "gray80"),
           main="Matching: Mother's Education",
           xlab="whether mother finished high school",
           ylab="NFP enrollment")
text(.13,.775,results[1,2], cex=.75)
text(.13,.3,results[2,2], cex=.75)
text(.635,.55,results[2,1], cex=.75)
text(.635,.075,results[2,2],cex=.75)







# Comparing NIS/NFP mother's age
# Estimate probability that mother is in the correct category?

results <- table(immunizations$MothersAge, immunizations$treatment)
colnames(results) <- c("~NFP", "NFP")
results[,1] / sum(results[,1])


# These numbers do not match the National Vital Statistics reports.
# In 2010, about 300,000 first-time births for mothers under 20 years old
# out of a total of 1.6 million first-time births, or about 19%.  This appears 
# to be because the NIS is recording the mother's age at the time
# of the interview, not at the time of birth.  If 19% of first-time mothers are
# under 20 at the time of birth, and if 66% are 18-19 and 94% are 16-19, then 
# it makes sense that only 2-3% would be 19 years old or younger when their
# children are 19-35 months old.  Furthermore, if 26% of mothers are at least 30
# at the time of birth and if 52% are at least 25 at the time of birth, then 
# it makes sense that 56% of mothers would be at least 30 19-35 months later.






# Comparing NIS/NFP married
results <- table(immunizations$married, immunizations$treatment)
rownames(results) <- c("~married","married")
colnames(results) <- c("~NFP", "NFP")

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






# Comparing NIS/NFP male child
results <- table(immunizations$male, immunizations$treatment)
colnames(results) <- c("~NFP", "NFP")




# Comparing NIS/NFP race/ethnicity
results <- table(immunizations$Race, immunizations$treatment)
rownames(results) <- c("Hispanic", "White", "Black", "Other")
colnames(results) <- c("~NFP", "NFP")




# Comparing NIS/NFP language
results <- table(immunizations$language, immunizations$treatment)
colnames(results) <- c("~NFP", "NFP")





# Comparing NIS/NFP 6-month immunization rate
results <- table(immunizations$Immunizations_UptoDate_6, immunizations$treatment)
rownames(results) <- c("~UTD at 6 mo", "UTD at 6 mo")
colnames(results) <- c("~NFP", "NFP")






###############################
## Unmatched NIS immunization rates

bootstrap_genpop_immunizations <- matrix(NA, 10000, 4)
for(i in 1:10000){
  temp <- NISPUF[sample(1:nrow(NISPUF), nrow(NISPUF), replace=TRUE),]
  
  
NIS_2008_6 <- sum(temp$PROVWT[temp$YEAR==2008 & temp$Immunizations_UptoDate431_6==1], na.rm=T) /
  sum(temp$PROVWT[temp$YEAR==2008], na.rm=T)
NIS_2009_6 <- sum(temp$PROVWT[temp$YEAR==2009 & temp$Immunizations_UptoDate431_6==1], na.rm=T) /
  sum(temp$PROVWT[temp$YEAR==2009], na.rm=T)
NIS_2010_6 <- sum(temp$PROVWT[temp$YEAR==2010 & temp$Immunizations_UptoDate431_6==1], na.rm=T) /
  sum(temp$PROVWT[temp$YEAR==2010], na.rm=T)
NIS_2011_6 <- sum(temp$PROVWT[temp$YEAR==2011 & temp$Immunizations_UptoDate431_6==1], na.rm=T) /
  sum(temp$PROVWT[temp$YEAR==2011], na.rm=T)
NIS_6 <- NIS_2008_6*mean(temp$YEAR==2008) + NIS_2009_6*mean(temp$YEAR==2009) + 
  NIS_2010_6*mean(temp$YEAR==2010) + NIS_2011_6*mean(temp$YEAR==2011) 

NIS_2008_12 <- sum(temp$PROVWT[temp$YEAR==2008 & temp$Immunizations_UptoDate431_12==1], na.rm=T) /
  sum(temp$PROVWT[temp$YEAR==2008], na.rm=T)
NIS_2009_12 <- sum(temp$PROVWT[temp$YEAR==2009 & temp$Immunizations_UptoDate431_12==1], na.rm=T) /
  sum(temp$PROVWT[temp$YEAR==2009], na.rm=T)
NIS_2010_12 <- sum(temp$PROVWT[temp$YEAR==2010 & temp$Immunizations_UptoDate431_12==1], na.rm=T) /
  sum(temp$PROVWT[temp$YEAR==2010], na.rm=T)
NIS_2011_12 <- sum(temp$PROVWT[temp$YEAR==2011 & temp$Immunizations_UptoDate431_12==1], na.rm=T) /
  sum(temp$PROVWT[temp$YEAR==2011], na.rm=T)
NIS_12 <- NIS_2008_12*mean(temp$YEAR==2008) + NIS_2009_12*mean(temp$YEAR==2009) + 
  NIS_2010_12*mean(temp$YEAR==2010) + NIS_2011_12*mean(temp$YEAR==2011) 

NIS_2008_18 <- sum(temp$PROVWT[temp$YEAR==2008 & temp$Immunizations_UptoDate431_18==1], na.rm=T) /
  sum(temp$PROVWT[temp$YEAR==2008], na.rm=T)
NIS_2009_18 <- sum(temp$PROVWT[temp$YEAR==2009 & temp$Immunizations_UptoDate431_18==1], na.rm=T) /
  sum(temp$PROVWT[temp$YEAR==2009], na.rm=T)
NIS_2010_18 <- sum(temp$PROVWT[temp$YEAR==2010 & temp$Immunizations_UptoDate431_18==1], na.rm=T) /
  sum(temp$PROVWT[temp$YEAR==2010], na.rm=T)
NIS_2011_18 <- sum(temp$PROVWT[temp$YEAR==2011 & temp$Immunizations_UptoDate431_18==1], na.rm=T) /
  sum(temp$PROVWT[temp$YEAR==2011], na.rm=T)
NIS_18 <- NIS_2008_18*mean(temp$YEAR==2008) + NIS_2009_18*mean(temp$YEAR==2009) + 
  NIS_2010_18*mean(temp$YEAR==2010) + NIS_2011_18*mean(temp$YEAR==2011) 

NIS_2008_24 <- sum(temp$PROVWT[temp$YEAR==2008 & temp$Immunizations_UptoDate431_24==1], na.rm=T) /
  sum(temp$PROVWT[temp$YEAR==2008], na.rm=T)
NIS_2009_24 <- sum(temp$PROVWT[temp$YEAR==2009 & temp$Immunizations_UptoDate431_24==1], na.rm=T) /
  sum(temp$PROVWT[temp$YEAR==2009], na.rm=T)
NIS_2010_24 <- sum(temp$PROVWT[temp$YEAR==2010 & temp$Immunizations_UptoDate431_24==1], na.rm=T) /
  sum(temp$PROVWT[temp$YEAR==2010], na.rm=T)
NIS_2011_24 <- sum(temp$PROVWT[temp$YEAR==2011 & temp$Immunizations_UptoDate431_24==1], na.rm=T) /
  sum(temp$PROVWT[temp$YEAR==2011], na.rm=T)
NIS_24 <- NIS_2008_24*mean(temp$YEAR==2008) + NIS_2009_24*mean(temp$YEAR==2009) + 
  NIS_2010_24*mean(temp$YEAR==2010) + NIS_2011_24*mean(temp$YEAR==2011) 

  bootstrap_genpop_immunizations[i,] <- c(NIS_6, NIS_12, NIS_18, NIS_24)
}

apply(bootstrap_genpop_immunizations,2,mean)
apply(bootstrap_genpop_immunizations,2,sd)










###############################
## Propensity score model
PSM_Matching <- immunizations[complete.cases(immunizations),]

summary(PSM_Matching)
# lots of the treatments dropped

# Complete provider data only
PSM_Matching <- subset(PSM_Matching, subset=c(PDAT6==1 & PDAT12==1 & PDAT18==1 & PDAT24==1))


# PSM
# Do I need to account for NIS weights?
reg <- glm(treatment ~ factor(income_recode) + factor(language) + 
             factor(Race) + married + HSgrad, 
           data=PSM_Matching, family=binomial(link='logit'))
summary(reg)
# match on poverty ratio instead of income buckets

# Separation plot
library(separationplot)
separationplot(predict.glm(reg, type='response'), PSM_Matching$treatment)



## Six-month rate
library(Matching)
rr6 <- Match(Y=PSM_Matching$Immunizations_UptoDate_6, Tr=PSM_Matching$treatment, X=reg$fitted.values)
MatchBalance(treatment ~ factor(income_recode) + factor(language) + 
               factor(Race) + married + HSgrad, data=PSM_Matching, match.out=rr6, 
             nboots=1000)
summary(rr6)




## Twelve-month rate
rr12 <- Match(Y=PSM_Matching$Immunizations_UptoDate_12, Tr=PSM_Matching$treatment, X=reg$fitted.values)
MatchBalance(treatment ~ factor(income_recode) + factor(language) + 
               factor(Race) + married + HSgrad, data=PSM_Matching, match.out=rr12, 
             nboots=1000)
summary(rr12)





## Eighteen-month rate
rr18 <- Match(Y=PSM_Matching$Immunizations_UptoDate_18, Tr=PSM_Matching$treatment, X=reg$fitted.values)
MatchBalance(treatment ~ factor(income_recode) + factor(language) + 
               factor(Race) + married + HSgrad, data=PSM_Matching, match.out=rr18, 
             nboots=1000)
summary(rr18)




## Twenty-four-month rate
rr24 <- Match(Y=PSM_Matching$Immunizations_UptoDate_24, Tr=PSM_Matching$treatment, X=reg$fitted.values)
MatchBalance(treatment ~ factor(income_recode) + factor(language) + 
               factor(Race) + married + HSgrad, data=PSM_Matching, match.out=rr24, 
             nboots=1000)
summary(rr24)







############################
# Plot immunization rates

setwd("/mnt/data/NIS/")
png("Meetup_two_immunizations.png", width=13.3, height=7.5, units="in", res=100)
y.coord <- c(mean(PSM_Matching$Immunizations_UptoDate_6[PSM_Matching$treatment==1 & PSM_Matching$PDAT6==1],na.rm=T),
             mean(PSM_Matching$Immunizations_UptoDate_12[PSM_Matching$treatment==1 & PSM_Matching$PDAT12==1],na.rm=T),
             mean(PSM_Matching$Immunizations_UptoDate_18[PSM_Matching$treatment==1 & PSM_Matching$PDAT18==1],na.rm=T),
             mean(PSM_Matching$Immunizations_UptoDate_24[PSM_Matching$treatment==1 & PSM_Matching$PDAT24==1],na.rm=T))
par(mar=c(4.5,5.5,4,1.5), cex.main=2, cex.axis=1.5, cex.lab=2, las=1)
plot(c(6,12,18,24), 100*c(), pch=19, 
     xlim=c(6,24), ylim=c(0,100), 
     axes=F, col='blue',
     type='l', lwd=4,
     main='Up-to-Date Vaccination Rates',
     xlab='months since birth', 
     ylab='% of children UTD    ')
axis(1,at=c(6,12,18,24))
axis(2,at=c(0,25,50,75,100))
box()
points(c(6,12,18,24), 100*(y.coord-c()), 
       pch=19, col='red', type='l', lwd=4)
#points(c(6,12,18,24), 100*c(), 
#       pch=19, col='blue', type='l', lwd=4)

legend('bottomright', lty=1, lwd=4, col=c("blue","red"),#,"blue"), 
       legend=c("General Population","Matched Group"),cex=1.5)#,"General Population"),cex=1.5)
dev.off()







##############################
## Motivation
## Motivation could be a confounder.  If motivation increases the probability 
## that a woman enrolls and that a child receives immunizations / goes to the
## doctor / etc, then it is a confounder and its effect needs to be accounted 
## for.  
##
## One piece of evidence that suggests motivation is not a big issue is the
## stability of the NFP immunization rates across 6, 12, 18, and 24 months.
## NFP has a high attrition rate -- they lose over half their clients before 
## the children turn two -- so the women who remain in the program are 
## probably the most motivated.  Yet the immunization rate for kids (as 
## verified with records) remains flat over time.  It should increase if
## motivation is a cause.
##
## Perhaps I'm wrong to assume that the women still in the program when their 
## child turns two are more motivated than the women in the program when
## their child turns two.  It could be that women either drop quickly, perhaps
## before the kid is even born, or not at all.  Then the women enrolled at 6 
## months and 24 months would be the same.  We can check this when we get dates
## for add/drop dates for each client from Bill.
##
## We can do another test to help reduce the bias that motivation introduces:
## stratify by drop-out date.  We can look at the six-month immunization
## rate for children who drop out a month or two later, which biases the test
## against NFP in two ways: it reduces the sample size, thereby reducing the 
## power of the test, and it drops the clients who are most likely to be immunized.






##############################
##  How accurate are self-reported immunization rates?
##
## First, who has shot cards?
names()


# What proportion of those who gave permission had adequate provider records?
sum(NISPUF$D7==1 & NISPUF$PDAT==1, na.rm=TRUE) / sum(NISPUF$D7==1, na.rm=TRUE)


# How reliable are household-reported vaccination rates?  Compare HH reports to provider reports in NIS data.
sum(NISPUF$PDAT==1 & NISPUF$HH_DTP>0 & !is.na(NISPUF$DDTP1)) / sum(NISPUF$PDAT==1 & NISPUF$HH_DTP>0)
unique(NISPUF$AGEGRP)


# How reliable are household shot cards?






# Do the analysis with complete data and with probability distributions for the missing data













#############################
## Breastfeeding rates
summary(NISPUF08$CBF_01)

NISPUF08$CBF_01[NISPUF08$CBF_01==99] <- NA
NISPUF08$CBF_01[NISPUF08$CBF_01==77] <- NA
NISPUF08$CBF_01[NISPUF08$CBF_01==2] <- 0

mean(NISPUF08$CBF_01,na.rm=TRUE)
mean(NISPUF08$CBF_01[NISPUF08$INCPORAR<=2],na.rm=TRUE)

length(NISPUF08$MARITAL[NISPUF08$MARITAL==3 & NISPUF08$INCPORAR<=2]) / length(NISPUF08$MARITAL[NISPUF08$INCPORAR<=2])
