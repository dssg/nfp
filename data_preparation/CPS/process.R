# Set workspace
setwd("~/nfp/CPS")

# Import Raw Data
cps.raw <- read.table("cps.csv", sep = ',', header = TRUE)  

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

# Remove households that have no children under 3
no.young.child <- function(data) {
  young.serials <- unique(data[data$AGE<=2,]$SERIAL)
  KeepData <- data[which(is.element(data$SERIAL, young.serials)),]
  return(KeepData)
}

march.2008 <-no.young.child(march.2008)
march.2009 <- no.young.child(march.2009)
march.2010 <- no.young.child(march.2010)


# Add column with combination serial and PERNUM
per.col <- function(data) {
  PERID <- mapply(paste, data$SERIAL, data$PERNUM, sep = "-")
  return(cbind(data,PERID))
}

march.2008.labels <- c(march.2008.labels, "PERID")
march.2008 <- per.col(march.2008)
march.2009.labels <- c(march.2009.labels, "PERID")
march.2009 <- per.col(march.2009)
march.2010.labels <- c(march.2010.labels, "PERID")
march.2010 <- per.col(march.2010)

#Add column with combination serial and SPLOC
sp.col <- function(data) {
  SPID <- mapply(paste, data$SERIAL, data$SPLOC, sep = "-")
  return(cbind(data,SPID))
}

march.2008.labels <- c(march.2008.labels, "SPID")
march.2008 <- sp.col(march.2008)
march.2009.labels <- c(march.2009.labels, "SPID")
march.2009 <- sp.col(march.2009)
march.2010.labels <- c(march.2010.labels, "SPID")
march.2010 <- sp.col(march.2010)

#Add column with combination serial and POPLOC
pop.col <- function(data) {
  POPID <- mapply(paste, data$SERIAL, data$POPLOC, sep = "-")
  return(cbind(data, POPID))
}

march.2008.labels <- c(march.2008.labels, "POPID")
march.2008 <- pop.col(march.2008)
march.2009.labels <- c(march.2009.labels, "POPID")
march.2009 <- pop.col(march.2009)
march.2010.labels <- c(march.2010.labels, "POPID")
march.2010 <- pop.col(march.2010)

# Add column with combination serial and MOMLOC
mom.col <- function(data) {
  MOMID <- mapply(paste,data$SERIAL, data$MOMLOC, sep = "-")
  return(cbind(data,MOMID))
}

march.2008.labels <- c(march.2008.labels, "MOMID")
march.2008 <- mom.col(march.2008)
march.2009.labels <- c(march.2009.labels, "MOMID")
march.2009 <- mom.col(march.2009)
march.2010.labels <- c(march.2009.labels, "MOMID")
march.2010 <- mom.col(march.2010)

# Determine whether any children younger than three have older siblings
## Eliminate families where all young kids have older siblings

no.sibs <- function(data) {
  # The MOMIDs of all young children (under three)
  young.momids <- unique(data[data$AGE<3,]$MOMID)
  # The MOMIDS of older kids who share a MOMID with child under three
  sibling.momids <- unique(data[!data$AGE<3,][which(is.element(data[!data$AGE<3,]$MOMID, young.momids)),]$MOMID)
  # The momids of young children without siblings above the age limit
  keep.momids <- young.momids[-which(is.element(young.momids,sibling.momids))]
  # The serial numbers of the families with children we will keep
  keep.serials <- data[data$AGE<3,][which(is.element(data[data$AGE<3,]$MOMID,keep.momids)),]$SERIAL
  # A subset of the data that contains only the applicable families
  return(data[which(is.element(data$SERIAL, keep.serials)),])
}

march.2008 <- droplevels(no.sibs(march.2008))
march.2009 <- droplevels(no.sibs(march.2009))
march.2010 <- droplevels(no.sibs(march.2010))

# Remove all families where all the young children have stepmothers
no.step <- function(data) {
  # For readability sake, we create a list of the relevent kids
  kids <- data[data$AGE<3,]
  # The serial numbers of the households where a relevent kid has no stepmom
  no.stepmom.serials <- unique(kids[kids$STEPMOM == 0,]$SERIAL)
  # A subset of the data that only includes the applicable families
  return(data[which(is.element(data$SERIAL, no.stepmom.serials)),])
}

march.2008 <- droplevels(no.step(march.2008))
march.2009 <- droplevels(no.step(march.2009))
march.2010 <- droplevels(no.step(march.2010))

# Here we add a code for whether a child under three 
## is the oldest child
mark.oldest <- function(data) {
  # Initialize n at 0, so that at the end of the function, n is the minimum number
  ## such that there are no n-tuplets of relevent children are present
  n = 0
  result = NULL
  ## Initialize line.no to pass while loop before first pass (could also use a do/while)
  line.no = matrix(c(1,1), nrow = 1)
  #Number the rows so that we can produce proper indexes
  LINE = 1:dim(data)[1]
  newdata <- cbind(data, LINE)
  while(dim(line.no)[1] > 0) {
    n = n+1
    #Prints the line numbers of the oldest relevant children
    line.no <- ddply(newdata, .(MOMID), 
        function(df) {return(df$LINE[df$AGE == max(df$AGE) & df$AGE < 3][n])})
    #Eliminate NAs
    line.no <- line.no[-which(is.na(line.no[,2])),]
    result = rbind(result, line.no)
  }
  OLDEST = rep(0,dim(data)[1])
  OLDEST[result[,2]] = 1
  return(cbind(data, OLDEST))
}

march.2008.labels <- c(march.2008.labels,"OLDEST")
march.2008 <- mark.oldest(march.2008)
march.2009.labels <- c(march.2009.labels,"OLDEST")
march.2009 <- mark.oldest(march.2009)
march.2010.labels <- c(march.2010.labels,"OLDEST")
march.2010 <- mark.oldest(march.2010)

# Remove from 2008 dataset those families that are in their second year as CPS participants
march.2008 = march.2008[march.2008$MISH <= 4,]

# Remove from the 2010 dataset those families in their first year as CPS participants
march.2010 = march.2010[march.2010$MISH >= 5,]


combined_data <- rbind(march.2008, march.2009, march.2010)
summarized_data <- ddply(combined_data, .(SERIAL), summarize, sd = sd(YEAR))
keep_serials <- summarized_data[summarized_data$sd != 0,]$SERIAL

# Hmmm there are only 123 eligible serial numbers...


#Note that we can access the mothers of these kids [eligible mothers in the program]
### using the lines:

### These first three lines use the code above to find the MOMIDs of the children
#### without an older sibling.

#       young.momids <- unique(data[data$AGE<3,]$MOMID)
#       sibling.momids <- unique(data[!data$AGE<3,][which(is.element(data[!data$AGE<3,]$MOMID, young.momids)),]$MOMID)
#       keep.momids <- young.momids[-which(is.element(young.momids,sibling.momids))]

### 
#       moms <- data[which(is.element(data$PERNUM,keep.momids)),]

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


#write.table(march.2008, file = "cps.march.2008.csv", append = FALSE, quote = FALSE, sep = ',', row.names = FALSE)
#write.table(march.2009, file = "cps.march.2009.csv", append = FALSE, quote = FALSE, sep = ',', row.names = FALSE)
#write.table(march.2010, file = "cps.march.2010.csv", append = FALSE, quote = FALSE, sep = ',', row.names = FALSE)