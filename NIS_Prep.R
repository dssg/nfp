##################################
##    Data Preparation File     ##
## National Immunization Survey ##
##         Joe Walsh            ##
##         Emily Rowe           ##
##        Adam Fishman          ##
##################################

setwd("/mnt/data/NIS/modified_data/")

## NIS provides R scripts to prepare the data for analysis.  Run each and make a few modifications.
## I'm commenting out the source lines that call NIS-provided code because 
## 1) once they're run they don't need to run again and 2) they take too long to run.

############
# OUTCOMES - 2008 NIS data
#source("/mnt/data/NIS/original_data/nispuf08.r")
load("NISPUF08.RData")

# eliminate observations missing adequate provider data
NISPUF08 <- subset(NISPUF08, PDAT==1)  #PDAT=="CHILD HAS ADEQUATE PROVIDER DATA OR ZERO VACCINATIONS")
n_2008 <- nrow(NISPUF08)

# HepB immunizations up to date
HepB6 <- rep(0, n_2008)		# adequate immunizations at 6 months
  HepB6[NISPUF08$DHEPB2<31*6] <- 1
HepB12 <- rep(0, n_2008)	# adequate immunizations at 12 months
  HepB12[NISPUF08$DHEPB2<31*12] <- 1
HepB18 <- rep(0, n_2008)	# adequate immunizations at 18 months
  HepB18[NISPUF08$DHEPB3<31*18] <- 1
HepB24 <- rep(0, n_2008)	# adequate immunizations at 24 months
  HepB24[NISPUF08$DHEPB3<31*24] <- 1

# DTaP immunizations up to date
DTaP6 <- rep(0, n_2008)
  DTaP6[NISPUF08$DDTP3<31*6] <- 1
DTaP12 <- rep(0, n_2008)
  DTaP12[NISPUF08$DDTP3<31*12] <- 1
DTaP18 <- rep(0, n_2008)
  DTaP18[NISPUF08$DDTP4<31*18] <- 1
DTaP24 <- rep(0, n_2008)
  DTaP24[NISPUF08$DDTP4<31*24] <- 1

# Hib immunizations up to date
Hib6 <- rep(0, n_2008)
  Hib6[NISPUF08$DHIB3<31*6] <- 1
Hib12 <- rep(0, n_2008)
  Hib12[NISPUF08$DHIB3<31*12] <- 1
Hib18 <- rep(0, n_2008)
  Hib18[NISPUF08$DHIB4<31*18] <- 1
Hib24 <- rep(0, n_2008)
  Hib24[NISPUF08$DHIB4<31*24] <- 1

# Polio immunizations up to date
Polio6 <- rep(0, n_2008)
  Polio6[NISPUF08$DPOLIO2<31*6] <- 1
Polio12 <- rep(0, n_2008)
  Polio12[NISPUF08$DPOLIO2<31*12] <- 1
Polio18 <- rep(0, n_2008)
  Polio18[NISPUF08$DPOLIO3<31*18] <- 1
Polio24 <- rep(0, n_2008)
  Polio24[NISPUF08$DPOLIO3<31*24] <- 1

# PCV immunizations up to date
PCV6 <- rep(0, n_2008)
  PCV6[NISPUF08$DPCV3<31*6] <- 1
PCV12 <- rep(0, n_2008)
  PCV12[NISPUF08$DPCV3<31*12] <- 1
PCV18 <- rep(0, n_2008)
  PCV18[NISPUF08$DPCV4<31*18] <- 1
PCV24 <- rep(0, n_2008)
  PCV24[NISPUF08$DPCV4<31*24] <- 1

# MMR immunization up to date
MMR6 <- rep(1, n_2008)
MMR12 <- rep(1, n_2008)
MMR18 <- rep(1, n_2008)
  MMR18[NISPUF08$DMMR1<31*18] <- 1
MMR24 <- rep(1, n_2008)
  MMR24[NISPUF08$DMMR1<31*24] <- 1

# Varicella immunization up to date
Varicella6 <- rep(1, n_2008)
Varicella12 <- rep(1, n_2008)
Varicella18 <- rep(1, n_2008)
  Varicella18[NISPUF08$DVRC1<31*18] <- 1
Varicella24 <- rep(1, n_2008)
  Varicella24[NISPUF08$DVRC1<31*24] <- 1

