##################################
##    Data Preparation File     ##
## National Immunization Survey ##
##         Joe Walsh            ##
##         Emily Rowe           ##
##        Adam Fishman          ##
##         Nick Mader           ##
##################################

# This script basically proceeds in the following way:
#
#     NIS
#     - Load NIS data for 2009, 2010, and 2011
#     - Replicate NIS estimates to ensure data quality
#     - Merge the NIS datasets
#     - Generate immunization variables we need for analysis
#     - Clean NIS data
#
#     NFP 
#     - Load NFP data
#     - Make variables across NIS and NFP compatible
#
#     MERGE NIS and NFP data



# Load libraries
library(survey)   #TO USE svydesign(), svymean(), and svyby()
library(Hmisc)    #TO USE prn()
library(sas7bdat)


setwd("/mnt/data/NIS/modified_data/")




#####################################
#####################################
#                                   #
#          Load NIS Data            #
#     Replicate NIS estimates       #
#        Rename variables           #
#    Drop unncessary variables      #
#   Merge 2009, 2010, 2011 data     #
#                                   #
#####################################
#####################################



## NOTE

#  NIS provides R scripts to prepare the data for analysis.  Run each and make a few modifications.
#  I'm commenting out the source lines that call NIS-provided code because 
#  1) once they're run they don't need to run again and 2) they take too long to run.
#
#  The NIS provides code with each year's dataset to replicate some of their immunization estimates.  
#  I included that code and my own, which uses a bootstrap, to ensure data quality.  Because the 
#  bootstrap can take a long time, I commented it out.






#####################################
## 2009 NIS data
#####################################
#source("/mnt/data/NIS/original_data/nispuf09.r")

load("NISPUF09.RData")


####################
# Check validity of the data by replicating estimates in the NIS 2009 documentation

# Start with a few empirical univariate distributions
table(NISPUF09$EDUC1); sum(is.na(NISPUF09$EDUC1))         # Education matches
table(NISPUF09$SC_431); sum(is.na(NISPUF09$SC_431))       # Shot card 4:3:1 matches
table(NISPUF09$M_AGEGRP); sum(is.na(NISPUF09$M_AGEGRP))   # Mother's age matches


#-- HERE'S THE NIS CODE -- #
R_FILE <- subset(NISPUF09, select=c(SEQNUMHH, SEQNUMC, P_UTD431, ESTIAP09, PROVWT))
  names(R_FILE) <- c("SEQNUMHH", "SEQNUMC", "P_UTD431", "ESTIAP", "WT")
  R_FILE <- na.omit(R_FILE)

# Specify survey design
svydsg <- svydesign(id=~SEQNUMHH, strata=~ESTIAP, weights=~WT, data=R_FILE)  

# NIS estimates and standard errors
r_nation <- svymean(~P_UTD431, svydsg)
PERCENT_UTD <- round(r_nation*100,2) #CONVERT INTO PERCENT ESTIMATES(MEAN)
SE_UTD <- round(SE(r_nation)*100,2) #CONVERT INTO PERCENT ESTIMATES(SE)
cbind(PERCENT_UTD, SE_UTD)


#-- HERE ARE OUR ESTIMATES --#
#estimates <- rep(NA,1000)
#for(i in 1:1000){
#  rows <- sample(1:dim(NISPUF09)[1], dim(NISPUF09)[1], replace=TRUE)
#  temp <- NISPUF09[rows,]
#  estimates[i] <- sum(temp$PROVWT[temp$P_UTD431==1], na.rm=T) / sum(temp$PROVWT, na.rm=T)
#}
#cbind(100*sum(NISPUF09$PROVWT[NISPUF09$P_UTD431==1], na.rm=T) / sum(NISPUF09$PROVWT, na.rm=T), 
#      100*sd(estimates))



####################
# Modify the dataset

# Drop variables not available in every year
NISPUF09 <- NISPUF09[,!(names(NISPUF09) %in% c("HH_FLU","P_UTDHEP","P_UTDHIB_ROUT_S","P_UTDHIB_SHORT_S","P_UTDPCV",
                                               "P_UTDPCVB13","P_UTDROT_S"))]

# Only keep potentially useful columns
NISPUF09 <- subset(NISPUF09, 
                   select=(c(sort(names(NISPUF09)[grep("SEQNUM", names(NISPUF09))]),	# NIS respondent identifiers
                             "PDAT",               # whether there is adequate provider data			
                             "PROVWT",             # weight for children with adequate provider data
                             "YEAR",								# year of interview
                             "STATE",							# state of residence
                             #"ESTIAP09",	inconsistently coded from year to year		# state or metropolitan statistical area of residence
                             "C5R", 								# relationship of respondent to child (match on mother?)
                             "LANGUAGE",							# language interview was conducted in
                             "D7",								# permission to contact providers
                             "EDUC1",							# mother's education level
                             "M_AGEGRP",							# mother's age group
                             "MARITAL2",							# mother's marital status
                             "INCQ298A",							# family income category
                             "INCPORAR",							# income to poverty ratio (eligibility criterion)
                             "FRSTBRN",							# whether child is first born
                             "AGEGRP",							# child's age group
                             "RACEETHK",		            # child's race
                             "SEX",								# child's sex
                             sort(names(NISPUF09)[grep("CWIC_", names(NISPUF09))]),		# WIC variables	
                             sort(names(NISPUF09)[grep("INS_", names(NISPUF09))]),		# insurance variables
                             sort(names(NISPUF09)[grep("BF_", names(NISPUF09))]),		# breastfeeding variables
                             sort(names(NISPUF09)[grep("SC_", names(NISPUF09))]),		# household shot card variables
                             sort(names(NISPUF09)[grep("HH_", names(NISPUF09))]),		# household-reported variables (not using shot card)
                             "SHOTCARD", 							# household uses shot card
                             sort(names(NISPUF09)[grep("DDTP", names(NISPUF09))]),		# provider-reported DT-containing shots
                             sort(names(NISPUF09)[grep("DHEP", names(NISPUF09))]),		# provider-reported HepA- and HepB-containing shots
                             sort(names(NISPUF09)[grep("DHIB_", names(NISPUF09))]),		# provider-reported Hib-containing shots
                             sort(names(NISPUF09)[grep("DMMR", names(NISPUF09))]),		# provider-reported measles-containing shots
                             sort(names(NISPUF09)[grep("DPCV", names(NISPUF09))]),		# provider-reported pneumococcal-containing shots
                             sort(names(NISPUF09)[grep("DPOLIO", names(NISPUF09))]),		# provider-reported polio-containing shots
                             sort(names(NISPUF09)[grep("DROT", names(NISPUF09))]),		# provider-reported rotavirus-containing shots
                             sort(names(NISPUF09)[grep("DVRC", names(NISPUF09))]),		# provider-reported Varicella-containing shots
                             "P_UTD431"                                              # provider-report up-to-date DTAP, polio, measles vaccinations
                            )
                   )
)





#####################################
## 2010 NIS data
#####################################
#source("/mnt/data/NIS/original_data/nispuf10.r")

load("NISPUF10.RData")



####################
# Check validity of the data by replicating estimates in the NIS 2010 documentation

# Start with a few empirical univariate distributions
table(NISPUF10$EDUC1); sum(is.na(NISPUF10$EDUC1))         # Education matches
table(NISPUF10$SC_431); sum(is.na(NISPUF10$SC_431))       # Shot card 4:3:1 matches
table(NISPUF10$M_AGEGRP); sum(is.na(NISPUF10$M_AGEGRP))   # Mother's age matches


