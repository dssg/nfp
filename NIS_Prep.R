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
#source("/mnt/data/NIS/original_data/nispuf08.r")

load("NISPUF08.RData")

# 2008 data has INS_4 and INS_5; other years have INS_4_5.  Create INS_4_5 and drop other two.
NISPUF08$INS_4_5 <- 2
NISPUF08$INS_4_5[NISPUF08$INS_4==1 | NISPUF08$INS_5==1] <- 1
NISPUF08 <- NISPUF08[,!(names(NISPUF08) %in% c("INS_4","INS_5"))]

# Drop variables missing in other years
NISPUF08 <- NISPUF08[,!(names(NISPUF08) %in% c("HH_FLU","P_UTDHEP","P_UTDHIB_ROUT_S","P_UTDHIB_SHORT_S","P_UTDPCV","P_UTDPCVB13"))]

# Other years rename MARITAL as MARITAL2.  Make consistent.  
names(NISPUF08)[names(NISPUF08)=='MARITAL'] <- 'MARITAL2'

# Recode MARITAL2 for consistency.
NISPUF08$MARITAL2[NISPUF08$MARITAL2==1] <- 2
NISPUF08$MARITAL2[NISPUF08$MARITAL2==3] <- 1


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
			"MARITAL2",							# mother's marital status
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
#source("/mnt/data/NIS/original_data/nispuf09.r")

load("NISPUF09.RData")

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
#source("/mnt/data/NIS/original_data/nispuf10.r")

load("NISPUF10.RData")

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
#source("/mnt/data/NIS/original_data/nispuf11.r")

load("NISPUF11.RData")

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
## Combine NIS data 
NISPUF <- rbind(NISPUF08, NISPUF09, NISPUF10, NISPUF11)












#####################################
#####################################
#  			            #
#   Determine Whether Child Is      #
#   Up to Date on Vaccinations      #
#     as Reported by Provider       #
#				    #
#####################################
#####################################


# HepB immunizations up to date
NISPUF$HepB6 <- 0		# adequate immunizations at 6 months
  NISPUF$HepB6[NISPUF$DHEPB2<31*6] <- 1
NISPUF$HepB12 <- 0	# adequate immunizations at 12 months
  NISPUF$HepB12[NISPUF$DHEPB2<31*12] <- 1
NISPUF$HepB18 <- 0	# adequate immunizations at 18 months
  NISPUF$HepB18[NISPUF$DHEPB3<31*18] <- 1
NISPUF$HepB24 <- 0	# adequate immunizations at 24 months
  NISPUF$HepB24[NISPUF$DHEPB3<31*24] <- 1

# DTaP immunizations up to date
NISPUF$DTaP6 <- 0
  NISPUF$DTaP6[NISPUF$DDTP3<31*6] <- 1
NISPUF$DTaP12 <- 0
  NISPUF$DTaP12[NISPUF$DDTP3<31*12] <- 1
NISPUF$DTaP18 <- 0
  NISPUF$DTaP18[NISPUF$DDTP4<31*18] <- 1
NISPUF$DTaP24 <- 0
  NISPUF$DTaP24[NISPUF$DDTP4<31*24] <- 1

# Hib immunizations up to date
NISPUF$Hib6 <- 0
  NISPUF$Hib6[NISPUF$DHIB3<31*6] <- 1
NISPUF$Hib12 <- 0
  NISPUF$Hib12[NISPUF$DHIB3<31*12] <- 1
NISPUF$Hib18 <- 0
  NISPUF$Hib18[NISPUF$DHIB4<31*18] <- 1
NISPUF$Hib24 <- 0
  NISPUF$Hib24[NISPUF$DHIB4<31*24] <- 1

# Polio immunizations up to date
NISPUF$Polio6 <- 0
  NISPUF$Polio6[NISPUF$DPOLIO2<31*6] <- 1
NISPUF$Polio12 <- 0
  NISPUF$Polio12[NISPUF$DPOLIO2<31*12] <- 1
NISPUF$Polio18 <- 0
  NISPUF$Polio18[NISPUF$DPOLIO3<31*18] <- 1
NISPUF$Polio24 <- 0
  NISPUF$Polio24[NISPUF$DPOLIO3<31*24] <- 1

