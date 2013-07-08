# Importing data
setwd("/mnt/data")
nsch <- read.csv("DRC_2011_2012_NSCH.csv")
setwd("/mnt/data/csv_data")
nfpdemo <- read.csv("nfp_demographics_expanded.csv")
nfpcenter <- read.csv("agency.csv")

# Recoding NSCH variables to match NFP
nsch$NSCH_ID <- nsch$IDNUMR
nsch$male[nsch$SEX==2] <- 0 # Male binary = 0 if child is female; null if DK/refused
nsch$male[nsch$SEX==1] <- 1 
nsch$premature[nsch$K2Q05==0] <- 0 # Indicator for prematurity; null if DK/refused or missing
nsch$premature[nsch$K2Q05==1] <- 1
nsch$lbw[nsch$ind1_8_11==1] <- 1 # Indicator for low birthweight; null if DK/refused
nsch$lbw[nsch$ind1_8_11==2] <- 0


# Recoding NFP variables where needed
nfpdemo$NFP_ID <- nfpdemo$CL_EN_GEN_ID
nfpdemo$male[nfpdemo$Childgender=="Female"] <- 0 # Recode factor variable
nfpdemo$male[nfpdemo$Childgender=="Male"] <- 1 

# Race recodes: note that NSCH has only child's race and NFP has only mother's race.
# Must assume for matching purposes that they are the same.
nsch$race <- nsch$RACER # Need codebook
nsch$ethnicity < - nsch$HISPANIC # Need codebook
nfpdemo$race <- nfpdemo$Maternal_Race_Raw # Needs clean up
nfpdemo$ethnicity <- nfpdemo$Maternal_Ethinicty # Needs clean up


# Remove extra NSCH columns and obs for families with no children < age 2.
NSCH_Columns <- subset(nsch, select = c(NSCH_ID, male, premature, lbw, race, ethnicity)
NSCH_Final <- subset(nsch) # Subset here by child's age

# Remove extra NFP columns.
NFP_Demo_Set <- subset(nfpdemo, select = c(NFP_ID, male, premature, lbw, race, ethnicity)
NFP_Location <- subset(nfpcenter)
NFP_Final <- merge(NFP_Demo_Set, NFP_Locaton) # Merge on location information

# Combine final datasets to create analysis dataset.