#################################
##    Data Preparation File    ##
##         Joe Walsh           ##
#################################


## NIS provides R scripts to prepare the data for analysis.  Run each and make a few modifications.
## I'm commenting out the source lines because 1) once they're run they don't need to run again and 2) they take too long to run.
# 2008
#source("/mnt/data/NIS/original_data/nispuf08.r")
#NISPUF08 <- subset(NISPUF08, PDAT==1)
#save("NISPUF08", "/mnt/data/NIS/modified_data/NISPUF08.RData")
#source("/mnt/data/NIS/original_data/nispuf09.r")
#source("/mnt/data/NIS/original_data/nispuf10.r")
#source("/mnt/data/NIS/original_data/nispuf11.r")


# Load NIS data for recoding and preparation
setwd("/mnt/data/NIS/modified_data")
load("NISPUF08.RData")
load("NISPUF09.RData")
load("NISPUF10.RData")
load("NISPUF11.RData")

# Eventually we'll merge all four years of NIS data.  For now, just working with 2008 data.
NIS <- NISPUF08

# Load NFP data for recoding and preparation
setwd("/mnt/data/csv_data")
nfp_demographics <- read.csv("nfp_demographics_expanded.csv")
nfp_centers <- read.csv("agency.csv")



## VARIABLE RECODES

# Mother's Age - Bucketed in NIS data as <=19, 20-29, >=30. 
# True comparison to NFP MomsAgeBirth would be mother's age minus child's age in NIS, but both data points are bucketed.
# Explore ways to make this comparison more accurate, but start by ignoring this distinction.

nfp_demographics$MAge[nfp_demographics$MomsAgeBirth <= 19] <- 1
nfp_demographics$MAge[20 <= nfp_demographics$MomsAgeBirth & nfp_demographics$MomsAgeBirth <= 29] <- 2
nfp_demographics$MAge[nfp_demographics$MomsAgeBirth >= 30] <- 3
nfp_demographics$MAge <- factor(nfp_demographics$MAge, labels = c("<=19 Years", "20-29 Years", ">=30 Years"))
NIS$MAge <- factor(NIS$M_AGEGRP, labels = c("<=19 Years", "20-29 Years", ">=30 Years"))


# Race - Only child's race is available from NIS and only mother's race from NFP.
# Must assume these are the same.

NIS$RE <- factor(NIS$RACEETHK, labels = c("Hispanic", "WhiteNH", "BlackNH", "Other"))
nfp_demographics$RE <- as.character(nfp_demographics$MomsRE) # Renaming variable
nfp_demographics$RE[nfp_demographics$RE=="Hispanic or Latina"] <- "Hispanic" # Shortening description
nfp_demographics$RE[nfp_demographics$RE=="Declined or msg"] <- NA 
nfp_demographics$RE <- factor(nfp_demographics$RE) # Return to factor format with adjusted levels


# Child's gender: Create a binary dummy variable for "male"

NIS$male[NIS$SEX==1] <- 1
NIS$male[NIS$SEX==2] <- 0
nfp_demographics$male[nfp_demographics$Childgender=="Female"] <- 0 # Recode factor variable
nfp_demographics$male[nfp_demographics$Childgender=="Male"] <- 1 


# Mother's marital status
# NIS provides only married v. never married/widowed/divorced/separated/deceased
### This is listed as MARITAL2 in the codebook, but only MARITAL is in dataset, and it has a third value.  Need to find codes!
# We have more detail for NFP, but NFP also provided a binary (nfp_demographics$marital_status) equivalent to this value.

nfp_demographics$married <- nfp_demographics$marital_status # Rename variable so meaning of 1/0 is more evident
NIS$married <- NIS$MARITAL # Need to investigate codes and recode appropriately



# Mother's education


