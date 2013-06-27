# Set workspace
setwd("/Users/Fishface/Documents/DSSG/nfp/CPS")

# Import Raw Data
cps.raw <- read.table("cps.csv", sep = ',', header = TRUE)

# Note that the labels for this data set will be equal to 
 # "YEAR","SERIAL","HWTFINL","HWTSUPP","METRO","COUNTY","HHINCOME","PUBHOUS",
# "RENTSUB","FOODSTMP","STAMPVAL","MONTH","WTSUPP","WTFINL","MOMLOC","POPLOC",
#"NCHILD","ASPOUSE","AGE","SEX","RACE","MARST","BPL","EDUC","EDDIPGED",
#"EMPSTAT","OCCLY","UHRSWORK","HIMCAID","GOTWIC","FREVER","FRBIRTHM","FRBIRTHY"

# Report which statistics are available in which time periods
which.available <- function(month, year) {
  uniq.data <- unique(!is.na(cps.raw[cps.raw$YEAR == year & cps.raw$MONTH == month,]), MARGIN = 1)
  if(dim(uniq.data)[1] != 1) {
    print ("Oops! That data isn't consistent")
    return -1
  } else {
    return(colnames(uniq.data)[uniq.data])
  }
}

march.2008.labels <- which.available(3, 2008)
march.2009.labels <- which.available(3, 2009)
march.2010.labels <- which.available(3,2010)

june.2008.labels <- which.available(6,2008)
june.2009.labels <- which.available(6,2009)
june.2010.labels <- which.available(6,2010)

# Coding whether an individual is working and what his/her employment status is

work.code <- function 