##################################
##    Data Preparation File     ##
## National Immunization Survey ##
##         Joe Walsh            ##
##         Emily Rowe           ##
##        Adam Fishman          ##
##################################

setwd("/mnt/data/NIS/modified_data/")









#####################################
#####################################
#  			            #
#        Prepare NIS Data           #
#				    #
#####################################
#####################################

## NIS provides R scripts to prepare the data for analysis.  Run each and make a few modifications.
## I'm commenting out the source lines that call NIS-provided code because 
## 1) once they're run they don't need to run again and 2) they take too long to run.


#####################################
## 2008 NIS data
source("/mnt/data/NIS/original_data/nispuf08.r")

#load("NISPUF08.RData")

# 2008 data has INS_4 and INS_5; other years have INS_4_5.  Create INS_4_5 and drop other two.
NISPUF08$INS_4_5 <- 2
NISPUF08$INS_4_5[NISPUF08$INS_4==1 | NISPUF08$INS_5==1] <- 1
NISPUF08 <- NISPUF08[,!(names(NISPUF08) %in% c("INS_4","INS_5"))]

# Drop variables missing in other years
NISPUF08 <- NISPUF08[,!(names(NISPUF08) %in% c("HH_FLU","P_UTDHEP","P_UTDHIB_ROUT_S","P_UTDHIB_SHORT_S","P_UTDPCV","P_UTDPCVB13"))]

# Other years rename MARITAL as MARITAL2.  Make consistent.
names(NISPUF08)[names(NISPUF08)=='MARITAL'] <- 'MARITAL2'

# Only keep potentially useful columns
NISPUF08 <- subset(NISPUF08, 
	       select=(c(sort(names(NISPUF08)[grep("SEQNUM", names(NISPUF08))]),	# NIS respondent identifiers
			"YEAR",								# year of interview
			"STATE",							# state of residence
			#"ESTIAP08",	inconsistently coded from year to year		# state or metropolitan statistical area of residence
			"C5R", 								# relationship of respondent to child (match on mother?)
			"LANGUAGE",							# language interview was conducted in
			"D7",								# permission to contact providers
			"EDUC1",							# mother's education level
			"M_AGEGRP",							# mother's age group
			"MARITAL",							# mother's marital status
			"INCQ298A",							# family income category
			"I_HISP_K",							# Hispanic origin of child
			"INCPORAR",							# income to poverty ratio (eligibility criterion)
			"FRSTBRN",							# whether child is first born
			"AGEGRP",							# child's age group
			sort(names(NISPUF08)[grep("RACE", names(NISPUF08))]),		# child's race
			"SEX",								# child's sex
			sort(names(NISPUF08)[grep("CWIC_", names(NISPUF08))]),		# WIC variables	
			sort(names(NISPUF08)[grep("INS_", names(NISPUF08))]),		# insurance variables
			sort(names(NISPUF08)[grep("BF_", names(NISPUF08))]),		# breastfeeding variables
			sort(names(NISPUF08)[grep("SC_", names(NISPUF08))]),		# household shot card variables
			sort(names(NISPUF08)[grep("HH_", names(NISPUF08))]),		# household-reported variables (not using shot card)
			"SHOTCARD", 							# household uses shot card
			sort(names(NISPUF08)[grep("DDTP", names(NISPUF08))]),		# provider-reported DT-containing shots
			sort(names(NISPUF08)[grep("DHEP", names(NISPUF08))]),		# provider-reported HepA- and HepB-containing shots
			sort(names(NISPUF08)[grep("DHIB_", names(NISPUF08))]),		# provider-reported Hib-containing shots
			sort(names(NISPUF08)[grep("DMMR", names(NISPUF08))]),		# provider-reported measles-containing shots
			sort(names(NISPUF08)[grep("DPCV", names(NISPUF08))]),		# provider-reported pneumococcal-containing shots
			sort(names(NISPUF08)[grep("DPOLIO", names(NISPUF08))]),		# provider-reported polio-containing shots
			sort(names(NISPUF08)[grep("DROT", names(NISPUF08))]),		# provider-reported rotavirus-containing shots
			sort(names(NISPUF08)[grep("DVRC", names(NISPUF08))])		# provider-reported Varicella-containing shots
			)
		       )
		)



#####################################
## 2009 NIS data
source("/mnt/data/NIS/original_data/nispuf09.r")

#load("NISPUF09.RData")

# Drop variables not available in every year
NISPUF09 <- NISPUF09[,!(names(NISPUF09) %in% c("HH_FLU","P_UTDHEP","P_UTDHIB_ROUT_S","P_UTDHIB_SHORT_S","P_UTDPCV",
						"P_UTDPCVB13","P_UTDROT_S"))]