# HepA immunization up to date
HepA6 <- rep(1, n_2008)
HepA12 <- rep(1, n_2008)
HepA18 <- rep(0, n_2008)
  HepA18[NISPUF08$DHEPA1<31*18] <- 1
HepA24 <- rep(0, n_2008)
  HepA24[NISPUF08$DHEPA1<31*24] <- 1

# Rotavirus immunization up to date
Rotavirus6 <- rep(0, n_2008)
  Rotavirus6[NISPUF08$DROT3<31*6] <- 1
Rotavirus12 <- rep(0, n_2008)
  Rotavirus12[NISPUF08$DROT3<31*12] <- 1
Rotavirus18 <- rep(0, n_2008)
  Rotavirus18[NISPUF08$DROT3<31*18] <- 1
Rotavirus24 <- rep(0, n_2008)
  Rotavirus24[NISPUF08$DROT3<31*24] <- 1

# Overall immunizations up to date
Immunizations_UptoDate_6 <- rep(0, n_2008)
  Immunizations_UptoDate_6[HepB6==1 & DTaP6==1 & Hib6==1 & Polio6==1 & PCV6==1 & MMR6==1 & Varicella6==1 & HepA6==1 & Rotavirus6==1] <- 1

save("NISPUF08", "/mnt/data/NIS/modified_data/NISPUF08.RData")

#source("/mnt/data/NIS/original_data/nispuf09.r")
#source("/mnt/data/NIS/original_data/nispuf10.r")
#source("/mnt/data/NIS/original_data/nispuf11.r")



# Variable Recodes
## Eventually we'll merge all four years of NIS data.  For now, just working with 2008 data.
NIS <- NISPUF08

# Load NFP data for recoding and preparation
setwd("/mnt/data/csv_data")
nfp_demographics <- read.csv("nfp_demographics_expanded.csv")
nfp_centers <- read.csv("agency.csv")


##Household income - note that DK/Refused households are NA

### Although the lowest bins don't match exactly (6000 is the upper limit in NFP and 7500 in NIS),
### assume that both skew heavily toward 0 and treat as comparable
NIS$income_recode[NIS$INCQ298A==3] <- 1
NIS$income_recode[which(is.element(NIS$INCQ298A, c(4,5,6)))] = 2 # Binning 7500-20000/year together in both sets
NIS$income_recode[which(is.element(NIS$INCQ298A, c(7,8)))] = 4 # Binning 20k-30k as in nfp
NIS$income_recode[which(is.element(NIS$INCQ298A, c(9,10)))] = 5 # Binning 30k-40k in the same was as nfp
NIS$income_recode[which(is.element(NIS$INCQ298A, c(11,12,13,14)))] = 6

### In NFP, must combine income brackets 2 and 3 ($7500-20K) to match NIS buckets.
nfp_demographics$nfp_income_recode = nfp_demographics$INCOME
nfp_demographics$nfp_income_recode[nfp_demographics$nfp_income_recode == 3] <- 2
### Note that in the NFP dataset an income code of 7 indicates a mother living off her parents.



## Location - recoding NFP state data into FIPS codes (to match the NIS dataset)
nfp_demographics$nfp_state_recode = rep(NA,dim(nfp_demographics)[1])
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'WY'] = 56
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'AL'] = 1
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'AK'] = 2
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'AS'] = 60
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'AS'] = 3
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'AZ'] = 4
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'AR'] = 5
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'AR'] = 81
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'CA'] = 6
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'CA'] = 7
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'CO'] = 8
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'CT'] = 9
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'DE'] = 10
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'DC'] = 11
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'FL'] = 12
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'FM'] = 64
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'GA'] = 13
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'GA'] = 14
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'GU'] = 66
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'HI'] = 15
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'HI'] = 84
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'ID'] = 16
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'IL'] = 17
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'IN'] = 18
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'IA'] = 19
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'IA'] = 86
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'IA'] = 67
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'KS'] = 20
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'KY'] = 21
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'KY'] = 89
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'LA'] = 22
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'ME'] = 23
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'MH'] = 68
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'MD'] = 24
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'MA'] = 25
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'MI'] = 26
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'MI'] = 71
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'MN'] = 27
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'MS'] = 28
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'MO'] = 29
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'MT'] = 30
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'MT'] = 76
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'NE'] = 31
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'NV'] = 32
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'NH'] = 33
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'NJ'] = 34
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'NM'] = 35
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'NY'] = 36
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'NC'] = 37
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'ND'] = 38
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'MP'] = 69
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'OH'] = 39
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'OK'] = 40
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'OR'] = 41
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'PW'] = 70
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'PW'] = 95
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'PA'] = 42
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'PA'] = 43
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'PR'] = 72
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'RI'] = 44
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'SC'] = 45
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'SD'] = 46
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'TN'] = 47
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'TX'] = 48
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'UM'] = 74
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'UT'] = 49
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'VT'] = 50
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'VA'] = 51
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'VA'] = 52
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'VI'] = 78
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'VI'] = 79
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'WA'] = 53
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'WV'] = 54
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'WI'] = 55
nfp_demographics$nfp_state_recode[nfp_demographics$State == 'WY'] = 56


