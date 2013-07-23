setwd("/mnt/data/nfp_data/csv_data")

# Read in demographics and agency datasets
demo <- read.csv("nfp_demographics.csv")
demoExp <- read.csv("nfp_demographics_expanded.csv") # Note: demoExp appears to be all inclusive of demo
agency <- read.csv("agency.csv")
agency10 <- read.csv("2010 agencies.csv") # agency appears to be in inclusive of agency10

# Rename columns and remove duplicate record in agency file prior to merging
library(plyr) # Some problem with AWS finding the rename function - this takes care of it
agency <- rename(agency, c(Address1 = "agency_address1", Address2 = "agency_address2", City = "agency_city", State = "agency_state", ZipCode = "agency_zip", county = "agency_county"))
agency <- agency[!agency$Site_ID==294,]

# Rename agency name column in demographics file prior to merging with agency data
demoExp <- rename(demoExp, c(sitecode = "AGENCY_NAME"))

# Merge demographics and agency information
demoAgency <- merge(demoExp, agency, by = intersect("AGENCY_NAME", "AGENCY_NAME"), all.x = TRUE)
# Note 440 individuals in demographics dataset have names with no match in the agency set.
# Questions and IDs sent to Dustin for review on 7/23.

# Read in other (outcome) data sets
breast <- read.csv("breast_feeding_variables.csv")
growth_immun <- read.csv("growth_immunization_outcomes.csv")
immun_source <- read.csv("immun_record_source.csv")
moms_life <- read.csv("secondpreg_employ_educ.csv")
weight_gain <- read.csv("weight_gain.csv")
attrition <- read.csv("discharge_reason.csv")