# Only keep potentially useful columns
NISPUF09 <- subset(NISPUF09, 
	       select=(c(sort(names(NISPUF09)[grep("SEQNUM", names(NISPUF09))]),	# NIS respondent identifiers
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
			"I_HISP_K",							# Hispanic origin of child
			"INCPORAR",							# income to poverty ratio (eligibility criterion)
			"FRSTBRN",							# whether child is first born
			"AGEGRP",							# child's age group
			sort(names(NISPUF09)[grep("RACE", names(NISPUF09))]),		# child's race
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
			sort(names(NISPUF09)[grep("DVRC", names(NISPUF09))])		# provider-reported Varicella-containing shots
			)
		       )
		)





#####################################
## 2010 NIS data
source("/mnt/data/NIS/original_data/nispuf10.r")

#load("NISPUF10.RData")

# Drop variables not available in every year
NISPUF10 <- NISPUF10[,!(names(NISPUF10) %in% c("HH_FLU","HH_H1N","P_UTDHEPA2","P_UTDHEP","P_UTDHIB_ROUT_S","P_UTDHIB_SHORT_S",
						"P_UTDPCV","P_UTDPCVB13","P_UTDROT_S"))]


# Only keep potentially useful columns
NISPUF10 <- subset(NISPUF10, 
	       select=(c(sort(names(NISPUF10)[grep("SEQNUM", names(NISPUF10))]),	# NIS respondent identifiers
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
			"I_HISP_K",							# Hispanic origin of child
			"INCPORAR",							# income to poverty ratio (eligibility criterion)
			"FRSTBRN",							# whether child is first born
			"AGEGRP",							# child's age group
			sort(names(NISPUF10)[grep("RACE", names(NISPUF10))]),		# child's race
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
			sort(names(NISPUF10)[grep("DVRC", names(NISPUF10))])		# provider-reported Varicella-containing shots
			)
		       )
		)






#####################################
## 2011 NIS data
source("/mnt/data/NIS/original_data/nispuf11.r")

#load("NISPUF11.RData")

# Drop variables not available in every year
NISPUF11 <- NISPUF11[,!(names(NISPUF11) %in% c("HH_FLU","HH_H1N","P_UTDHEPA2","P_UTDHEP","P_UTDHIB_ROUT_S","P_UTDHIB_SHORT_S",
						"P_UTDPCV","P_UTDPCVB13","P_UTDROT_S","P_UTDHEPA1"))]


# Only keep potentially useful columns
NISPUF11 <- subset(NISPUF11, 
	       select=(c(sort(names(NISPUF11)[grep("SEQNUM", names(NISPUF11))]),	# NIS respondent identifiers
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
			"I_HISP_K",							# Hispanic origin of child
			"INCPORAR",							# income to poverty ratio (eligibility criterion)
			"FRSTBRN",							# whether child is first born
			"AGEGRP",							# child's age group
			sort(names(NISPUF11)[grep("RACE", names(NISPUF11))]),		# child's race
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
			sort(names(NISPUF11)[grep("DVRC", names(NISPUF11))])		# provider-reported Varicella-containing shots
			)
		       )
		)





#####################################
## Combine NIS data and save
NISPUF <- rbind(NISPUF08, NISPUF09, NISPUF10, NISPUF11)
save(NISPUF, file="NISPUF.RData", ascii=TRUE)  # ASCII so it's readable years from now











#####################################
#####################################
#  			            #
#   Determine Whether Up to Date    #
#				    #
#####################################
#####################################

n <- nrow(NISPUF)

# HepB immunizations up to date
HepB6 <- rep(0,n)		# adequate immunizations at 6 months
  HepB6[NISPUF$DHEPB2<31*6] <- 1
HepB12 <- rep(0,n)	# adequate immunizations at 12 months
  HepB12[NISPUF$DHEPB2<31*12] <- 1
HepB18 <- rep(0,n)	# adequate immunizations at 18 months
  HepB18[NISPUF$DHEPB3<31*18] <- 1
HepB24 <- rep(0,n)	# adequate immunizations at 24 months
  HepB24[NISPUF$DHEPB3<31*24] <- 1

# DTaP immunizations up to date
DTaP6 <- rep(0,n)
  DTaP6[NISPUF$DDTP3<31*6] <- 1
DTaP12 <- rep(0,n)
  DTaP12[NISPUF$DDTP3<31*12] <- 1
DTaP18 <- rep(0,n)
  DTaP18[NISPUF$DDTP4<31*18] <- 1
DTaP24 <- rep(0,n)
  DTaP24[NISPUF$DDTP4<31*24] <- 1

# Hib immunizations up to date
Hib6 <- rep(0,n)
  Hib6[NISPUF$DHIB3<31*6] <- 1
Hib12 <- rep(0,n)
  Hib12[NISPUF$DHIB3<31*12] <- 1