#-- HERE'S THE NIS CODE -- #
R_FILE <- subset(NISPUF10, select=c(SEQNUMHH, SEQNUMC, PUTD4313, ESTIAP10, PROVWT))
  names(R_FILE) <- c("SEQNUMHH", "SEQNUMC", "PUTD4313", "ESTIAP", "WT")
  R_FILE <- na.omit(R_FILE)

# Specify survey design
svydsg <- svydesign(id=~SEQNUMHH, strata=~ESTIAP, weights=~WT, data=R_FILE)

# NIS estimates and standard errors
r_nation <- svymean(~PUTD4313, svydsg)
PERCENT_UTD <- round(r_nation*100,2) #CONVERT INTO PERCENT ESTIMATES(MEAN)
SE_UTD <- round(SE(r_nation)*100,2) #CONVERT INTO PERCENT ESTIMATES(SE)
cbind(PERCENT_UTD, SE_UTD)


#-- HERE ARE OUR ESTIMATES --#
#estimates <- rep(NA,1000)
#for(i in 1:1000){
#  rows <- sample(1:dim(NISPUF10)[1], dim(NISPUF10)[1], replace=TRUE)
#  temp <- NISPUF10[rows,]
#  estimates[i] <- sum(temp$PROVWT[temp$PUTD4313==1], na.rm=T) / sum(temp$PROVWT, na.rm=T)
#}
#cbind(100*sum(NISPUF10$PROVWT[NISPUF10$PUTD4313==1], na.rm=T) / sum(NISPUF10$PROVWT, na.rm=T), 
#      100*sd(estimates))



####################
# Modify the dataset

# Drop variables not available in every year
NISPUF10 <- NISPUF10[,!(names(NISPUF10) %in% c("HH_FLU","HH_H1N","P_UTDHEPA2","P_UTDHEP","P_UTDHIB_ROUT_S","P_UTDHIB_SHORT_S",
                                               "P_UTDPCV","P_UTDPCVB13","P_UTDROT_S"))]


# Only keep potentially useful columns
NISPUF10 <- subset(NISPUF10, 
                   select=(c(sort(names(NISPUF10)[grep("SEQNUM", names(NISPUF10))]),	# NIS respondent identifiers
                             "PDAT",               # whether there is adequate provider data
                             "PROVWT",             # weight for children with adequate provider data
                             "YEAR",								# year of interview
                             "STATE",							# state of residence
                             #"ESTIAP10",	inconsistently coded from year to year		# state or metropolitan statistical area of residence
                             "C5R", 								# relationship of respondent to child (match on mother?)
                             "LANGUAGE",							# language interview was conducted in
                             "D7",								# permission to contact providers
                             "EDUC1",							# mother's education level
                             "M_AGEGRP",							# mother's age group
                             "MARITAL2",							# mother's marital status
                             "INCQ298A",							# family income category
                             "INCPORAR",							# income to poverty ratio (eligibility criterion)
                             "FRSTBRN",							# whether child is first born
                             "AGEGRP",							# child's age group
                             "RACEETHK",		            # child's race
                             "SEX",								# child's sex
                             sort(names(NISPUF10)[grep("CWIC_", names(NISPUF10))]),		# WIC variables	
                             sort(names(NISPUF10)[grep("INS_", names(NISPUF10))]),		# insurance variables
                             sort(names(NISPUF10)[grep("BF_", names(NISPUF10))]),		# breastfeeding variables
                             sort(names(NISPUF10)[grep("SC_", names(NISPUF10))]),		# household shot card variables
                             sort(names(NISPUF10)[grep("HH_", names(NISPUF10))]),		# household-reported variables (not using shot card)
                             "SHOTCARD", 							# household uses shot card
                             sort(names(NISPUF10)[grep("DDTP", names(NISPUF10))]),		# provider-reported DT-containing shots
                             sort(names(NISPUF10)[grep("DHEP", names(NISPUF10))]),		# provider-reported HepA- and HepB-containing shots
                             sort(names(NISPUF10)[grep("DHIB_", names(NISPUF10))]),		# provider-reported Hib-containing shots
                             sort(names(NISPUF10)[grep("DMMR", names(NISPUF10))]),		# provider-reported measles-containing shots
                             sort(names(NISPUF10)[grep("DPCV", names(NISPUF10))]),		# provider-reported pneumococcal-containing shots
                             sort(names(NISPUF10)[grep("DPOLIO", names(NISPUF10))]),		# provider-reported polio-containing shots
                             sort(names(NISPUF10)[grep("DROT", names(NISPUF10))]),		# provider-reported rotavirus-containing shots
                             sort(names(NISPUF10)[grep("DVRC", names(NISPUF10))]),		# provider-reported Varicella-containing shots
                             "P_UTD431"                                              # provider-report up-to-date DTAP, polio, measles vaccinations
                            )
                   )
)






#####################################
## 2011 NIS data
#####################################
#source("/mnt/data/NIS/original_data/nispuf11.r")


####################
# Check validity of the data by replicating estimates in the NIS 2011 documentation

load("NISPUF11.RData")


# Start with a few empirical univariate distributions
table(NISPUF11$EDUC1); sum(is.na(NISPUF11$EDUC1))         # Education matches
table(NISPUF11$SC_431); sum(is.na(NISPUF11$SC_431))       # Shot card 4:3:1 matches
table(NISPUF11$M_AGEGRP); sum(is.na(NISPUF11$M_AGEGRP))   # Mother's age matches


#-- HERE'S THE NIS CODE -- #
R_FILE <- subset(NISPUF11, select=c(SEQNUMHH, SEQNUMC, PUTD4313, ESTIAP11, PROVWT_D))
  names(R_FILE) <- c("SEQNUMHH", "SEQNUMC", "PUTD4313", "ESTIAP", "WT")
  R_FILE <- na.omit(R_FILE)

# Specify survey design
svydsg <- svydesign(id=~SEQNUMHH, strata=~ESTIAP, weights=~WT, data=R_FILE)

# NIS estimates and standard errors
r_nation <- svymean(~PUTD4313, svydsg)
PERCENT_UTD <- round(r_nation*100,2) #CONVERT INTO PERCENT ESTIMATES(MEAN)
SE_UTD <- round(SE(r_nation)*100,2) #CONVERT INTO PERCENT ESTIMATES(SE)
cbind(PERCENT_UTD, SE_UTD)


#-- HERE ARE OUR ESTIMATES --#
#estimates <- rep(NA,1000)
#for(i in 1:1000){
#  rows <- sample(1:dim(NISPUF11)[1], dim(NISPUF11)[1], replace=TRUE)
#  temp <- NISPUF11[rows,]
#  estimates[i] <- sum(temp$PROVWT_D[temp$PUTD4313==1], na.rm=T) / sum(temp$PROVWT_D, na.rm=T)
#}
#cbind(100*sum(NISPUF11$PROVWT_D[NISPUF11$PUTD4313==1], na.rm=T) / sum(NISPUF11$PROVWT_D, na.rm=T), 
#      100*sd(estimates))



####################
# Modify the dataset

# Drop variables not available in every year
NISPUF11 <- NISPUF11[,!(names(NISPUF11) %in% c("HH_FLU","HH_H1N","P_UTDHEPA2","P_UTDHEP","P_UTDHIB_ROUT_S","P_UTDHIB_SHORT_S",
                                               "P_UTDPCV","P_UTDPCVB13","P_UTDROT_S","P_UTDHEPA1"))]

