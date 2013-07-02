# Importing data
setwd(/mnt/data1/NFP)
nsch <- read.csv("DRC_2011_2012_NSCH.csv")

# Eliminate obs where child is over age 2


# Recoding variables
nsch$ID <- nsch$IDNUMR
nsch$male[nsch$SEX==2] <- 0 # Male binary = 0 if child is female
nsch$male[nsch$SEX==1] <- 1 # nsch$male is null if DK/refused
nsch$premature[nsch$K2Q05==0] <- 0
nsch$premature[nsch$K2Q05==1] <- 1 #Indicator for prematurity; null if DK/refused or missing
nsch$lbw[nsch$ind1_8_11==1] <- 1
nsch$lbw[nsch$ind1_8_11==2] <- 0 # Indicator for low birthweight; null if DK/refused


# Need to develop recodes for race.  RACER and HISPANIC capture NSCH child's race and ethnicity.
# Will need to match to mother's race in NFP dataset.  Recode pending final knowledge of data structure from NFP.