# PCV immunizations up to date
NISPUF$PCV6 <- 0
  NISPUF$PCV6[NISPUF$DPCV3<31*6] <- 1
NISPUF$PCV12 <- 0
  NISPUF$PCV12[NISPUF$DPCV3<31*12] <- 1
NISPUF$PCV18 <- 0
  NISPUF$PCV18[NISPUF$DPCV4<31*18] <- 1
NISPUF$PCV24 <- 0
  NISPUF$PCV24[NISPUF$DPCV4<31*24] <- 1

# MMR immunization up to date
NISPUF$MMR6 <- 1
NISPUF$MMR12 <- 1
NISPUF$MMR18 <- 1
  NISPUF$MMR18[NISPUF$DMMR1<31*18] <- 1
NISPUF$MMR24 <- 1
  NISPUF$MMR24[NISPUF$DMMR1<31*24] <- 1

# Varicella immunization up to date
NISPUF$Varicella6 <- 1
NISPUF$Varicella12 <- 1
NISPUF$Varicella18 <- 1
  NISPUF$Varicella18[NISPUF$DVRC1<31*18] <- 1
NISPUF$Varicella24 <- 1
  NISPUF$Varicella24[NISPUF$DVRC1<31*24] <- 1

# HepA immunization up to date
NISPUF$HepA6 <- 1
NISPUF$HepA12 <- 1
NISPUF$HepA18 <- 0
  NISPUF$HepA18[NISPUF$DHEPA1<31*18] <- 1
NISPUF$HepA24 <- 0
  NISPUF$HepA24[NISPUF$DHEPA1<31*24] <- 1

# Rotavirus immunization up to date
NISPUF$Rotavirus6 <- 0
  NISPUF$Rotavirus6[NISPUF$DROT3<31*6] <- 1
NISPUF$Rotavirus12 <- 0
  NISPUF$Rotavirus12[NISPUF$DROT3<31*12] <- 1
NISPUF$Rotavirus18 <- 0
  NISPUF$Rotavirus18[NISPUF$DROT3<31*18] <- 1
NISPUF$Rotavirus24 <- 0
  NISPUF$Rotavirus24[NISPUF$DROT3<31*24] <- 1


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
#  			            #
#   Determine Whether Child Is      #
#   Up to Date on Vaccinations      #
#    as Reported by Household       #
#   (from memory, no shotcard)      #
#				    #
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
#  			            #
#   Determine Whether Child Is      #
#   Up to Date on Vaccinations      #
#         as Reported by            #
#       Household Shotcard          #
#				    #
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
save(NISPUF, file="NISPUF.RData", ascii=TRUE)  # ASCII so it's readable years from now





#####################################
#####################################
#    		                    #
#         Variable Recodes          #
#				    #
#####################################
#####################################


xxx


############################################
# Load NFP data for recoding and preparation
setwd("/mnt/data/csv_data")
nfp_demographics <- read.csv("nfp_demographics_expanded.csv")
nfp_centers <- read.csv("agency.csv")

##Household income - note that DK/Refused households are NA

### Although the lowest bins don't match exactly (6000 is the upper limit in NFP and 7500 in NIS),
### assume that both skew heavily toward 0 and treat as comparable
NISPUF$income_recode[NISPUF$INCQ298A==3] <- 1
NISPUF$income_recode[which(is.element(NISPUF$INCQ298A, c(4,5,6)))] = 2 # Binning 7500-20000/year together in both sets
NISPUF$income_recode[which(is.element(NISPUF$INCQ298A, c(7,8)))] = 4 # Binning 20k-30k as in nfp
NISPUF$income_recode[which(is.element(NISPUF$INCQ298A, c(9,10)))] = 5 # Binning 30k-40k in the same was as nfp
NISPUF$income_recode[which(is.element(NISPUF$INCQ298A, c(11,12,13,14)))] = 6

### In NFP, must combine income brackets 2 and 3 ($7500-20K) to match NIS buckets.
nfp_demographics$income_recode = nfp_demographics$INCOME
nfp_demographics$income_recode[nfp_demographics$income_recode == 3] <- 2
### Note that in the NFP dataset an income code of 7 indicates a mother living off her parents.