# Rename provider-weight variable
names(NISPUF11)[names(NISPUF11)=='PROVWT_D'] <- 'PROVWT'

# Only keep potentially useful columns
NISPUF11 <- subset(NISPUF11, 
                   select=(c(sort(names(NISPUF11)[grep("SEQNUM", names(NISPUF11))]),	# NIS respondent identifiers
                             "PDAT",               # whether there is adequate provider data
                             "PROVWT",             # weight for children with adequate provider data
                             "YEAR",								# year of interview
                             "STATE",							# state of residence
                             #"ESTIAP11",	inconsistently coded from year to year		# state or metropolitan statistical area of residence
                             "C5R", 								# relationship of respondent to child (match on mother?)
                             "LANGUAGE",							# language interview was conducted in
                             "D7",								# permission to contact providers
                             "EDUC1",							# mother's education level
                             "M_AGEGRP",							# mother's age group
                             "MARITAL2",							# mother's marital status
                             "INCQ298A",							# family income category
                             "INCPORAR",							# income to poverty ratio (eligibility criterion)
                             "FRSTBRN",							# whether child is first born
                             "AGEGRP",							# child's age group
                             "RACEETHK",		            # child's race
                             "SEX",								# child's sex
                             sort(names(NISPUF11)[grep("CWIC_", names(NISPUF11))]),		# WIC variables	
                             sort(names(NISPUF11)[grep("INS_", names(NISPUF11))]),		# insurance variables
                             sort(names(NISPUF11)[grep("BF_", names(NISPUF11))]),		# breastfeeding variables
                             sort(names(NISPUF11)[grep("SC_", names(NISPUF11))]),		# household shot card variables
                             sort(names(NISPUF11)[grep("HH_", names(NISPUF11))]),		# household-reported variables (not using shot card)
                             "SHOTCARD", 							# household uses shot card
                             sort(names(NISPUF11)[grep("DDTP", names(NISPUF11))]),		# provider-reported DT-containing shots
                             sort(names(NISPUF11)[grep("DHEP", names(NISPUF11))]),		# provider-reported HepA- and HepB-containing shots
                             sort(names(NISPUF11)[grep("DHIB_", names(NISPUF11))]),		# provider-reported Hib-containing shots
                             sort(names(NISPUF11)[grep("DMMR", names(NISPUF11))]),		# provider-reported measles-containing shots
                             sort(names(NISPUF11)[grep("DPCV", names(NISPUF11))]),		# provider-reported pneumococcal-containing shots
                             sort(names(NISPUF11)[grep("DPOLIO", names(NISPUF11))]),		# provider-reported polio-containing shots
                             sort(names(NISPUF11)[grep("DROT", names(NISPUF11))]),		# provider-reported rotavirus-containing shots
                             sort(names(NISPUF11)[grep("DVRC", names(NISPUF11))]),		# provider-reported Varicella-containing shots
                             "P_UTD431"                                              # provider-report up-to-date DTAP, polio, measles vaccinations
                            )
                   )
)





#####################################
## Combine NIS data 
#####################################

NISPUF <- rbind(NISPUF09, NISPUF10, NISPUF11)







#####################################
## Recode, drop unwanted observations, etc.
#####################################

# Drop old NISPUF datasets from memory
rm(NISPUF09,NISPUF10,NISPUF11)


# Only keep NIS data on first-born children
NISPUF <- subset(NISPUF, subset=(FRSTBRN==2))


# Only keep NIS with incomes at or below 300% of the poverty level
#NISPUF <- subset(NISPUF, subset=(INCPORAR<2.5))


# Only keep NIS data where the mother was the respondent
#NISPUF <- subset(NISPUF, subset=(C5R==1))


# Recode PDAT (adequate provider data) to 0/1 
NISPUF$PDAT[NISPUF$PDAT==2] <- 0


# Recode provider weights.  Because the provider weights tell us how many people
# an observation represents in that year and because we are sampling from roughly
# the same population across three years, each observation in NISPUF represents
# only about a third as many people (NIS Data Use Guide, 2011, p. 78).
NISPUF$PROVWT <- NISPUF$PROVWT/3


# Rename NISPUF ID variable 
names(NISPUF)[names(NISPUF)=="SEQNUMC"] <- "ID"




######################################
## State data

## Drop Virgin Islands observations
NISPUF <- subset(NISPUF, subset=(STATE!=78))

## Recode NISPUF$STATE to meaningful values
NISPUF$STATE[NISPUF$STATE==1] <- "AL"
NISPUF$STATE[NISPUF$STATE==2] <- "AK"
NISPUF$STATE[NISPUF$STATE==4] <- "AZ"
NISPUF$STATE[NISPUF$STATE==5] <- "AR"
NISPUF$STATE[NISPUF$STATE==6] <- "CA"
NISPUF$STATE[NISPUF$STATE==8] <- "CO"
NISPUF$STATE[NISPUF$STATE==9] <- "CT"
NISPUF$STATE[NISPUF$STATE==10] <- "DE"
NISPUF$STATE[NISPUF$STATE==11] <- "DC"
NISPUF$STATE[NISPUF$STATE==12] <- "FL"
NISPUF$STATE[NISPUF$STATE==13] <- "GA"
NISPUF$STATE[NISPUF$STATE==15] <- "HI"
NISPUF$STATE[NISPUF$STATE==16] <- "ID"
NISPUF$STATE[NISPUF$STATE==17] <- "IL"
NISPUF$STATE[NISPUF$STATE==18] <- "IN"
NISPUF$STATE[NISPUF$STATE==19] <- "IA"
NISPUF$STATE[NISPUF$STATE==20] <- "KS"
NISPUF$STATE[NISPUF$STATE==21] <- "KY"
NISPUF$STATE[NISPUF$STATE==22] <- "LA"
NISPUF$STATE[NISPUF$STATE==23] <- "ME"
NISPUF$STATE[NISPUF$STATE==24] <- "MD"
NISPUF$STATE[NISPUF$STATE==25] <- "MA"
NISPUF$STATE[NISPUF$STATE==26] <- "MI"
NISPUF$STATE[NISPUF$STATE==27] <- "MN"
NISPUF$STATE[NISPUF$STATE==28] <- "MS"
NISPUF$STATE[NISPUF$STATE==29] <- "MO"
NISPUF$STATE[NISPUF$STATE==30] <- "MT"
NISPUF$STATE[NISPUF$STATE==31] <- "NE"
NISPUF$STATE[NISPUF$STATE==32] <- "NV"
NISPUF$STATE[NISPUF$STATE==33] <- "NH"
NISPUF$STATE[NISPUF$STATE==34] <- "NJ"
NISPUF$STATE[NISPUF$STATE==35] <- "NM"
NISPUF$STATE[NISPUF$STATE==36] <- "NY"
NISPUF$STATE[NISPUF$STATE==37] <- "NC"
NISPUF$STATE[NISPUF$STATE==38] <- "ND"
NISPUF$STATE[NISPUF$STATE==39] <- "OH"
NISPUF$STATE[NISPUF$STATE==40] <- "OK"
NISPUF$STATE[NISPUF$STATE==41] <- "OR"
NISPUF$STATE[NISPUF$STATE==42] <- "PA"
NISPUF$STATE[NISPUF$STATE==44] <- "RI"
NISPUF$STATE[NISPUF$STATE==45] <- "SC"
NISPUF$STATE[NISPUF$STATE==46] <- "SD"
NISPUF$STATE[NISPUF$STATE==47] <- "TN"
NISPUF$STATE[NISPUF$STATE==48] <- "TX"
NISPUF$STATE[NISPUF$STATE==49] <- "UT"
NISPUF$STATE[NISPUF$STATE==50] <- "VT"
NISPUF$STATE[NISPUF$STATE==51] <- "VA"
NISPUF$STATE[NISPUF$STATE==53] <- "WA"
NISPUF$STATE[NISPUF$STATE==54] <- "WV"
NISPUF$STATE[NISPUF$STATE==55] <- "WI"
NISPUF$STATE[NISPUF$STATE==56] <- "WY"


