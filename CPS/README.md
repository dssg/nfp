Current Population Survey
=========================

This is the folder that contains information of and/or related to the current population survey dataset.
This data can be freely downloaded from [IPUMS](http://cps.ipums.org). When downloading this dataset, be careful to choose the correct variables to download. The ones we used are:
+ YEAR (Year surveyed, *preselected*)
+ SERIAL (Household serial number, *preselected*)
+ HWTFINL (Household level weight necessary to generate statistics about households, *preselected*)
+ HWTSUPP (Household-level weight necessary to generate statistics using March Annual Social and Economic (ASEC) Supplement data, *preselected*)
+ METRO (Indicates whether the location of the household is in a metro area)
+ COUNTY (FIPS state and county codes for household location)
+ HHINCOME (Household income)
+ PUBHOUS (Indicates whether the household was in a public housing project)
+ RENTSUB (Indicates whether the household's rent is federally subsidized)
+ FOODSTMP (Indicates whether one or more members of the household are on foodstamps)
+ STAMPVAL (Total value of foodstamps received by the household over the previous year)
+ MONTH (Month surveyed, *preselected*)
+ WTSUPP (Person-level weight necessary for analyses of individual-level CPS supplement data, *preselected*)
+ WTFINL (Person-level weight necessary for analyses of basic monthly data, *preselected*)
+ MOMLOC (Indicates whether a person's mother lived in the household and, if so, gives her person number)
+ POPLOC (Indicates whether a person's father lived in the household and, if so, gives his person number)
+ NCHILD (Number of a person's own children, including step and adopted children, living in the household)
+ ASPOUSE (Indicates whether a person's spouse lived in the household and, if so, gives his/her person number)
+ AGE (Person's age at his/her last birthday)
+ SEX (Person's sex)
+ RACE (Person's race)
+ MARST (Person's marital status)
+ BPL (Indicates whether a person was born in the USA and, if not, gives his/her birth country)
+ EDUC (Highest level of education attained)
+ EDDIPGED (For those with either a high school diploma or a GED/equivalent program, indicates which)
+ EMPSTAT (Person's employment status)
+ OCCLY (Person's primary occupation during the previous calendar year)
+ UHRSWORK (Usual number of hours worked per week)
+ HIMCAID (Indicates whether the respondent was covered by Medicaid during the previous calendar year)
+ GOTWIC (Indicates whether, during the previous calendar year, the respondent received benefits from WIC, the Special Supplemental Nutrition Program for Women, Infants and Children)
+ FREVER (Number of live births a woman has had)
+ FRBIRTHM (Birth month of youngest child)
+ FRBIRTHY (Birth year of youngest child)

Preprocessing
--------

We selected data for March and June of 2008-2010 (inclusive). We first removed all women that are not mothers. We added extra codes for Employment status, whether full time, part time, or unemployed. We added a flag for child under age of 3 (to aid in comparison to the Nurse Family Partnership data), whether a child was the mother's only child, and whether the father was present. Along with that munging, we also recoding the educational data to express whether a mother graduated high school, received a GED, or neither.