## Location - recoding NFP state data into FIPS codes (to match the NIS dataset)
nfp_centers$nfp_state_recode = rep(NA,dim(nfp_demographics)[1])
nfp_centers$nfp_state_recode[nfp_centers$State == 'AL'] = 1
nfp_centers$nfp_state_recode[nfp_centers$State == 'AK'] = 2
nfp_centers$nfp_state_recode[nfp_centers$State == 'AS'] = 60
nfp_centers$nfp_state_recode[nfp_centers$State == 'AZ'] = 4
nfp_centers$nfp_state_recode[nfp_centers$State == 'AR'] = 5
nfp_centers$nfp_state_recode[nfp_centers$State == 'CA'] = 6
nfp_centers$nfp_state_recode[nfp_centers$State == 'CO'] = 8
nfp_centers$nfp_state_recode[nfp_centers$State == 'CT'] = 9
nfp_centers$nfp_state_recode[nfp_centers$State == 'DE'] = 10
nfp_centers$nfp_state_recode[nfp_centers$State == 'DC'] = 11
nfp_centers$nfp_state_recode[nfp_centers$State == 'FL'] = 12
nfp_centers$nfp_state_recode[nfp_centers$State == 'FM'] = 64
nfp_centers$nfp_state_recode[nfp_centers$State == 'GA'] = 13
nfp_centers$nfp_state_recode[nfp_centers$State == 'GU'] = 66
nfp_centers$nfp_state_recode[nfp_centers$State == 'HI'] = 15
nfp_centers$nfp_state_recode[nfp_centers$State == 'ID'] = 16
nfp_centers$nfp_state_recode[nfp_centers$State == 'IL'] = 17
nfp_centers$nfp_state_recode[nfp_centers$State == 'IN'] = 18
nfp_centers$nfp_state_recode[nfp_centers$State == 'IA'] = 19
nfp_centers$nfp_state_recode[nfp_centers$State == 'KS'] = 20
nfp_centers$nfp_state_recode[nfp_centers$State == 'KY'] = 21
nfp_centers$nfp_state_recode[nfp_centers$State == 'LA'] = 22
nfp_centers$nfp_state_recode[nfp_centers$State == 'ME'] = 23
nfp_centers$nfp_state_recode[nfp_centers$State == 'MH'] = 68
nfp_centers$nfp_state_recode[nfp_centers$State == 'MD'] = 24
nfp_centers$nfp_state_recode[nfp_centers$State == 'MA'] = 25
nfp_centers$nfp_state_recode[nfp_centers$State == 'MI'] = 26
nfp_centers$nfp_state_recode[nfp_centers$State == 'MN'] = 27
nfp_centers$nfp_state_recode[nfp_centers$State == 'MS'] = 28
nfp_centers$nfp_state_recode[nfp_centers$State == 'MO'] = 29
nfp_centers$nfp_state_recode[nfp_centers$State == 'MT'] = 30
nfp_centers$nfp_state_recode[nfp_centers$State == 'NE'] = 31
nfp_centers$nfp_state_recode[nfp_centers$State == 'NV'] = 32
nfp_centers$nfp_state_recode[nfp_centers$State == 'NH'] = 33
nfp_centers$nfp_state_recode[nfp_centers$State == 'NJ'] = 34
nfp_centers$nfp_state_recode[nfp_centers$State == 'NM'] = 35
nfp_centers$nfp_state_recode[nfp_centers$State == 'NY'] = 36
nfp_centers$nfp_state_recode[nfp_centers$State == 'NC'] = 37
nfp_centers$nfp_state_recode[nfp_centers$State == 'ND'] = 38
nfp_centers$nfp_state_recode[nfp_centers$State == 'MP'] = 69
nfp_centers$nfp_state_recode[nfp_centers$State == 'OH'] = 39
nfp_centers$nfp_state_recode[nfp_centers$State == 'OK'] = 40
nfp_centers$nfp_state_recode[nfp_centers$State == 'OR'] = 41
nfp_centers$nfp_state_recode[nfp_centers$State == 'PW'] = 70
nfp_centers$nfp_state_recode[nfp_centers$State == 'PA'] = 42
nfp_centers$nfp_state_recode[nfp_centers$State == 'PR'] = 72
nfp_centers$nfp_state_recode[nfp_centers$State == 'RI'] = 44
nfp_centers$nfp_state_recode[nfp_centers$State == 'SC'] = 45
nfp_centers$nfp_state_recode[nfp_centers$State == 'SD'] = 46
nfp_centers$nfp_state_recode[nfp_centers$State == 'TN'] = 47
nfp_centers$nfp_state_recode[nfp_centers$State == 'TX'] = 48
nfp_centers$nfp_state_recode[nfp_centers$State == 'UM'] = 74
nfp_centers$nfp_state_recode[nfp_centers$State == 'UT'] = 49
nfp_centers$nfp_state_recode[nfp_centers$State == 'VT'] = 50
nfp_centers$nfp_state_recode[nfp_centers$State == 'VA'] = 51
nfp_centers$nfp_state_recode[nfp_centers$State == 'VI'] = 78
nfp_centers$nfp_state_recode[nfp_centers$State == 'WA'] = 53
nfp_centers$nfp_state_recode[nfp_centers$State == 'WV'] = 54
nfp_centers$nfp_state_recode[nfp_centers$State == 'WI'] = 55
nfp_centers$nfp_state_recode[nfp_centers$State == 'WY'] = 56



