# Importing data
setwd("/mnt/data/nfp_data/csv_data")
nfpdemo <- read.csv("nfp_demographics_expanded.csv")
setwd("/mnt/data/NSCH/data")
nsch <- read.csv("DRC_2011_2012_NSCH.csv")

# Recoding sex, prematurity, low birthweight, education, marital status variables from NSCH to match NFP
nsch$NSCH_ID <- nsch$IDNUMR
nsch$male[nsch$SEX==2] <- 0 # Male binary = 0 if child is female; null if DK/refused
nsch$male[nsch$SEX==1] <- 1 
nsch$premature[nsch$K2Q05==0] <- 0 # Indicator for prematurity; null if DK/refused or missing
nsch$premature[nsch$K2Q05==1] <- 1
nsch$lbw[nsch$ind1_8_11==1] <- 1 # Indicator for low birthweight; null if DK/refused
nsch$lbw[nsch$ind1_8_11==2] <- 0
nsch$highschool[nsch$EDUC_MOMR >= 3] <- 1 # Indicator for whether mother graduated from high school
nsch$highschool[nsch$EDUC_MOMR <= 2] <- 0
nsch$highered[nsch$EDUC_MOMR >= 5] <- 1
nsch$highered[nsch$EDUC_MOMR < 5] <- 0
# nsch$marital_status (use FAM_MAR_COHAB)

# Recoding age from NSCH to match NFP
nsch$MomsAge <- nsch$K9Q16R 
nsch$MomsAge[which(is.element(nsch$MomsAge, c(996,997)))] <- NA # Make NA DK/refused values
nsch$MomsAgeBirth <- nsch$MomsAge - nsch$AGEYR_CHILD # Mother's age at birth = mom's age at time of survey - child's age at time of survey
# Note some weird results here - 20 year old mothers with 17 year old children?
# Shouldn't be an issue for our analysis since we are only working with infants/toddlers
# Highlight some examples for question: subset(nsch, nsch$MomsAgeBirth<=15, select = c(NSCH_ID, K9Q16R, MomsAge, AGEYR_CHILD, MomsAgeBirth))

# Recoding ID, sex from NFP
nfpdemo$NFP_ID <- nfpdemo$CL_EN_GEN_ID
# nfpdemo$highered <- nfpdemo$client_higher_educ_1 # Check this - may not be working
nfpdemo$male[nfpdemo$Childgender=="Female"] <- 0 # Recode factor variable
nfpdemo$male[nfpdemo$Childgender=="Male"] <- 1 


# Race recodes: note that NSCH has only child's race and NFP has only mother's race.
# Must assume for matching purposes that they are the same.
# Using convention of NFP's MomsRE variable - factor with five levels: 
# 1) BlackNH, 2) WhiteNH, 3) Hispanic or Latina, 4) Other, 5) Declined or msg

# RACER/HISPANIC recoded from NSCH per directions in SPSS Codebook p.147
nsch$RE <- NA
nsch$RE[nsch$HISPANIC==1] <- "Hispanic"
nsch$RE[nsch$HISPANIC==0 & nsch$RACER==1] <- "WhiteNH"
nsch$RE[nsch$HISPANIC==0 & nsch$RACER==2] <- "BlackNH"
nsch$RE[nsch$HISPANIC==0 & nsch$RACER==3] <- "Other"

nfpdemo$RE <- as.character(nfpdemo$MomsRE) # Renaming variable
nfpdemo$RE[nfpdemo$RE=="Hispanic or Latina"] <- "Hispanic" # Shortening description
nfpdemo$RE[nfpdemo$RE=="Declined or msg"] <- NA 
nfpdemo$RE <- factor(nfpdemo$RE) # Return to factor format with adjusted levels

# Remove extra NSCH columns, obs for families with no children < age 2, families making more than 200% of FPL
# (WIC/NFP criteria is generally 100-185% FPL, so these mothers are not valid matches)
NSCH_Final <- subset(nsch, nsch$POVLEVEL_I <= 2, select = c(NSCH_ID, male, premature, lbw, RE))
# Subset here by child's age

# Remove extra NFP columns.
NFP_Final <- subset(nfpdemo, select = c(NFP_ID, male, premature, lbw, RE))

# Combine final datasets to create analysis dataset.