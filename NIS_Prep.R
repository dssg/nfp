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

# Variable Recodes - NIS
nis_income_recode08 = rep(0,dim(NISPUF08)[1])
nis_income_recode09 = rep(0,dim(NISPUF09)[1])
nis_income_recode10 = rep(0, dim(NISPUF10)[1])
nis_income_recode11 = rep(0, dim(NISPUF11)[1])

# Although the lowest bins don't match exactly (6000 upper limit in nfp and 7500 in NIS,
#### we will treat them as the same)
nis_income_recode08[which(is.element(NISPUF08$STATE, c(3))] == 1
nis_income_recode09[which(is.element(NISPUF09$STATE, c(3))] == 1
nis_income_recode10[which(is.element(NISPUF10$STATE, c(3))] == 1
nis_income_recode11[which(is.element(NISPUF11$STATE, c(3))] == 1


# Binning 7500-20000/year together in both sets
nis_income_recode08[which(is.element(NISPUF08$STATE, c(4,5,6))] == 2
nis_income_recode09[which(is.element(NISPUF09$STATE, c(4,5,6))] == 2
nis_income_recode10[which(is.element(NISPUF10$STATE, c(4,5,6))] == 2
nis_income_recode11[which(is.element(NISPUF11$STATE, c(4,5,6))] == 2

# Binning 20k-30k as in nfp

nis_income_recode08[which(is.element(NISPUF08$STATE, c(7,8))] == 4
nis_income_recode09[which(is.element(NISPUF09$STATE, c(7,8))] == 4
nis_income_recode10[which(is.element(NISPUF10$STATE, c(7,8))] == 4
nis_income_recode11[which(is.element(NISPUF11$STATE, c(7,8))] == 4

# Binning 30k-40k in the same was as nfp

nis_income_recode08[which(is.element(NISPUF08$STATE, c(9,10))] == 5
nis_income_recode09[which(is.element(NISPUF09$STATE, c(9,10))] == 5
nis_income_recode10[which(is.element(NISPUF10$STATE, c(9,10))] == 5
nis_income_recode11[which(is.element(NISPUF11$STATE, c(9,10))] == 5

nis_income_recode08[which(is.element(NISPUF08$STATE, c(11,12,13,14))] == 6
nis_income_recode09[which(is.element(NISPUF09$STATE, c(11,12,13,14))] == 6
nis_income_recode10[which(is.element(NISPUF10$STATE, c(11,12,13,14))] == 6
nis_income_recode11[which(is.element(NISPUF11$STATE, c(11,12,13,14))] == 6

# We may want to dump all families with codes of 77 or 99 since these are either don't know or refused

# Load NFP data for recoding and preparation

setwd("/mnt/data/csv_data")
nfp_demographics <- read.csv("nfp_demographics_expanded.csv")
nfp_centers <- read.csv("agency.csv")

# Variable Recodes - NFP
nfp_state_recode = rep(0,dim(nfp_centers)[1])

nfp_state_recode[which(nfp_centers$State == 'WY')] = 56
nfp_state_recode[which(nfp_centers$State == 'AL')] = 1
nfp_state_recode[which(nfp_centers$State == 'AK')] = 2
nfp_state_recode[which(nfp_centers$State == 'AS')] = 60
nfp_state_recode[which(nfp_centers$State == 'AS')] = 3
nfp_state_recode[which(nfp_centers$State == 'AZ')] = 4
nfp_state_recode[which(nfp_centers$State == 'AR')] = 5
nfp_state_recode[which(nfp_centers$State == 'AR')] = 81
nfp_state_recode[which(nfp_centers$State == 'CA')] = 6
nfp_state_recode[which(nfp_centers$State == 'CA')] = 7
nfp_state_recode[which(nfp_centers$State == 'CO')] = 8
nfp_state_recode[which(nfp_centers$State == 'CT')] = 9
nfp_state_recode[which(nfp_centers$State == 'DE')] = 10
nfp_state_recode[which(nfp_centers$State == 'DC')] = 11
nfp_state_recode[which(nfp_centers$State == 'FL')] = 12
nfp_state_recode[which(nfp_centers$State == 'FM')] = 64
nfp_state_recode[which(nfp_centers$State == 'GA')] = 13
nfp_state_recode[which(nfp_centers$State == 'GA')] = 14
nfp_state_recode[which(nfp_centers$State == 'GU')] = 66
nfp_state_recode[which(nfp_centers$State == 'HI')] = 15
nfp_state_recode[which(nfp_centers$State == 'HI')] = 84
nfp_state_recode[which(nfp_centers$State == 'ID')] = 16
nfp_state_recode[which(nfp_centers$State == 'IL')] = 17
nfp_state_recode[which(nfp_centers$State == 'IN')] = 18
nfp_state_recode[which(nfp_centers$State == 'IA')] = 19
nfp_state_recode[which(nfp_centers$State == 'IA')] = 86
nfp_state_recode[which(nfp_centers$State == 'IA')] = 67
nfp_state_recode[which(nfp_centers$State == 'KS')] = 20
nfp_state_recode[which(nfp_centers$State == 'KY')] = 21
nfp_state_recode[which(nfp_centers$State == 'KY')] = 89
nfp_state_recode[which(nfp_centers$State == 'LA')] = 22
nfp_state_recode[which(nfp_centers$State == 'ME')] = 23
nfp_state_recode[which(nfp_centers$State == 'MH')] = 68
nfp_state_recode[which(nfp_centers$State == 'MD')] = 24
nfp_state_recode[which(nfp_centers$State == 'MA')] = 25
nfp_state_recode[which(nfp_centers$State == 'MI')] = 26
nfp_state_recode[which(nfp_centers$State == 'MI')] = 71
nfp_state_recode[which(nfp_centers$State == 'MN')] = 27
nfp_state_recode[which(nfp_centers$State == 'MS')] = 28
nfp_state_recode[which(nfp_centers$State == 'MO')] = 29
nfp_state_recode[which(nfp_centers$State == 'MT')] = 30
nfp_state_recode[which(nfp_centers$State == 'MT')] = 76
nfp_state_recode[which(nfp_centers$State == 'NE')] = 31
nfp_state_recode[which(nfp_centers$State == 'NV')] = 32
nfp_state_recode[which(nfp_centers$State == 'NH')] = 33
nfp_state_recode[which(nfp_centers$State == 'NJ')] = 34
nfp_state_recode[which(nfp_centers$State == 'NM')] = 35
nfp_state_recode[which(nfp_centers$State == 'NY')] = 36
nfp_state_recode[which(nfp_centers$State == 'NC')] = 37
nfp_state_recode[which(nfp_centers$State == 'ND')] = 38
nfp_state_recode[which(nfp_centers$State == 'MP')] = 69
nfp_state_recode[which(nfp_centers$State == 'OH')] = 39
nfp_state_recode[which(nfp_centers$State == 'OK')] = 40
nfp_state_recode[which(nfp_centers$State == 'OR')] = 41
nfp_state_recode[which(nfp_centers$State == 'PW')] = 70
nfp_state_recode[which(nfp_centers$State == 'PW')] = 95
nfp_state_recode[which(nfp_centers$State == 'PA')] = 42
nfp_state_recode[which(nfp_centers$State == 'PA')] = 43
nfp_state_recode[which(nfp_centers$State == 'PR')] = 72
nfp_state_recode[which(nfp_centers$State == 'RI')] = 44
nfp_state_recode[which(nfp_centers$State == 'SC')] = 45
nfp_state_recode[which(nfp_centers$State == 'SD')] = 46
nfp_state_recode[which(nfp_centers$State == 'TN')] = 47
nfp_state_recode[which(nfp_centers$State == 'TX')] = 48
nfp_state_recode[which(nfp_centers$State == 'UM')] = 74
nfp_state_recode[which(nfp_centers$State == 'UT')] = 49
nfp_state_recode[which(nfp_centers$State == 'VT')] = 50
nfp_state_recode[which(nfp_centers$State == 'VA')] = 51
nfp_state_recode[which(nfp_centers$State == 'VA')] = 52
nfp_state_recode[which(nfp_centers$State == 'VI')] = 78
nfp_state_recode[which(nfp_centers$State == 'VI')] = 79
nfp_state_recode[which(nfp_centers$State == 'WA')] = 53
nfp_state_recode[which(nfp_centers$State == 'WV')] = 54
nfp_state_recode[which(nfp_centers$State == 'WI')] = 55
nfp_state_recode[which(nfp_centers$State == 'WY')] = 56

# We must recode 2 and 3 as just two.

nfp_income_recode = nfp_demographics$Income
nfp_income_recode[which(nfp_income_recode == 3)] = 2

# We might want to get rid of nfp rows with income value of 7 since these are people that live off their parents.

#Recode Language in nfp
nfp_language_recode = rep(0,dim(nfp_demographics)[1])
nfp_language_recode[which(nfp_demographics$Primary_language == 'English')] = 1
nfp_language_recode[which(nfp_demographics$Primary_language == 'Spanish')] = 2
nfp_language_recode[which(nfp_demographics$Primary_language == 'Other')] = 3

# All entries marked with a 0 are the ones with no value in the nfp demographics set