nfp_demographics$state <- factor(nfp_state_recode)
NISPUF$state <- factor(as.numeric(NISPUF$STATE))


## Language - note that we are comparing primary language (NFP) to language in which interview was conducted (NIS)
NISPUF$Primary_language[NISPUF$LANGUAGE==1] <- "English"
NISPUF$Primary_language[NISPUF$LANGUAGE==2] <- "Spanish"
NISPUF$Primary_language[NISPUF$LANGUAGE==3] <- "Other"
NISPUF$language <- factor(NISPUF$Primary_language)

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
NISPUF$MAge <- factor(NISPUF$M_AGEGRP, labels = c("<=19 Years", "20-29 Years", ">=30 Years"))


## Race - Only child's race is available from NIS and only mother's race from NFP.
### Must assume these are the same.

NISPUF$RE <- factor(NISPUF$RACEETHK, labels = c("Hispanic", "WhiteNH", "BlackNH", "Other"))
nfp_demographics$RE <- as.character(nfp_demographics$MomsRE) # Renaming variable
nfp_demographics$RE[nfp_demographics$RE=="Hispanic or Latina"] <- "Hispanic" # Shortening description
nfp_demographics$RE[nfp_demographics$RE=="Declined or msg"] <- NA 
nfp_demographics$RE <- factor(nfp_demographics$RE) # Return to factor format with adjusted levels


## Child's gender: Create a binary dummy variable for "male"

NISPUF$male[NISPUF$SEX==1] <- 1
NISPUF$male[NISPUF$SEX==2] <- 0
nfp_demographics$male[nfp_demographics$Childgender=="Female"] <- 0 # Recode factor variable
nfp_demographics$male[nfp_demographics$Childgender=="Male"] <- 1 


## Mother's marital status

nfp_demographics$married <- nfp_demographics$marital_status # Rename variable so meaning of 1/0 is more evident
NISPUF$married[NISPUF$MARITAL2==1] <- 1
NISPUF$married[NISPUF$MARITAL2==2] <- 0

## Mother's education
###NFP tracks HS diploma, GED, or neither (HSGED).
###NIS has <12 years, 12 years, or 12+ years.  Original questionnaire wording buckets HS degrees and GEDs together.

nfp_demographics$HSgrad[nfp_demographics$HSGED==1] <- 1
nfp_demographics$HSgrad[nfp_demographics$HSGED==2] <- 1
nfp_demographics$HSgrad[nfp_demographics$HSGED==3] <- 0
NISPUF$HSgrad[NISPUF$EDUC1==1] <- 0
NISPUF$HSgrad[which(is.element(NISPUF$EDUC1,c(2,3,4)))] <- 1

# Matching variables TBD: WIC/Medicaid recipient status and insurance coverage.

NISPUF$treatment <- 0
nfp_demographics$treatment <- 1

immunizations <- rbind(NISPUF, nfp_demographics)

#save(immunizations, file = "/mnt/data/NIS/immunizations_analysis.RData", ascii = TRUE) # ASCII so it's readable years from now
save(nfp_demographics, file = "/mnt/data/NIS/NFP_immunizations_analysis.RData", ascii = TRUE) # ASCII so it's readable years from now
