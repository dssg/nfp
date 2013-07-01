# Set workspace
setwd("/Users/Fishface/Documents/DSSG/nfp/CPS")

# Import Raw Data
cps.raw <- read.table("cps.csv", sep = ',', header = TRUE)

# Note that the labels for this data set will be equal to
 # "YEAR","SERIAL","HWTFINL","HWTSUPP","METRO","COUNTY","HHINCOME","PUBHOUS",
# "RENTSUB","FOODSTMP","STAMPVAL","MONTH","WTSUPP","WTFINL","MOMLOC","POPLOC",
#"NCHILD","ASPOUSE","AGE","SEX","RACE","MARST","BPL","EDUC","EDDIPGED",
#"EMPSTAT","OCCLY","UHRSWORK","HIMCAID","GOTWIC","FREVER","FRBIRTHM","FRBIRTHY"

# Report which statistics are available in which time periods and partition
## dataset into time period groups
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
march.2008 <- cps.raw[cps.raw$YEAR == 2008 & cps.raw$MONTH == 3,][,march.2008.labels]
march.2009.labels <- which.available(3, 2009)
march.2009 <- cps.raw[cps.raw$YEAR == 2009 & cps.raw$MONTH == 3,][,march.2009.labels]
march.2010.labels <- which.available(3,2010)
march.2010 <- cps.raw[cps.raw$YEAR == 2010 & cps.raw$MONTH == 3,][,march.2010.labels]

june.2008.labels <- which.available(6,2008)
june.2008 <- cps.raw[cps.raw$YEAR == 2008 & cps.raw$MONTH == 6,][,june.2008.labels]
june.2009.labels <- which.available(6,2009)
june.2009 <- cps.raw[cps.raw$YEAR == 2009 & cps.raw$MONTH == 6,][,june.2009.labels]
june.2010.labels <- which.available(6,2010)
june.2010 <- cps.raw[cps.raw$YEAR == 2010 & cps.raw$MONTH == 6,][,june.2010.labels]

# Remove households that have no children under 3
no.young.child <- function(data) {
  young.serials <- unique(data[data$AGE<3,]$SERIAL)
  KeepData <- data[which(is.element(data$SERIAL, young.serials)),]
  return(KeepData)
}

march.2008 <-no.young.child(march.2008)
march.2009 <- no.young.child(march.2009)
march.2010 <- no.young.child(march.2010)

june.2008 <- no.young.child(june.2008)
june.2009 <- no.young.child(june.2009)
june.2010 <- no.young.child(june.2010)

# Add column with combination serial and MOMLOC
mom.col <- function(data) {
  MOMID <- mapply(paste,data$SERIAL, data$MOMLOC, sep = "-")
  return(cbind(data,MOMID))
}

march.2008 <- mom.col(march.2008)
march.2009 <- mom.col(march.2009)
march.2010 <- mom.col(march.2010)

# Determine whether any children younger than three have older siblings
## Eliminate families where all young kids have older siblings

no.sibs <- function(data) {
  young.momids <- unique(data[data$AGE<3,]$MOMID)
  sibling.momids <- unique(data[!data$AGE<3,][which(is.element(data[!data$AGE<3,]$MOMID, young.momids)),]$MOMID)
  keep.momids <- young.momids[-which(is.element(young.momids,sibling.momids))]
  keep.serials <- data[data$AGE<3,][which(is.element(data[data$AGE<3,]$MOMID,keep.momids)),]$SERIAL
  return(data[which(is.element(data$SERIAL, keep.serials)),])
}

march.2008 <- droplevels(no.sibs(march.2008))
march.2009 <- droplevels(no.sibs(march.2009))
march.2010 <- droplevels(no.sibs(march.2010))

# Here we add a code for whether a child under three 
## is the oldest child
mark.oldest <- function(data) {
  n = 0
  result = NULL
  line.no.first = matrix(c(1,2,3,4), nrow = 2)
  LINE = 1:dim(data)[1]
  newdata <- cbind(data, LINE)
  while(dim(line.no.first)[1] > 0) {
    n = n+1
    line.no.first <- ddply(newdata, .(MOMID), 
        function(df) {return(df$LINE[df$AGE == max(df$AGE) & df$AGE < 3][n])})
    line.no.first <- line.no.first[-which(is.na(line.no.first[,2])),]
    result = rbind(result, line.no.first)
  }
  OLDEST = rep(0,dim(data)[1])
  OLDEST[result[,2]] = 1
  return(cbind(data, OLDEST))
}

march.2008 <- mark.oldest(march.2008)
march.2009 <- mark.oldest(march.2009)
march.2010 <- mark.oldest(march.2010)
# Coding whether an individual is working and what his/her employment status is
## Codes (EMPLOY):
######## 0 = Unemployed
######## 1 = Part-time
######## 2 = Full-time
work.code.row <- function(row,n,m) {
  if(row[n] < 20) {
    if(row[n] != 0) {
      if(row[m] < 35) {
        if(row[m] != 0) {
          return(1)
        } else {return(NA)}
      } else {return(2)}
    } else {return(NA)}
  } else return(0)
}

work.code <- function(data) {
  if("EMPSTAT" %in% names(data)){
    if("UHRSWORK" %in% names(data)) {
      n <- grep("EMPSTAT", names(data))
      m <- grep("UHRSWORK", names(data))
      result <- apply(data, MARGIN = 1, work.code.row, n=n, m=m)
      return(result)
    } else {
      print("Oops! We are missing the UHRSWORK data. Check the time period.")
    }
  } else print("Oops! We are missing the EMPSTAT data. Check the time period.")
}

## Now we add the results into our data
march.2008.labels <- c(march.2008.labels,"EMPLOY")
EMPLOY <- work.code(march.2008)
march.2008 <- cbind(march.2008, EMPLOY)

march.2009.labels <- c(march.2009.labels,"EMPLOY")
EMPLOY <- work.code(march.2009)
march.2009 <- cbind(march.2009, EMPLOY)

march.2010.labels <- c(march.2010.labels,"EMPLOY")
EMPLOY <- work.code(march.2010)
march.2010 <- cbind(march.2010, EMPLOY)

#Adds label for high school attainment
##Labels are as follows:
######## 0 = No High School/GED
######## 1 = 