## Language - note that we are comparing primary language (NFP) to language in which interview was conducted (NIS)
NIS$Primary_language[NIS$LANGUAGE==1] <- "English"
NIS$Primary_language[NIS$LANGUAGE==2] <- "Spanish"
NIS$Primary_language[NIS$LANGUAGE==3] <- "Other"
NIS$language <- factor(NIS$Primary_language)

nfp_demographics$language <- as.character(nfp_demographics$Primary_language)
nfp_demographics$language[nfp_demographics$Primary_language==""] <- NA
nfp_demographics$language <- factor(nfp_demographics$language)

## Mother's Age - Bucketed in NIS data as <=19, 20-29, >=30. 
### True comparison to NFP MomsAgeBirth would be mother's age minus child's age in NIS, but both data points are bucketed.
### Explore ways to make this comparison more accurate, but start by ignoring this distinction.

nfp_demographics$MAge[nfp_demographics$MomsAgeBirth <= 19] <- 1
nfp_demographics$MAge[20 <= nfp_demographics$MomsAgeBirth & nfp_demographics$MomsAgeBirth <= 29] <- 2
nfp_demographics$MAge[nfp_demographics$MomsAgeBirth >= 30] <- 3
nfp_demographics$MAge <- factor(nfp_demographics$MAge, labels = c("<=19 Years", "20-29 Years", ">=30 Years"))
NIS$MAge <- factor(NIS$M_AGEGRP, labels = c("<=19 Years", "20-29 Years", ">=30 Years"))


## Race - Only child's race is available from NIS and only mother's race from NFP.
### Must assume these are the same.

NIS$RE <- factor(NIS$RACEETHK, labels = c("Hispanic", "WhiteNH", "BlackNH", "Other"))
nfp_demographics$RE <- as.character(nfp_demographics$MomsRE) # Renaming variable
nfp_demographics$RE[nfp_demographics$RE=="Hispanic or Latina"] <- "Hispanic" # Shortening description
nfp_demographics$RE[nfp_demographics$RE=="Declined or msg"] <- NA 
nfp_demographics$RE <- factor(nfp_demographics$RE) # Return to factor format with adjusted levels


## Child's gender: Create a binary dummy variable for "male"

NIS$male[NIS$SEX==1] <- 1
NIS$male[NIS$SEX==2] <- 0
nfp_demographics$male[nfp_demographics$Childgender=="Female"] <- 0 # Recode factor variable
nfp_demographics$male[nfp_demographics$Childgender=="Male"] <- 1 


## Mother's marital status
### Two variables in NIS: MARITAL, in early years (2008 codebook), distinguishes 1) widowed/divorced/separated/deceased, 
### 2) never married, and 3) married.  MARITAL2 (2010 codebook) distinguishes only married v. not married.
### We have more detail for NFP, but NFP also provided a binary (nfp_demographics$marital_status) equivalent to MARITAL2.

nfp_demographics$married <- nfp_demographics$marital_status # Rename variable so meaning of 1/0 is more evident
NIS$married[NIS$MARITAL==3] <- 1
NIS$married[NIS$MARITAL==2] <- 0
NIS$married[NIS$MARITAL==1] <- 0
NIS$married[NIS$MARITAL2==1] <- 1
NIS$married[NIS$MARITAL2==2] <- 0

## Mother's education



# Matching variables TBD: WIC/Medicaid recipient status and insurance coverage.