Hib18 <- rep(0,n)
  Hib18[NISPUF$DHIB4<31*18] <- 1
Hib24 <- rep(0,n)
  Hib24[NISPUF$DHIB4<31*24] <- 1

# Polio immunizations up to date
Polio6 <- rep(0,n)
  Polio6[NISPUF$DPOLIO2<31*6] <- 1
Polio12 <- rep(0,n)
  Polio12[NISPUF$DPOLIO2<31*12] <- 1
Polio18 <- rep(0,n)
  Polio18[NISPUF$DPOLIO3<31*18] <- 1
Polio24 <- rep(0,n)
  Polio24[NISPUF$DPOLIO3<31*24] <- 1

# PCV immunizations up to date
PCV6 <- rep(0,n)
  PCV6[NISPUF$DPCV3<31*6] <- 1
PCV12 <- rep(0,n)
  PCV12[NISPUF$DPCV3<31*12] <- 1
PCV18 <- rep(0,n)
  PCV18[NISPUF$DPCV4<31*18] <- 1
PCV24 <- rep(0,n)
  PCV24[NISPUF$DPCV4<31*24] <- 1

# MMR immunization up to date
MMR6 <- rep(1,n)
MMR12 <- rep(1,n)
MMR18 <- rep(1,n)
  MMR18[NISPUF$DMMR1<31*18] <- 1
MMR24 <- rep(1,n)
  MMR24[NISPUF$DMMR1<31*24] <- 1

# Varicella immunization up to date
Varicella6 <- rep(1,n)
Varicella12 <- rep(1,n)
Varicella18 <- rep(1,n)
  Varicella18[NISPUF$DVRC1<31*18] <- 1
Varicella24 <- rep(1,n)
  Varicella24[NISPUF$DVRC1<31*24] <- 1

# HepA immunization up to date
HepA6 <- rep(1,n)
HepA12 <- rep(1,n)
HepA18 <- rep(0,n)
  HepA18[NISPUF$DHEPA1<31*18] <- 1
HepA24 <- rep(0,n)
  HepA24[NISPUF$DHEPA1<31*24] <- 1

# Rotavirus immunization up to date
Rotavirus6 <- rep(0,n)
  Rotavirus6[NISPUF$DROT3<31*6] <- 1
Rotavirus12 <- rep(0,n)
  Rotavirus12[NISPUF$DROT3<31*12] <- 1
Rotavirus18 <- rep(0,n)
  Rotavirus18[NISPUF$DROT3<31*18] <- 1
Rotavirus24 <- rep(0,n)
  Rotavirus24[NISPUF$DROT3<31*24] <- 1

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


# Overall immunizations up to date
Immunizations_UptoDate_6 <- rep(0,n)
  Immunizations_UptoDate_6[HepB6==1 & DTaP6==1 & Hib6==1 & Polio6==1 & PCV6==1 & MMR6==1 & Varicella6==1 & HepA6==1 & Rotavirus6==1] <- 1








#####################################
#####################################
#    		                    #
#         Variable Recodes          #
#				    #
#####################################
#####################################


## Eventually we'll merge all four years of NIS data.  For now, just working with 2008 data.
NIS <- NISPUF

