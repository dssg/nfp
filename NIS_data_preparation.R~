##################################
##    Data Preparation File     ##
## National Immunization Survey ##
##         Joe Walsh            ##
##         Emily Rowe           ##
##        Adam Fishman          ##
##################################


## NIS provides R scripts to prepare the data for analysis.  Run each and make a few modifications.
## I'm commenting out the source lines because 1) once they're run they don't need to run again and 2) they take too long to run.

############
# 2008 NIS data
source("/mnt/data/NIS/original_data/nispuf08.r")

# eliminate observations missing adequate provider data
NISPUF08 <- subset(NISPUF08, PDAT=="CHILD HAS ADEQUATE PROVIDER DATA OR ZERO VACCINATIONS")
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






