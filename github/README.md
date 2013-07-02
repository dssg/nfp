Current Population Survey
=========================

This is the folder that contains information of and/or related to the current population survey dataset.
This data can be freely downloaded from [IPUMS](http://cps.ipums.org). When downloading this dataset, be careful to choose the correct variables to download. The ones we used are:
+ YEAR (Year surveyed, *preselected*)
+ SERIAL (Household serial number, *preselected*)
+ HWTSUPP (Household-level weight necessary to generate statistics using March Annual Social and Economic (ASEC) Supplement data, *preselected*)
+ METRO (Indicates whether the location of the household is in a metro area)
+ HHINCOME (Household income)
+ PUBHOUS (Indicates whether the household was in a public housing project)
+ RENTSUB (Indicates whether the household's rent is federally subsidized)
+ FOODSTMP (Indicates whether one or more members of the household are on foodstamps)
+ STAMPVAL (Total value of foodstamps received by the household over the previous year)
+ MONTH (Month surveyed, *preselected*)
+ PERNUM (Person's number in the household)
+ WTSUPP (Person-level weight necessary for analyses of individual-level CPS supplement data, *preselected*)
+ MOMLOC (Indicates whether a person's mother lived in the household and, if so, gives her person number)
+ STEPMOM (Presence of a stepmother in the household)
+ POPLOC (Indicates whether a person's father lived in the household and, if so, gives his person number)
+ SPLOC (Spouse's person number)
+ NCHILD (Number of a person's own children, including step and adopted children, living in the household)
+ ASPOUSE (Indicates whether a person's spouse lived in the household and, if so, gives his/her person number)
+ RELATE (Relationship to head of household)
+ AGE (Person's age at his/her last birthday)
+ SEX (Person's sex)
+ RACE (Person's race)
+ MARST (Person's marital status)
+ BPL (Indicates whether a person was born in the USA and, if not, gives his/her birth country)
+ EDUC (Highest level of education attained)
+ EMPSTAT (Person's employment status)
+ OCCLY (Person's primary occupation during the previous calendar year)
+ UHRSWORK (Usual number of hours worked per week)
+ HIMCAID (Indicates whether the respondent was covered by Medicaid during the previous calendar year)
+ GOTWIC (Indicates whether, during the previous calendar year, the respondent received benefits from WIC, the Special Supplemental Nutrition Program for Women, Infants and Children)


Preprocessing
--------

We selected data for March and June of 2008-2010 (inclusive). 
We first removed all households without a child under the age of three.
We then removed all households where all of the children under the age of three had a sibling over the age of three.
We then removed all households where every eligible child has a stepmother living in the house.
We added extra codes for Employment status, whether full time, part time, or unemployed. 
We also added extra unique codes for person, mother, father, and spouse (rather than just a number within the household)