# Load NFP data for recoding and preparation
setwd("/mnt/data/csv_data")
nfp_demographics <- read.csv("nfp_demographics_expanded.csv")


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
nfp_demographics$nfp_state_recode[nfp_centers$State == 'AL'] = 1
nfp_demographics$nfp_state_recode[nfp_centers$State == 'AK'] = 2
nfp_demographics$nfp_state_recode[nfp_centers$State == 'AS'] = 60
nfp_demographics$nfp_state_recode[nfp_centers$State == 'AZ'] = 4
nfp_demographics$nfp_state_recode[nfp_centers$State == 'AR'] = 5
nfp_demographics$nfp_state_recode[nfp_centers$State == 'CA'] = 6
nfp_demographics$nfp_state_recode[nfp_centers$State == 'CO'] = 8
nfp_demographics$nfp_state_recode[nfp_centers$State == 'CT'] = 9
nfp_demographics$nfp_state_recode[nfp_centers$State == 'DE'] = 10
nfp_demographics$nfp_state_recode[nfp_centers$State == 'DC'] = 11
nfp_demographics$nfp_state_recode[nfp_centers$State == 'FL'] = 12
nfp_demographics$nfp_state_recode[nfp_centers$State == 'FM'] = 64
nfp_demographics$nfp_state_recode[nfp_centers$State == 'GA'] = 13
nfp_demographics$nfp_state_recode[nfp_centers$State == 'GU'] = 66
nfp_demographics$nfp_state_recode[nfp_centers$State == 'HI'] = 15
nfp_demographics$nfp_state_recode[nfp_centers$State == 'ID'] = 16
nfp_demographics$nfp_state_recode[nfp_centers$State == 'IL'] = 17
nfp_demographics$nfp_state_recode[nfp_centers$State == 'IN'] = 18
nfp_demographics$nfp_state_recode[nfp_centers$State == 'IA'] = 19
nfp_demographics$nfp_state_recode[nfp_centers$State == 'KS'] = 20
nfp_demographics$nfp_state_recode[nfp_centers$State == 'KY'] = 21
nfp_demographics$nfp_state_recode[nfp_centers$State == 'LA'] = 22
nfp_demographics$nfp_state_recode[nfp_centers$State == 'ME'] = 23
nfp_demographics$nfp_state_recode[nfp_centers$State == 'MH'] = 68
nfp_demographics$nfp_state_recode[nfp_centers$State == 'MD'] = 24
nfp_demographics$nfp_state_recode[nfp_centers$State == 'MA'] = 25
nfp_demographics$nfp_state_recode[nfp_centers$State == 'MI'] = 26
nfp_demographics$nfp_state_recode[nfp_centers$State == 'MN'] = 27
nfp_demographics$nfp_state_recode[nfp_centers$State == 'MS'] = 28
nfp_demographics$nfp_state_recode[nfp_centers$State == 'MO'] = 29
nfp_demographics$nfp_state_recode[nfp_centers$State == 'MT'] = 30
nfp_demographics$nfp_state_recode[nfp_centers$State == 'NE'] = 31
nfp_demographics$nfp_state_recode[nfp_centers$State == 'NV'] = 32
nfp_demographics$nfp_state_recode[nfp_centers$State == 'NH'] = 33
nfp_demographics$nfp_state_recode[nfp_centers$State == 'NJ'] = 34
nfp_demographics$nfp_state_recode[nfp_centers$State == 'NM'] = 35
nfp_demographics$nfp_state_recode[nfp_centers$State == 'NY'] = 36
nfp_demographics$nfp_state_recode[nfp_centers$State == 'NC'] = 37
nfp_demographics$nfp_state_recode[nfp_centers$State == 'ND'] = 38
nfp_demographics$nfp_state_recode[nfp_centers$State == 'MP'] = 69
nfp_demographics$nfp_state_recode[nfp_centers$State == 'OH'] = 39
nfp_demographics$nfp_state_recode[nfp_centers$State == 'OK'] = 40
nfp_demographics$nfp_state_recode[nfp_centers$State == 'OR'] = 41
nfp_demographics$nfp_state_recode[nfp_centers$State == 'PW'] = 70
nfp_demographics$nfp_state_recode[nfp_centers$State == 'PA'] = 42
nfp_demographics$nfp_state_recode[nfp_centers$State == 'PR'] = 72
nfp_demographics$nfp_state_recode[nfp_centers$State == 'RI'] = 44
nfp_demographics$nfp_state_recode[nfp_centers$State == 'SC'] = 45
nfp_demographics$nfp_state_recode[nfp_centers$State == 'SD'] = 46
nfp_demographics$nfp_state_recode[nfp_centers$State == 'TN'] = 47
nfp_demographics$nfp_state_recode[nfp_centers$State == 'TX'] = 48
nfp_demographics$nfp_state_recode[nfp_centers$State == 'UM'] = 74
nfp_demographics$nfp_state_recode[nfp_centers$State == 'UT'] = 49
nfp_demographics$nfp_state_recode[nfp_centers$State == 'VT'] = 50
nfp_demographics$nfp_state_recode[nfp_centers$State == 'VA'] = 51
nfp_demographics$nfp_state_recode[nfp_centers$State == 'VI'] = 78
nfp_demographics$nfp_state_recode[nfp_centers$State == 'WA'] = 53
nfp_demographics$nfp_state_recode[nfp_centers$State == 'WV'] = 54
nfp_demographics$nfp_state_recode[nfp_centers$State == 'WI'] = 55
nfp_demographics$nfp_state_recode[nfp_centers$State == 'WY'] = 56


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
###NFP tracks HS diploma, GED, or neither (HSGED).
###NIS has <12 years, 12 years, or 12+ years.  Original questionnaire wording buckets HS degrees and GEDs together.

nfp_demographics$HSgrad[nfp_demographics$HSGED==1] <- 1
nfp_demographics$HSgrad[nfp_demographics$HSGED==2] <- 1
nfp_demographics$HSgrad[nfp_demographics$HSGED==3] <- 0
NIS$HSgrad[NIS$EDUC1==1] <- 0
NIS$HSgrad[which(is.element(NIS$EDUC1,c(2,3,4)))] <- 1

# Matching variables TBD: WIC/Medicaid recipient status and insurance coverage.



save(NIS, file="NIS_for_Analysis.RData", ascii=TRUE)  # ASCII so it's readable years from now