# Only keep NIS data for states that NFP had a presence between 2008 and 2010
NISPUF <- subset(NISPUF, subset=(STATE=="PA" |
                                 STATE=="DE" |
                                 STATE=="TX" |
                                 STATE=="RI" |
                                 STATE=="NY" |
                                 STATE=="CA" |
                                 STATE=="MO" |
                                 STATE=="AZ" |
                                 STATE=="OH" |
                                 STATE=="NJ" |
                                 STATE=="CO" |
                                 STATE=="ND" |
                                 STATE=="NC" |
                                 STATE=="MI" |
                                 STATE=="WA" |
                                 STATE=="OR" |
                                 STATE=="MN" |
                                 STATE=="LA" |
                                 STATE=="SC" |
                                 STATE=="SD" |
                                 STATE=="IL" |
                                 STATE=="KY" |
                                 STATE=="IA" |
                                 STATE=="NV" |
                                 STATE=="TN" |
                                 STATE=="WI" |
                                 STATE=="UT" |
                                 STATE=="OK" |
                                 STATE=="WY" |
                                 STATE=="MD" |
                                 STATE=="AL" |
                                 STATE=="FL"))   
  






#####################################
#####################################
#                                   #
#   Determine Whether Child Is      #
#   Up to Date on Vaccinations      #
#     as Reported by Provider       #
#                                   #
#####################################
#####################################

# The formula I use was developed with the help of Carla Black, CDC,
# through email on July 17th.

# HepB immunizations up to date
NISPUF$HepB6 <- 0		# adequate immunizations at 6 months
  NISPUF$HepB6[NISPUF$DHEPB2<366/2+30] <- 1
NISPUF$HepB12 <- 0	# adequate immunizations at 12 months
  NISPUF$HepB12[NISPUF$DHEPB2<366+30] <- 1
NISPUF$HepB18 <- 0	# adequate immunizations at 18 months
  NISPUF$HepB18[NISPUF$DHEPB3<3/2*366+30] <- 1
NISPUF$HepB24 <- 0	# adequate immunizations at 24 months
  NISPUF$HepB24[NISPUF$DHEPB3<2*366+30] <- 1

# DTaP immunizations up to date
NISPUF$DTaP6 <- 0
  NISPUF$DTaP6[NISPUF$DDTP3<366/2+30] <- 1
NISPUF$DTaP12 <- 0
  NISPUF$DTaP12[NISPUF$DDTP3<366+30] <- 1
NISPUF$DTaP18 <- 0
  NISPUF$DTaP18[NISPUF$DDTP4<3/2*366+30] <- 1
NISPUF$DTaP24 <- 0
  NISPUF$DTaP24[NISPUF$DDTP4<2*366+30] <- 1

# Hib immunizations up to date
NISPUF$Hib6 <- 0
  NISPUF$Hib6[NISPUF$DHIB3<366/2+30] <- 1
NISPUF$Hib12 <- 0
  NISPUF$Hib12[NISPUF$DHIB3<366+30] <- 1
NISPUF$Hib18 <- 0
  NISPUF$Hib18[NISPUF$DHIB4<3/2*366+30] <- 1
NISPUF$Hib24 <- 0
  NISPUF$Hib24[NISPUF$DHIB4<2*366+30] <- 1

# Polio immunizations up to date
NISPUF$Polio6 <- 0
  NISPUF$Polio6[NISPUF$DPOLIO2<366/2+30] <- 1
NISPUF$Polio12 <- 0
  NISPUF$Polio12[NISPUF$DPOLIO2<366+30] <- 1
NISPUF$Polio18 <- 0
  NISPUF$Polio18[NISPUF$DPOLIO3<3/2*366+30] <- 1
NISPUF$Polio24 <- 0
  NISPUF$Polio24[NISPUF$DPOLIO3<2*366+30] <- 1

# PCV immunizations up to date
NISPUF$PCV6 <- 0
  NISPUF$PCV6[NISPUF$DPCV3<366/2+30] <- 1
NISPUF$PCV12 <- 0
  NISPUF$PCV12[NISPUF$DPCV3<366+30] <- 1
NISPUF$PCV18 <- 0
  NISPUF$PCV18[NISPUF$DPCV4<3/2*366+30] <- 1
NISPUF$PCV24 <- 0
  NISPUF$PCV24[NISPUF$DPCV4<2*366+30] <- 1

# MMR immunization up to date
NISPUF$MMR6 <- 1
NISPUF$MMR12 <- 1
NISPUF$MMR18 <- 0
  NISPUF$MMR18[NISPUF$DMMR1<3/2*366+30] <- 1
NISPUF$MMR24 <- 0
  NISPUF$MMR24[NISPUF$DMMR1<2*366+30] <- 1

# Varicella immunization up to date
NISPUF$Varicella6 <- 1
NISPUF$Varicella12 <- 1
NISPUF$Varicella18 <- 0
  NISPUF$Varicella18[NISPUF$DVRC1<3/2*366+30] <- 1
NISPUF$Varicella24 <- 0
  NISPUF$Varicella24[NISPUF$DVRC1<2*366+30] <- 1

# HepA immunization up to date
NISPUF$HepA6 <- 1
NISPUF$HepA12 <- 1
NISPUF$HepA18 <- 0
  NISPUF$HepA18[NISPUF$DHEPA1<3/2*366+30] <- 1
NISPUF$HepA24 <- 0
  NISPUF$HepA24[NISPUF$DHEPA1<2*366+30] <- 1

# Rotavirus immunization up to date
NISPUF$Rotavirus6 <- 0
  NISPUF$Rotavirus6[NISPUF$DROT3<366/2+30] <- 1
NISPUF$Rotavirus12 <- 0
  NISPUF$Rotavirus12[NISPUF$DROT3<366+30] <- 1
NISPUF$Rotavirus18 <- 0
  NISPUF$Rotavirus18[NISPUF$DROT3<3/2*366+30] <- 1
NISPUF$Rotavirus24 <- 0
  NISPUF$Rotavirus24[NISPUF$DROT3<2*366+30] <- 1


# 4 DTaP, 3 polio, 1 measles immunizations up to date
NISPUF$Immunizations_UptoDate431_6 <- 0
  NISPUF$Immunizations_UptoDate431_6[NISPUF$DTaP6==1 & NISPUF$Polio6==1 & NISPUF$MMR6==1] <- 1
NISPUF$Immunizations_UptoDate431_12 <- 0
  NISPUF$Immunizations_UptoDate431_12[NISPUF$DTaP12==1 & NISPUF$Polio12==1 & NISPUF$MMR12==1] <- 1
NISPUF$Immunizations_UptoDate431_18 <- 0
  NISPUF$Immunizations_UptoDate431_18[NISPUF$DTaP18==1 & NISPUF$Polio18==1 & NISPUF$MMR18==1] <- 1
NISPUF$Immunizations_UptoDate431_24 <- 0
  NISPUF$Immunizations_UptoDate431_24[NISPUF$DTaP24==1 & NISPUF$Polio24==1 & NISPUF$MMR24==1] <- 1



