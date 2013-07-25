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
# Rename select agencies where names did not match between datasets
demoExp$AGENCY_NAME <- factor(demoExp$AGENCY_NAME, levels = c(levels(demoExp$AGENCY_NAME), "Garrett County Nurse Family Partnership", 
							"Building Blocks/NFP  Missouri-Southeast Region NFP", "Otter Tail Becker Nurse-Family Partnership", 
							"NFP of St. Louis County and Carlton County", "North Phoenix NFP"))
demoExp$AGENCY_NAME[demoExp$AGENCY_NAME=="Garrett Co NFP Partnership for Children  Families"] <- "Garrett County Nurse Family Partnership"
demoExp$AGENCY_NAME[demoExp$AGENCY_NAME=="Building Blocks of Missouri-Southeast Region NFP"] <- "Building Blocks/NFP  Missouri-Southeast Region NFP"
demoExp$AGENCY_NAME[demoExp$AGENCY_NAME=="OtterTail Nurse-Family Partnership"] <- "Otter Tail Becker Nurse-Family Partnership"
demoExp$AGENCY_NAME[demoExp$AGENCY_NAME=="St. Louis County NFP"] <- "NFP of St. Louis County and Carlton County"
demoExp$AGENCY_NAME[demoExp$AGENCY_NAME=="Southwest Human Development"] <- "North Phoenix NFP"

# Merge demographics and agency information
demoAgency <- merge(demoExp, agency, by = intersect("AGENCY_NAME", "AGENCY_NAME"))

# Merge this dataset with weight gain and attrition data (available for all mothers)
weight_gain <- read.csv("weight_gain.csv")
weight_gain <- rename(weight_gain, c(cl_en_gen_id = "CL_EN_GEN_ID"))
deAgWg <- merge(demoAgency, weight_gain, by = intersect("CL_EN_GEN_ID","CL_EN_GEN_ID"))

attrition <- read.csv("discharge_reason.csv")
attrition <- rename(attrition, c(clid = "CL_EN_GEN_ID"))
deAgWgAt <- merge(deAgWg, attrition, by = intersect("CL_EN_GEN_ID","CL_EN_GEN_ID"))

# Read in and merge outcome datasets that share a common pool of individuals
breast <- read.csv("breast_feeding_variables.csv")
breast <- rename(breast, c(id2 = "CL_EN_GEN_ID"))
growth_immun <- read.csv("growth_immunization_outcomes.csv")
immun_source <- read.csv("immun_record_source.csv")
immun_source  <- rename(immun_source, c(cl_en_gen_id = "CL_EN_GEN_ID"))

all_immun <- merge(growth_immun, immun_source, by = intersect("CL_EN_GEN_ID","CL_EN_GEN_ID"))
all_out <- merge(all_immun, breast, by = intersect("CL_EN_GEN_ID","CL_EN_GEN_ID"))

# Read in other (outcome) data set
moms_life <- read.csv("secondpreg_employ_educ.csv")

# Merge outcomes with individual data & identify dropped observations
combine1 <- merge(deAgWgAt, all_out, by = intersect("CL_EN_GEN_ID","CL_EN_GEN_ID")) # Contains only obs in both sets
combine <- merge(deAgWgAt, all_out, by = intersect("CL_EN_GEN_ID","CL_EN_GEN_ID"), all.x = TRUE) # Contains all obs from deAgWgAt
missings <- combine[which(!is.element(combine$CL_EN_GEN_ID,combine1$CL_EN_GEN_ID)),] # Contains obs from deAgWgAt omitted from all_out
table(missings$ReasonForDismissal)
table(combine1$ReasonForDismissal) # Missing outcome data is not just for mothers who dropped out - some even graduated
# write.csv(missings$CL_EN_GEN_ID, "IDsMissingOutcomes.csv") # Create csv of obs missing outcome data

comb1 <- merge(deAgWgAt, moms_life, by = intersect("CL_EN_GEN_ID", "CL_EN_GEN_ID"))
comb <- merge(deAgWgAt, moms_life, by = intersect("CL_EN_GEN_ID", "CL_EN_GEN_ID"), all.x = TRUE)
miss <- comb[which(!is.element(comb$CL_EN_GEN_ID, comb1$CL_EN_GEN_ID)),]
dual_missing <- merge(missings, miss, by = intersect("CL_EN_GEN_ID", "CL_EN_GEN_ID")) # Note that 8 observations that are missing mom's life are NOT missing other outcome data!
# write.csv(miss$CL_EN_GEN_ID, "IDsMissingMothersOutcomes.csv")

# Final working datasets:
#### For breastfeeding, immunization, and growth outcomes: includes all obs with those outcomes (7 obs are NA for mom's life outcomes)
childout <- merge(combine1, moms_life, by = intersect("CL_EN_GEN_ID", "CL_EN_GEN_ID"), all.x = TRUE)
write.csv(childout,"Full_NFP_Data_Child_Development_Outcomes.csv")

#### For mother's life outcomes: includes all obs with those outcomes (8,848 obs are NA for other outcomes)
momsout <- merge(comb1, all_out, by = intersect("CL_EN_GEN_ID", "CL_EN_GEN_ID"), all.x = TRUE)
write.csv(momsout,"Full_NFP_Data_Mothers_Outcomes.csv")

## Usually, saving these datasets as RData would make for easy workflow.
## However, saving as CSVs allows us to start each analysis by importing a CSV, making our code easier to apply in other contexts.