# Importing data
setwd("/mnt/data/nfp_data/csv_data")
nfp <- read.csv("Full_NFP_Data_Child_Development_Outcomes.csv")
setwd("/mnt/data/NSCH/data")
nsch <- read.csv("DRC_2011_2012_NSCH.csv")

# Recoding sex, prematurity, low birthweight, education, marital status, language variables from NSCH to match NFP
nsch$ID <- factor(nsch$IDNUMR)
nsch$male[nsch$SEX==2] <- 0 # Male binary = 0 if child is female; null if DK/refused
nsch$male[nsch$SEX==1] <- 1 
nsch$premature[nsch$K2Q05==0] <- 0 # Indicator for prematurity; null if DK/refused or missing
nsch$premature[nsch$K2Q05==1] <- 1
nsch$lbw[nsch$K2Q04R<=88] <- 1 # Indicator for low birthweight; null if DK/refused
nsch$lbw[89<=nsch$K2Q04R] <- 0
nsch$marital_status[!is.na(nsch$FAM_MAR_COHAB)] <- 0
nsch$marital_status[which(is.element(nsch$FAM_MAR_COHAB,c(1,3,5)] <- 1 # Not quite marital status - mother is married or child lives with married step family (could be married father)
nsch$english[nsch$PLANGUAGE==1] <- 1 # Indicator for English speaking household
nsch$english[nsch$PLANGUAGE==2] <- 0

nsch$highschool[nsch$EDUC_MOMR >= 2] <- 1 # Indicator for whether mother graduated from high school
nsch$highschool[nsch$EDUC_MOMR <= 1] <- 0
nsch$highschool[nsch$EDUC_MOMR>=6] <- NA # Get rid of DK, etc values
nsch$highered[nsch$EDUC_MOMR == 3] <- 1
nsch$highered[nsch$EDUC_MOMR < 3] <- 0



# Recoding age from NSCH to match NFP
nsch$MomsAge <- nsch$K9Q16R 
nsch$MomsAge[which(is.element(nsch$MomsAge, c(996,997)))] <- NA # Make NA DK/refused values
nsch$MomsAgeBirth <- nsch$MomsAge - nsch$AGEYR_CHILD # Mother's age at birth = mom's age at time of survey - child's age at time of survey
# Note some weird results here - 20 year old mothers with 17 year old children?
# Shouldn't be an issue for our analysis since we are only working with infants/toddlers
# Highlight some examples for question: subset(nsch, nsch$MomsAgeBirth<=15, select = c(NSCH_ID, K9Q16R, MomsAge, AGEYR_CHILD, MomsAgeBirth))

# Recoding NSCH state to meaningful values
## Recode NISPUF$STATE to meaningful values
nsch$State[nsch$STATE==1] <- "AL"
nsch$State[nsch$STATE==2] <- "AK"
nsch$State[nsch$STATE==3] <- "AZ"
nsch$State[nsch$STATE==4] <- "AR"
nsch$State[nsch$STATE==5] <- "CA"
nsch$State[nsch$STATE==6] <- "CO"
nsch$State[nsch$STATE==7] <- "CT"
nsch$State[nsch$STATE==8] <- "DE"
nsch$State[nsch$STATE==9] <- "DC"
nsch$State[nsch$STATE==10] <- "FL"
nsch$State[nsch$STATE==11] <- "GA"
nsch$State[nsch$STATE==12] <- "HI"
nsch$State[nsch$STATE==13] <- "ID"
nsch$State[nsch$STATE==14] <- "IL"
nsch$State[nsch$STATE==15] <- "IN"
nsch$State[nsch$STATE==16] <- "IA"
nsch$State[nsch$STATE==17] <- "KS"
nsch$State[nsch$STATE==18] <- "KY"
nsch$State[nsch$STATE==19] <- "LA"
nsch$State[nsch$STATE==20] <- "ME"
nsch$State[nsch$STATE==21] <- "MD"
nsch$State[nsch$STATE==22] <- "MA"
nsch$State[nsch$STATE==23] <- "MI"
nsch$State[nsch$STATE==24] <- "MN"
nsch$State[nsch$STATE==25] <- "MS"
nsch$State[nsch$STATE==26] <- "MO"
nsch$State[nsch$STATE==27] <- "MT"
nsch$State[nsch$STATE==28] <- "NE"
nsch$State[nsch$STATE==29] <- "NV"
nsch$State[nsch$STATE==30] <- "NH"
nsch$State[nsch$STATE==31] <- "NJ"
nsch$State[nsch$STATE==32] <- "NM"
nsch$State[nsch$STATE==33] <- "NY"
nsch$State[nsch$STATE==34] <- "NC"
nsch$State[nsch$STATE==35] <- "ND"
nsch$State[nsch$STATE==36] <- "OH"
nsch$State[nsch$STATE==37] <- "OK"
nsch$State[nsch$STATE==38] <- "OR"
nsch$State[nsch$STATE==39] <- "PA"
nsch$State[nsch$STATE==40] <- "RI"
nsch$State[nsch$STATE==41] <- "SC"
nsch$State[nsch$STATE==42] <- "SD"
nsch$State[nsch$STATE==43] <- "TN"
nsch$State[nsch$STATE==44] <- "TX"
nsch$State[nsch$STATE==45] <- "UT"
nsch$State[nsch$STATE==46] <- "VT"
nsch$State[nsch$STATE==47] <- "VA"
nsch$State[nsch$STATE==48] <- "WA"
nsch$State[nsch$STATE==49] <- "WV"
nsch$State[nsch$STATE==50] <- "WI"
nsch$State[nsch$STATE==51] <- "WY"
nsch$State <- factor(nsch$State)

# Recoding ID, higher ed, sex, language from NFP
nfp$ID <- factor(nfp$CL_EN_GEN_ID)
nfp$highered <- 1 # Binary 1/0 for any post-HS education (original variable specifies kind of degree/schooling)
nfp$highered[nfp$Client_Higher_Educ_1=="No"] <- 0
nfp$highered[nfp$Client_Higher_Educ_1==""] <- NA
nfp$male[nfp$Childgender=="Female"] <- 0 # Recode factor variable
nfp$male[nfp$Childgender=="Male"] <- 1 
nfp$english[nfp$Primary_language==1] <- 1
nfp$english[which(is.element(nfp$Primary_language, c(2,3)))] <- 0

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
nsch$RE <- factor(nsch$RE)

nfp$RE <- as.character(nfp$MomsRE) # Renaming variable
nfp$RE[nfp$RE=="Hispanic or Latina"] <- "Hispanic" # Shortening description
nfp$RE[nfp$RE=="Declined or msg"] <- NA 
nfp$RE <- factor(nfp$RE) # Return to factor format with adjusted levels


# Dependent variables!  Need a common set of outcomes.
nsch$breastfed <- nsch$K6Q40 # Indicator variable for whether the child has ever been breastfed
nsch$breastfed[which(is.element(nsch$breastfed, c(6, 7)))] <- NA

nfp$breastfed[nfp$ever_breastfed=="Yes"] <- 1
nfp$breastfed[nfp$ever_breastfed=="No"] <- 0

nsch$days_breast <- nsch$K6Q41R
nsch$days_breast[nsch$K6Q41R >= 9995] <- NA # Drop DK/other codes
nsch$week_end_breast <- (nsch$days_breast/7)
# Although NFP collects data for whether child is still breastfed at 6, 12, 18, and 24 months,
#  the question "How old was your baby when s/he stopped getting breast milk?" most closely parallels
#  NSCH's "How old was he/she when he/she completely stopped breastfeeding or being fed breast milk?"
# Note: some inconsistency in respondents' answers between the interval questions and the final estimate.

nsch$week_end_breast[nsch$week_end_breast>104] <- NA
# Omit NSCH responses for which we have no comparable from NFP

# Remove extra NSCH columns and ineligible observations including:
	## Children > age 4
	## Children who are not the oldest (note AGEPOS 1 = only child, 2 = oldest)
	## Children from HH making more than 200% of FPL WIC/NFP criteria is generally 100-185% FPL)
	## Children who do not live with their biological mother (however, keeping children who live in a two-parent step HH - unclear whether live with mother or father)
NSCH_Final <- subset(nsch, nsch$POVLEVEL_I <= 2 & nsch$AGEYR_CHILD <= 4 & nsch$AGEPOS<=2 & which(!is.element(FAM_MAR_COHAB, c(7,8,9))), 
	select = c(ID, male, premature, lbw, highschool, highered, marital_status, MomsAgeBirth, 
	State, RE, english, breastfed, week_end_breast))
	
# Remove extra NFP columns.
NFP_Final <- subset(nfp, select = c(ID, male, premature, lbw, highschool, highered, 
	marital_status, MomsAgeBirth, State, RE, english, breastfed, week_end_breast))

# Add treatment indicator
NSCH_Final$treatment <- 0
NFP_Final$treatment <- 1

# Combine final datasets to create analysis dataset.
breastfeeding <- rbind(NSCH_Final, NFP_Final)
save(breastfeeding, file = "Breastfeeding.RData")


# Creating one dataset without dropping any NSCH obs and keeping weights, to get general population statistics.
NSCH_Full <- subset(nsch, select = c(ID, male, premature, lbw, highschool, highered, marital_status, 
			MomsAgeBirth, State, RE, english, breastfed, week_end_breast, NSCHWT))
save(NSCH_Full, file = "FullNSCH.RData")