# Overall immunizations up to date
NISPUF$Immunizations_UptoDate_6 <- 0
  NISPUF$Immunizations_UptoDate_6[NISPUF$HepB6==1 & NISPUF$DTaP6==1 & NISPUF$Hib6==1 & NISPUF$Polio6==1 & NISPUF$PCV6==1 & 
                                  NISPUF$MMR6==1 & NISPUF$Varicella6==1 & NISPUF$HepA6==1 & NISPUF$Rotavirus6==1] <- 1
NISPUF$Immunizations_UptoDate_12 <- 0
  NISPUF$Immunizations_UptoDate_12[NISPUF$HepB12==1 & NISPUF$DTaP12==1 & NISPUF$Hib12==1 & NISPUF$Polio12==1 & NISPUF$PCV12==1 & 
                                   NISPUF$MMR12==1 & NISPUF$Varicella12==1 & NISPUF$HepA12==1 & NISPUF$Rotavirus12==1] <- 1
NISPUF$Immunizations_UptoDate_18 <- 0
  NISPUF$Immunizations_UptoDate_18[NISPUF$HepB18==1 & NISPUF$DTaP18==1 & NISPUF$Hib18==1 & NISPUF$Polio18==1 & NISPUF$PCV18==1 & 
                                   NISPUF$MMR18==1 & NISPUF$Varicella18==1 & NISPUF$HepA18==1 & NISPUF$Rotavirus18==1] <- 1
NISPUF$Immunizations_UptoDate_24 <- 0
  NISPUF$Immunizations_UptoDate_24[NISPUF$HepB6==1 & NISPUF$DTaP24==1 & NISPUF$Hib24==1 & NISPUF$Polio24==1 & NISPUF$PCV24==1 & 
                                   NISPUF$MMR24==1 & NISPUF$Varicella24==1 & NISPUF$HepA24==1 & NISPUF$Rotavirus24==1] <- 1








#####################################
#####################################
#                                   #
#   Determine Whether Child Is      #
#   Up to Date on Vaccinations      #
#    as Reported by Household       #
#   (from memory, no shotcard)      #
#                                   #
#####################################
#####################################

NISPUF$HH_DTaP_UTD <- 0
  NISPUF$HH_DTaP_UTD[NISPUF$HH_DTP==1] <- 1
  NISPUF$HH_DTaP_UTD[NISPUF$HH_DTP==50] <- 50
NISPUF$HH_HEPB_UTD <- 0
  NISPUF$HH_HEPB_UTD[NISPUF$HH_HEPB==1] <- 1
  NISPUF$HH_HEPB_UTD[NISPUF$HH_HEPB==50] <- 50
NISPUF$HH_HIB_UTD <- 0
  NISPUF$HH_HIB_UTD[NISPUF$HH_HIB==1] <- 1
  NISPUF$HH_HIB_UTD[NISPUF$HH_HIB==50] <- 50
NISPUF$HH_MMR_UTD <- 0
  NISPUF$HH_MMR_UTD[NISPUF$HH_MCV==1] <- 1
  NISPUF$HH_MMR_UTD[NISPUF$HH_MCV==50] <- 50
NISPUF$HH_POLIO_UTD <- 0
  NISPUF$HH_POLIO_UTD[NISPUF$HH_POL==1] <- 1
  NISPUF$HH_POLIO_UTD[NISPUF$HH_POL==50] <- 50
NISPUF$HH_VARICELLA_UTD <- 0
  NISPUF$HH_VARICELLA_UTD[NISPUF$HH_VRC==1] <- 1
  NISPUF$HH_VARICELLA_UTD[NISPUF$HH_VRC==50] <- 50

NISPUF$HH_UTD <- 0
  NISPUF$HH_UTD[(NISPUF$HH_DTaP_UTD>0 & NISPUF$HH_HEPB_UTD>0 & NISPUF$HH_HIB_UTD>0 & NISPUF$HH_MMR_UTD>0 & 
                 NISPUF$HH_POLIO_UTD>0 & NISPUF$HH_VARICELLA_UTD>0) &
                (NISPUF$HH_DTaP_UTD!=50 & NISPUF$HH_HEPB_UTD!=50 & NISPUF$HH_HIB_UTD!=50 & NISPUF$HH_MMR_UTD!=50 & 
                   NISPUF$HH_POLIO_UTD!=50 & NISPUF$HH_VARICELLA_UTD!=50)] <- 1
NISPUF$HH_UTD[NISPUF$HH_DTaP_UTD==50 & NISPUF$HH_HEPB_UTD==50 & NISPUF$HH_HIB_UTD==50 & NISPUF$HH_MMR_UTD==50 & 
                NISPUF$HH_POLIO_UTD==50 & NISPUF$HH_VARICELLA_UTD==50] <- 50








#####################################
#####################################
#                                   #
#   Determine Whether Child Is      #
#   Up to Date on Vaccinations      #
#         as Reported by            #
#       Household Shotcard          #
#                                   #
#####################################
#####################################

NISPUF$HHSC_DTaP_UTD <- 0
  NISPUF$HHSC_DTaP_UTD[NISPUF$SC_DTP==1] <- 1
  NISPUF$HHSC_DTaP_UTD[NISPUF$SC_DTP==50] <- 50
NISPUF$HHSC_HEPB_UTD <- 0
  NISPUF$HHSC_HEPB_UTD[NISPUF$SC_HEPB==1] <- 1
  NISPUF$HHSC_HEPB_UTD[NISPUF$SC_HEPB==50] <- 50
NISPUF$HHSC_HIB_UTD <- 0
  NISPUF$HHSC_HIB_UTD[NISPUF$SC_HIB==1] <- 1
  NISPUF$HHSC_HIB_UTD[NISPUF$SC_HIB==50] <- 50
NISPUF$HHSC_MMR_UTD <- 0
  NISPUF$HHSC_MMR_UTD[NISPUF$SC_MCV==1] <- 1
  NISPUF$HHSC_MMR_UTD[NISPUF$SC_MCV==50] <- 50
NISPUF$HHSC_POLIO_UTD <- 0
  NISPUF$HHSC_POLIO_UTD[NISPUF$SC_POL==1] <- 1
  NISPUF$HHSC_POLIO_UTD[NISPUF$SC_POL==50] <- 50
NISPUF$HHSC_VARICELLA_UTD <- 0
  NISPUF$HHSC_VARICELLA_UTD[NISPUF$SC_VRC==1] <- 1
  NISPUF$HHSC_VARICELLA_UTD[NISPUF$SC_VRC==50] <- 50

NISPUF$HHSC_UTD <- 0
NISPUF$HHSC_UTD[(NISPUF$HHSC_DTaP_UTD>0 & NISPUF$HHSC_HEPB_UTD>0 & NISPUF$HHSC_HIB_UTD>0 & NISPUF$HHSC_MMR_UTD>0 & 
                   NISPUF$HHSC_POLIO_UTD>0 & NISPUF$HHSC_VARICELLA_UTD>0) &
                  (NISPUF$HHSC_DTaP_UTD!=50 & NISPUF$HHSC_HEPB_UTD!=50 & NISPUF$HHSC_HIB_UTD!=50 & NISPUF$HHSC_MMR_UTD!=50 & 
                     NISPUF$HHSC_POLIO_UTD!=50 & NISPUF$HHSC_VARICELLA_UTD!=50)] <- 1
