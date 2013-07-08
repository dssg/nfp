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

setwd("/mnt/data/modified_data")
NIS08 <- load("NISPUF08.RData")
NIS09 <- load("NISPUF09.RData")
NIS10 <- load("NISPUF10.RData")
NIS11 <- load("NISPUF11.RData")

# Variable Recodes - NIS





# Load NFP data for recoding and preparation

setwd("/mnt/data/csv_data")
nfp_demographics <- read.csv("nfp_demographics_expanded.csv")
nfp_centers <- read.csv("agency.csv")

# Variable Recodes - NFP
