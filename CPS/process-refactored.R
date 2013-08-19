###########################################################################################
##                                                                                       ##
##  PREPARE CURRENT POPULATION DATA FOR USE IN COMPARISON WITH HOME VISITATION OUTCOMES  ##
##                                                                                       ##
###########################################################################################

# Set workspace
rm(list=ls())
setwd("/mnt/data/CPS")
comment <- function(...){}
"%&%" <- function(...){paste(..., sep="")}
library("car")


# Import Raw Data
cps.raw <- read.table("cps.csv", sep = ',', header = TRUE)

names(cps.raw)
# The variables we are including (for March of 2008, 2009, and 2010) are:
### "YEAR"     "SERIAL"   "MISH"     "HWTSUPP"  "METRO"    "HHINCOME" "PUBHOUS"  "RENTSUB"
### "FOODSTMP" "STAMPVAL" "MONTH"    "PERNUM"   "WTSUPP"   "MOMLOC"   "STEPMOM"  "POPLOC" 
### "SPLOC"    "NCHILD"   "ASPOUSE"  "RELATE"   "AGE"      "SEX"      "RACE"     "MARST"
### "BPL"      "EDUC"     "EMPSTAT"  "OCCLY"    "UHRSWORK" "HIMCAID"  "GOTWIC"
# See https://github.com/dssg/nfp/tree/master/CPS for short descriptions of each field.

table(cps.raw[,c("YEAR", "MONTH")])

## Explore the link of households across years
  cps <- cps.raw
  cps$PrePost <- recode(cps[,c("MISH")], "1:4='Pre'; 5:8='Post'")
  table(cps[, c("MISH", "PrePost")])
  cps$BaseYear <- cps$YEAR - 1*(cps$PrePost == "Post")

  keepVars <- c("SERIAL", "PERNUM", "AGE", "YEAR", "MISH", "BaseYear")
  testMerge <- merge(cps[cps$PrePost=="Pre", keepVars],
                     cps[cps$PrePost=="Post", keepVars],
                     by=c("SERIAL", "PERNUM", "BaseYear"))

## Create a unique ids using serial and PERNUM
  cps$PERID <- cps$SERIAL %&% "-" %&% cps$PERNUM
  cps$SPID  <- cps$SERIAL %&% "-" %&% cps$SPLOC
  cps$POPID <- cps$SERIAL %&% "-" %&% cps$POPLOC
  cps$MOMID <- cps$SERIAL %&% "-" %&% cps$MOMLOC
  
## Identify households that have a child under 3
  serials.with.baby <- unique(cps[cps$AGE<3,]$SERIAL)
  cps$Hh.has.baby <- cps$SERIAL %in% serials.with.baby 

## Determine whether any children younger than three have older siblings
  MaxAge.by.Momid <- as.data.frame.table(by(cps$AGE, cps$MOMID, max))
  names(MaxAge.by.Momid) <- c("MOMID", "MaxAge.by.Momid")
  cps.HhChars <- merge(cps, MaxAge.by.Momid, by = c("MOMID"))
  cps.HhChars$OldestKidLt3 <- 1*(cps.HhChars$MaxAge.by.Momid < 3)

## Determine size of household (mostly used to check merges across pre-post)
  hh.size <- by(cps.HhChars$SERIAL, cps.HhChars$SERIAL, length)
  cps.HhChars$hh.size <- by(cps.HhChars$SERIAL, cps.HhChars$SERIAL, length)
  

## Build indication of raised-by-stepmother
  cps.HhChars$Stepmom.Ind <- 1*(cps.HhChars$STEPMOM == 0)

## Recode individual and household characteristics

  ## XXX: need to return to this after exploring CPS structure

## Combine Pre and Post
  names(cps.HhChars)
  cps.HhChars$BaseYear <- cps.HhChars$YEAR - 1*(cps.HhChars$PrePost == "Post")

  common.vars.to.keep <- c("PrePost", "PERID", "MOMID", "POPLOC", "SEX", "RACE",
                           "MARST", "PUBHOUS", "RENTSUB", "FOODSTMP", "WTSUPP")
  extra.pre.vars.to.keep  <- c()
  extra.post.vars.to.keep <- c(, )

  cps.pre  <- cps.HhChars[cps.HhChars$PrePost == "Pre" , c("SERIAL", "PERID", "MOMID", "BaseYear", "AGE", "Hh.has.baby", "MaxAge.by.Momid")]
  cps.post <- cps.HhChars[cps.HhChars$PrePost == "Post", c("SERIAL", "PERID", "MOMID", "BaseYear", "AGE", "Hh.has.baby", "MaxAge.by.Momid")]

  ## Attempt merges and test qualiyt
  hh.size.pre  <- as.data.frame(table(cps.pre$SERIAL))
  hh.size.post <- as.data.frame(table(cps.post$SERIAL))
  cps.pre.hhsize  <- merge(cps.pre,  hh.size.pre,  by.x=c("SERIAL"), by.y=c("Var1"))
  cps.post.hhsize <- merge(cps.post, hh.size.post, by.x=c("SERIAL"), by.y=c("Var1"))
  cps.prepost <- merge(cps.pre.hhsize, cps.post.hhsize, by=c("PERID", "BaseYear"))
  cps.prepost$Hh.size.diff <- cps.prepost$Freq.y - cps.prepost$Freq.x
  
  head(cps.prepost, n=30)
  cps.prepost$AgeDiff <- cps.prepost$AGE.y - cps.prepost$AGE.x
  
  cps.prepost$MaxAgeDiff <- cps.prepost$MaxAge.by.Momid.y - cps.prepost$MaxAge.by.Momid.x
  substrRight <- function(x, n) {; substring(x, nchar(x)-n+1, nchar(x)); };
  cps.prepost$MaxAgeDiff[cps.prepost$MaxAgeDiff==0] <- NA # Don't look at households that don't have a mother, indicated where MOMID is 0
  hist(cps.prepost$MaxAgeDiff)

# The fact that only a very small number of mothers appear to match across years in the 2008-2010 CPS March samples, this is
# not an essential issue with with sampling. The IPUMS distribution of CPS data does not currently provide information
# for linking households across years (http://answers.popdata.org/CPS-panel-release-date-scheduled-q546012.aspx), although
# this is a priority for IPUMS.  In the meantime, while we expected to be able to merge households across years, these hadnful
# of cases represent specifically only SERIAL numbers that were reused in a following year, and where the characteristics of families


#----------------------------------------------------------
## Previously-developed code to establish employment status
#----------------------------------------------------------

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
