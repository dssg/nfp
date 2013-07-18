setwd("/mnt/data/nfp_data/csv_data")

demo <- read.csv("nfp_demographics.csv")
demoExp <- read.csv("nfp_demographics_expanded.csv") # Note: demoExp appears to be all inclusive of demo

agency <- read.csv("agency.csv")
agency10 <- read.csv("2010 agencies.csv") # agency appears to be in inclusive of agency10

# Rename agency variables to minimize confusion before merging

demoAgency <- merge(demoExp, agency, by = intersect("sitecode", "Site_ID"))


breast <- read.csv("breast_feeding_variables.csv")
growth_immun <- read.csv("growth_immunization_outcomes.csv")
immun_source <- read.csv("immun_record_source.csv")
moms_life <- read.csv("secondpreg_employ_educ.csv")
weight_gain <- read.csv("weight_gain.csv")