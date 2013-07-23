setwd("/mnt/data/nfp_data")
library(sas7bdat)

data <- read.sas7bdat("discharge_reason.sas7bdat")
write.csv(data,"discharge_reason.csv")