NISPUF$HHSC_UTD[NISPUF$HHSC_DTaP_UTD==50 & NISPUF$HHSC_HEPB_UTD==50 & NISPUF$HHSC_HIB_UTD==50 & NISPUF$HHSC_MMR_UTD==50 & 
                  NISPUF$HHSC_POLIO_UTD==50 & NISPUF$HHSC_VARICELLA_UTD==50] <- 50








###################################
## Save NIS data
###################################

write.csv(NISPUF, file="NISPUF.csv")  # CSV so it's readable years from now













#####################################
#####################################
#                                   #
#          Load NFP Data            #
#                                   #
#####################################
#####################################

nfp_demographics     <- read.csv("/mnt/data/nfp_data/csv_data/nfp_demographics_expanded.csv")
nfp_centers          <- read.csv("/mnt/data/nfp_data/csv_data/agency.csv")
nfp_outcomes         <- read.csv("/mnt/data/nfp_data/csv_data/growth_immunization_outcomes.csv")
immun_record_source  <- read.csv("/mnt/data/nfp_data/csv_data/immun_record_source.csv")
discharge_reason     <- read.sas7bdat("/mnt/data/nfp_data/raw_NFP_data/discharge_reason.sas7bdat")
client_program_dates <- read.sas7bdat("/mnt/data/nfp_data/raw_NFP_data/date_range_visits.sas7bdat")









#####################################
#####################################
#                                   #
#        Make NIS, NFP Data         #
#           Compatible              #
#         Before the Merge          #
#                                   #
#####################################
#####################################




############################################
# HOUSEHOLD INCOME
# Note that DK/Refused households are NA

# Although the lowest bins don't match exactly (6000 is the upper limit in NFP and 7500 in NIS),
# assume that both skew heavily toward 0 and treat as comparable
NISPUF$income_recode[NISPUF$INCQ298A==3] <- 1
NISPUF$income_recode[which(is.element(NISPUF$INCQ298A, c(4,5,6)))] = 2        # Binning 7500-20000/year together in both sets
NISPUF$income_recode[which(is.element(NISPUF$INCQ298A, c(7,8)))] = 4          # Binning 20k-30k as in NFP
NISPUF$income_recode[which(is.element(NISPUF$INCQ298A, c(9,10)))] = 5         # Binning 30k-40k as in NFP 
NISPUF$income_recode[which(is.element(NISPUF$INCQ298A, c(11,12,13,14)))] = 6  # Binning 40k+ as in NFP

# In NFP, must combine income brackets 2 and 3 ($7500-20K) to match NIS buckets.
# Note that in the NFP dataset an income code of 7 indicates a mother living off her parents.
nfp_demographics$income_recode = nfp_demographics$INCOME
nfp_demographics$income_recode[nfp_demographics$income_recode == 3] <- 2

# Drop NISPUF$INCQ298A and nfp_demographics$INCOME
NISPUF <- NISPUF[,!(names(NISPUF) %in% "INCQ298A")]
nfp_demographics <- nfp_demographics[,!(names(nfp_demographics) %in% "INCOME")]



############################################
# NFP CENTERS

# Palm Beach County NFP appears in agency.csv twice
nfp_centers <- nfp_centers[-(nfp_centers$AGENCY_NAME=="Palm Beach County NFP" & is.na(nfp_centers$ZipCode)),]

# Location - recoding NFP state data into FIPS codes (to match the NIS dataset)
# make a character vector first
nfp_centers$State <- as.character(nfp_centers$State)  

nfp_centers$State[nfp_centers$State==1] <- "AL"
nfp_centers$State[nfp_centers$State==2] <- "AK"
nfp_centers$State[nfp_centers$State==4] <- "AZ"
nfp_centers$State[nfp_centers$State==5] <- "AR"
nfp_centers$State[nfp_centers$State==6] <- "CA"
nfp_centers$State[nfp_centers$State==8] <- "CO"
nfp_centers$State[nfp_centers$State==9] <- "CT"
nfp_centers$State[nfp_centers$State==10] <- "DE"
nfp_centers$State[nfp_centers$State==11] <- "DC"
nfp_centers$State[nfp_centers$State==12] <- "FL"
nfp_centers$State[nfp_centers$State==13] <- "GA"
nfp_centers$State[nfp_centers$State==15] <- "HI"
nfp_centers$State[nfp_centers$State==16] <- "ID"
nfp_centers$State[nfp_centers$State==17] <- "IL"
nfp_centers$State[nfp_centers$State==18] <- "IN"
nfp_centers$State[nfp_centers$State==19] <- "IA"
nfp_centers$State[nfp_centers$State==20] <- "KS"
nfp_centers$State[nfp_centers$State==21] <- "KY"
nfp_centers$State[nfp_centers$State==22] <- "LA"
nfp_centers$State[nfp_centers$State==23] <- "ME"
nfp_centers$State[nfp_centers$State==24] <- "MD"
nfp_centers$State[nfp_centers$State==25] <- "MA"
nfp_centers$State[nfp_centers$State==26] <- "MI"
nfp_centers$State[nfp_centers$State==27] <- "MN"
nfp_centers$State[nfp_centers$State==28] <- "MS"
nfp_centers$State[nfp_centers$State==29] <- "MO"
nfp_centers$State[nfp_centers$State==30] <- "MT"
nfp_centers$State[nfp_centers$State==31] <- "NE"
nfp_centers$State[nfp_centers$State==32] <- "NV"
nfp_centers$State[nfp_centers$State==33] <- "NH"
nfp_centers$State[nfp_centers$State==34] <- "NJ"
nfp_centers$State[nfp_centers$State==35] <- "NM"
nfp_centers$State[nfp_centers$State==36] <- "NY"
nfp_centers$State[nfp_centers$State==37] <- "NC"
nfp_centers$State[nfp_centers$State==38] <- "ND"
nfp_centers$State[nfp_centers$State==39] <- "OH"
nfp_centers$State[nfp_centers$State==40] <- "OK"
nfp_centers$State[nfp_centers$State==41] <- "OR"
nfp_centers$State[nfp_centers$State==42] <- "PA"
nfp_centers$State[nfp_centers$State==44] <- "RI"
nfp_centers$State[nfp_centers$State==45] <- "SC"
nfp_centers$State[nfp_centers$State==46] <- "SD"
nfp_centers$State[nfp_centers$State==47] <- "TN"
nfp_centers$State[nfp_centers$State==48] <- "TX"
nfp_centers$State[nfp_centers$State==49] <- "UT"
nfp_centers$State[nfp_centers$State==50] <- "VT"
nfp_centers$State[nfp_centers$State==51] <- "VA"
nfp_centers$State[nfp_centers$State==53] <- "WA"
nfp_centers$State[nfp_centers$State==54] <- "WV"
nfp_centers$State[nfp_centers$State==55] <- "WI"
nfp_centers$State[nfp_centers$State==56] <- "WY"


# Some NFP agencies are missing State data.  Add them.
nfp_centers[nfp_centers$Site_ID==274, names(nfp_centers) %in% "State"] <- "WA"
nfp_centers[nfp_centers$Site_ID==280, names(nfp_centers) %in% "State"] <- "SC"
nfp_centers[nfp_centers$Site_ID==281, names(nfp_centers) %in% "State"] <- "NJ"
nfp_centers[nfp_centers$Site_ID==294, names(nfp_centers) %in% "State"] <- "FL"
nfp_centers[nfp_centers$Site_ID==352, names(nfp_centers) %in% "State"] <- "VA"


# Rename nfp_centers$State nfp_centers$STATE
names(nfp_centers)[names(nfp_centers)=='State'] <- 'STATE'





############################################
# LANGUAGE
# Note that we are comparing primary language (NFP) to language in which interview was conducted (NIS)

NISPUF$Primary_language[NISPUF$LANGUAGE==1] <- "English"
NISPUF$Primary_language[NISPUF$LANGUAGE==2] <- "Spanish"
NISPUF$Primary_language[NISPUF$LANGUAGE==3] <- "Other"
NISPUF$language <- factor(NISPUF$Primary_language)

nfp_demographics$language <- as.character(nfp_demographics$Primary_language)
nfp_demographics$language[nfp_demographics$Primary_language==""] <- NA
nfp_demographics$language <- factor(nfp_demographics$language)


# Drop NISPUF$Primary_language and nfp_demographics$language
NISPUF <- NISPUF[,!(names(NISPUF) %in% "LANGUAGE")]
nfp_demographics <- nfp_demographics[,!(names(nfp_demographics) %in% "Primary_language")]




############################################
# MOTHER'S AGE

# Bucketed in NIS data as <=19, 20-29, >=30. 
# True comparison to NFP MomsAgeBirth would be mother's age minus child's age in NIS, but both data points are bucketed.
# Explore ways to make this comparison more accurate, but start by ignoring this distinction.

nfp_demographics$MothersAge[nfp_demographics$MomsAgeBirth <= 19] <- 1
nfp_demographics$MothersAge[20 <= nfp_demographics$MomsAgeBirth & nfp_demographics$MomsAgeBirth <= 29] <- 2
nfp_demographics$MothersAge[nfp_demographics$MomsAgeBirth >= 30] <- 3
nfp_demographics$MothersAge <- factor(nfp_demographics$MothersAge, labels = c("<=19 Years", "20-29 Years", ">=30 Years"))
NISPUF$MothersAge <- factor(NISPUF$M_AGEGRP, labels = c("<=19 Years", "20-29 Years", ">=30 Years"))

# Delete NISPUF$M_AGEGRP and nfp_demographics$MomsAgeBirth
NISPUF <- NISPUF[,!(names(NISPUF) %in% "M_AGEGRP")]
nfp_demographics <- nfp_demographics[,!(names(nfp_demographics) %in% "MomsAgeBirth")]




############################################
# RACE

# Only child's race is available from NIS and only mother's race from NFP.
# Must assume these are the same.

NISPUF$Race <- factor(NISPUF$RACEETHK, labels = c("Hispanic", "WhiteNH", "BlackNH", "Other"))
nfp_demographics$Race <- as.character(nfp_demographics$MomsRE) # Renaming variable
nfp_demographics$Race[nfp_demographics$Race=="Hispanic or Latina"] <- "Hispanic" # Shortening description
nfp_demographics$Race[nfp_demographics$Race=="Declined or msg"] <- NA 
nfp_demographics$Race <- factor(nfp_demographics$Race) # Return to factor format with adjusted levels

# Drop NISPUF$RACEETHK and nfp_demographics$MomsRE
NISPUF <- NISPUF[,!(names(NISPUF) %in% "RACEETHK")]
nfp_demographics <- nfp_demographics[,!(names(nfp_demographics) %in% "MomsRE")]





############################################
# MALE

NISPUF$male[NISPUF$SEX==1] <- 1
NISPUF$male[NISPUF$SEX==2] <- 0

nfp_demographics$male[nfp_demographics$Childgender=="Male"] <- 1 
nfp_demographics$male[nfp_demographics$Childgender=="Female"] <- 0 

# Drop NISPUF$SEX and nfp_demographics$Childgender
NISPUF <- NISPUF[,!(names(NISPUF) %in% "SEX")]
nfp_demographics <- nfp_demographics[,!(names(nfp_demographics) %in% "Childgender")]





############################################
# MOTHER'S MARITAL STATUS

nfp_demographics$married <- nfp_demographics$marital_status   # Rename variable so meaning of 1/0 is more evident
NISPUF$married[NISPUF$MARITAL2==1] <- 1
NISPUF$married[NISPUF$MARITAL2==2] <- 0

# Drop NISPUF$MARITAL2 and nfp_demographics$marital_status
NISPUF <- NISPUF[,!(names(NISPUF) %in% "MARITAL2")]
nfp_demographics <- nfp_demographics[,!(names(nfp_demographics) %in% "marital_status")]





############################################
# MOTHER'S EDUCATION

# NFP tracks HS diploma, GED, or neither (HSGED).
# NIS has <12 years, 12 years, or 12+ years.  Original questionnaire wording buckets HS degrees and GEDs together.

NISPUF$HSgrad[NISPUF$EDUC1==1] <- 0
NISPUF$HSgrad[which(is.element(NISPUF$EDUC1,c(2,3,4)))] <- 1

nfp_demographics$HSgrad[nfp_demographics$HSGED==1] <- 1
nfp_demographics$HSgrad[nfp_demographics$HSGED==2] <- 1
nfp_demographics$HSgrad[nfp_demographics$HSGED==3] <- 0

# Drop NISPUF$EDUC1 & nfp_demographics$HSGED
NISPUF <- NISPUF[,!(names(NISPUF) %in% "EDUC1")]
nfp_demographics <- nfp_demographics[,!(names(nfp_demographics) %in% "HSGED")]







############################################
# DISCHARGE REASON

names(discharge_reason)[names(discharge_reason)=="clid"] <- "ID"
names(nfp_demographics)[names(nfp_demographics)=="CL_EN_GEN_ID"] <- "ID"
nfp_demographics <- merge(nfp_demographics, discharge_reason, by=intersect("ID", "ID"), all=TRUE)

NISPUF$ReasonForDismissal <- NA





############################################
# DATES OF FIRST VISIT, LAST VISIT, AND DISCHARGE

names(client_program_dates)[names(client_program_dates)=="cl_en_gen_id"] <- "ID"
nfp_demographics <- merge(nfp_demographics, client_program_dates, by=intersect("ID", "ID"), all=TRUE)

NISPUF$First_Home_Visit <- NA
NISPUF$Last_Home_Visit <- NA
NISPUF$Discharge_Date <- NA






############################################
# WIC/TANF/INSURANCE

# NFP does not have good data for these variables









########################################
# IMMUNIZATIONS UP TO DATE

nfp_outcomes$Immunizations_UptoDate_6[nfp_outcomes$final_immun_1=="Yes"] <- 1
  nfp_outcomes$Immunizations_UptoDate_6[nfp_outcomes$final_immun_1=="No"] <- 0
nfp_outcomes$Immunizations_UptoDate_12[nfp_outcomes$final_immun_2=="Yes"] <- 1
  nfp_outcomes$Immunizations_UptoDate_12[nfp_outcomes$final_immun_2=="No"] <- 0
nfp_outcomes$Immunizations_UptoDate_18[nfp_outcomes$final_immun_3=="Yes"] <- 1
  nfp_outcomes$Immunizations_UptoDate_18[nfp_outcomes$final_immun_3=="No"] <- 0
nfp_outcomes$Immunizations_UptoDate_24[nfp_outcomes$final_immun_4=="Yes"] <- 1
  nfp_outcomes$Immunizations_UptoDate_24[nfp_outcomes$final_immun_4=="No"] <- 0

# Drop nfp_outcomes$final_immun_*
nfp_outcomes <- nfp_outcomes[,!(names(nfp_outcomes) %in% c("final_immun_1","final_immun_2","final_immun_3","final_immun_4"))]







############################################
# IMMUNIZATION DATA SOURCES

# Some single-quotation marks came in as Unicode.  Replace.
immun_record_source$immun_record_source_1 <- gsub("\U3e32393c", "'", as.character(immun_record_source$immun_record_source_1))
immun_record_source$immun_record_source_2 <- gsub("\U3e32393c", "'", as.character(immun_record_source$immun_record_source_2))
immun_record_source$immun_record_source_3 <- gsub("\U3e32393c", "'", as.character(immun_record_source$immun_record_source_3))
immun_record_source$immun_record_source_4 <- gsub("\U3e32393c", "'", as.character(immun_record_source$immun_record_source_4))

# Recode values
immun_record_source$immun_record_source_1[immun_record_source$immun_record_source_1==""] <- NA
  immun_record_source$immun_record_source_1[immun_record_source$immun_record_source_1=="Written record"] <- "record"
  immun_record_source$immun_record_source_1[immun_record_source$immun_record_source_1=="Mother's self-report"] <- "mother"
immun_record_source$immun_record_source_2[immun_record_source$immun_record_source_2==""] <- NA
  immun_record_source$immun_record_source_2[immun_record_source$immun_record_source_2=="Written record"] <- "record"
  immun_record_source$immun_record_source_2[immun_record_source$immun_record_source_2=="Mother's self-report"] <- "mother"
immun_record_source$immun_record_source_3[immun_record_source$immun_record_source_3==""] <- NA
  immun_record_source$immun_record_source_3[immun_record_source$immun_record_source_3=="Written record"] <- "record"
  immun_record_source$immun_record_source_3[immun_record_source$immun_record_source_3=="Mother's self-report"] <- "mother"
immun_record_source$immun_record_source_4[immun_record_source$immun_record_source_4==""] <- NA
  immun_record_source$immun_record_source_4[immun_record_source$immun_record_source_4=="Written record"] <- "record"
  immun_record_source$immun_record_source_4[immun_record_source$immun_record_source_4=="Mother's self-report"] <- "mother"

# Rename immun_record_source$cl_en_gen_id as immun_record_source$CL_EN_GEN_ID
names(immun_record_source)[names(immun_record_source)=='cl_en_gen_id'] <- 'CL_EN_GEN_ID'











#####################################
#####################################
#                                   #
#       Merge NFP, NIS data         #
#                                   #
#####################################
#####################################


############################################
# AGENCY REQUIREMENTS

# Cannot match on these because NIS data are not specific enough






############################################
# NFP_OUTCOMES and IMMUN_RECORD_SOURCE

# Check the dimensions before and after to make sure it merged correctly
dim(nfp_outcomes)
dim(immun_record_source)

# Merge the datasets
nfp_outcomes <- merge(nfp_outcomes, immun_record_source, by="CL_EN_GEN_ID", all=TRUE)
dim(nfp_outcomes)





############################################
# NFP_DEMOGRAPHICS and NFP_OUTCOMES

# Check the dimensions before and after to make sure it merged correctly
dim(nfp_demographics)
dim(nfp_outcomes)

# Merge NFP demographics and immunization datasets and rename ID variable
names(nfp_outcomes)[names(nfp_outcomes)=="CL_EN_GEN_ID"] <- "ID"
NFPfull <- merge(nfp_demographics, nfp_outcomes, by="ID", all=TRUE)
  names(NFPfull)[names(NFPfull)=="State"] <- "STATE"
dim(NFPfull)









#####################################
#####################################
#                                   #
#       More Variable Changes       #
#       on the full NFP data        #
#                                   #
#####################################
#####################################


############################################
# ADEQUATE PROVIDER DATA AT 6, 12, 18, 24 MONTHS?

NFPfull$PDAT6 <- 0
  NFPfull$PDAT6[NFPfull$immun_record_source_1=="record"] <- 1
NFPfull$PDAT12 <- 0
  NFPfull$PDAT12[NFPfull$immun_record_source_2=="record"] <- 1
NFPfull$PDAT18 <- 0
  NFPfull$PDAT18[NFPfull$immun_record_source_3=="record"] <- 1
NFPfull$PDAT24 <- 0
  NFPfull$PDAT24[NFPfull$immun_record_source_4=="record"] <- 1

NISPUF$PDAT6 <- NISPUF$PDAT
NISPUF$PDAT12 <- NISPUF$PDAT
NISPUF$PDAT18 <- NISPUF$PDAT
NISPUF$PDAT24 <- NISPUF$PDAT





############################################
# CHOOSE NIS IMMUNIZATION SOURCE (SELF REPORT, SHOTCARD, PROVIDER) FOR COMPARISON

# The NFP dataset asks the the nurse the following: "Based on your local immunization
# schedule, (regardless of vaccine brand or manufacturer) is (child's name) up to date
# on all vaccinations?"  This question does not make explicit which vaccines the children 
# should have, but considering the much higher immunization rates we find in the NFP dataset, 
# I'm biasing against NFP by setting a low bar for the general population: whether the
# child has the recommended DTaP, polio, and MMR vaccines (e.g. variable 
# Immunizations_UptoDate431_6), not whether she also has Hib, HepA and HepB, Varicella, 
# and Rotavirus (e.g. variable Immunizations_UptoDate_6).  This means that I need to keep
# the NIS Immunizations_UptoDate431 variables but that they need to be named 
# Immunizations_UptoDate to match the NFP dataset.

NISPUF <- NISPUF[,!(names(NISPUF) %in% c("Immunizations_UptoDate_6",
                                         "Immunizations_UptoDate_12",
                                         "Immunizations_UptoDate_18",
                                         "Immunizations_UptoDate_24"))]
names(NISPUF)[names(NISPUF)=="Immunizations_UptoDate431_6"] <- "Immunizations_UptoDate_6"
names(NISPUF)[names(NISPUF)=="Immunizations_UptoDate431_12"] <- "Immunizations_UptoDate_12"
names(NISPUF)[names(NISPUF)=="Immunizations_UptoDate431_18"] <- "Immunizations_UptoDate_18"
names(NISPUF)[names(NISPUF)=="Immunizations_UptoDate431_24"] <- "Immunizations_UptoDate_24"







############################################
# TREATMENT VARIABLE

NISPUF$treatment <- 0
NFPfull$treatment <- 1











#####################################
#####################################
#                                   #
#            Final merge            #
#                                   #
#####################################
#####################################


# Subset using only the variables we want to use in the analysis
NIScommon <- subset(NISPUF, select = c(ID, STATE, treatment, PDAT6, PDAT12, PDAT18, PDAT24, income_recode, language, MothersAge, Race, married, male, HSgrad, Immunizations_UptoDate_6, Immunizations_UptoDate_12, Immunizations_UptoDate_18, Immunizations_UptoDate_24, ReasonForDismissal, First_Home_Visit, Last_Home_Visit, Discharge_Date))
NFPcommon <- subset(NFPfull, select = c(ID, STATE, treatment, PDAT6, PDAT12, PDAT18, PDAT24, income_recode, language, MothersAge, Race, married, male, HSgrad, Immunizations_UptoDate_6, Immunizations_UptoDate_12, Immunizations_UptoDate_18, Immunizations_UptoDate_24, ReasonForDismissal, First_Home_Visit, Last_Home_Visit, Discharge_Date))


immunizations <- rbind(NIScommon, NFPcommon)

write.csv(immunizations, "/mnt/data/NIS/modified_data/immunizations_analysis.csv")


rm(list=ls())
