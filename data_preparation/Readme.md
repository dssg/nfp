Current Population Survey
-------------------------

The Current Population Survey (CPS) is a monthly surey of households in the United States that is jointly conducted by the U.S. Census Bureau and U.S. Bureau of Labor Statistics. The CPS has been conducted since 1962, allowing for a means to compare long-term trends in household composition, demographics, labor force participation, earnings, education, involvement in public programs, and more across time. At present, the CPS reaches out to approximately 76,000 households each month, representing approximately 200,000 individuals (counting from our 2010 March CPS data set obtained from IPUMS; see description below). Each survey contains a core questionnaire and, in certain months, supplementary questionnaires on topics such as computer usage, detailed school enrollment questions, and public program participation (see http://www.census.gov/cps/about/supplemental.html).

The sampling structure of the CPS permits longitudinal analysis across short timeframes. Once a household is first reached by the CPS, they are surveyed in four consecutive months, are then not reapproached for eight following months, and then are surveyed in four months. This means that information is available for each household in the equivalent month across consecutive calendar years, which both respects any seasonal variation in behavior or response, and ensures that the household will respond to the same supplemental survey questions in each of the two calendar years in which they are enrolled.

### Use of CPS Data in Evaluating NFP

In the context of an evaluation study for NFP, the March Annual Social and Economic Supplmenet (ASEC) CPS data include measures of:
* household composition in terms of household composition, e.g. identifying ages of children, adults, and relationships between adults); 
* demographic information in terms of mother's age, race, baseline education, household income, marital status, and state of residence; and
* employment and educational outcomes for mothers of young children.

Because of the longitudinal structure of the CPS, women's improvement in education, employment, and reliance on other public programs can be assessed across a single year. However, note that no health information is available specific to child health in their first two years, and the age of children is not reported with enough detail to be able to determine time until second pregnancy.

Of the 76,000-some households that are surveyed in each month, just over 2,250 represent households in which the oldest child is two years old or younger. Although this is a small percentage and a relatively small absolute number, especially when looking to identify mothers from disadvantaged backgrounds, pooling across multiple administrations of the CPS would obtain a large sample for comparison. This can be done by pooling across years and, conditional on the core CPS questionnaire having information on all controls and outcomes of interest, across months which would significantly increase the available sample size.

### Sources of CPS Data

Although the Census Bureau (see http://www.census.gov/cps/) and Bureau of Labor Statistics (see http://www.bls.gov/cps/tables.htm) administer the CPS, there are several other groups that maintain historical CPS data files and documentation that can be used for retrospective analysis and comparison for research purposes. 

* 

<Multiple sources from which the data can be obtained>

<Where to find out more about the CPS>
<How we proceed>

### CPS Data Selected for this Study

This is the folder that contains information of and/or related to the current population survey dataset.
This data can be freely downloaded from [IPUMS](http://cps.ipums.org). When downloading this dataset, be careful to choose the correct variables to download. The ones we used are:

| Variable Name | Description | Other Details |
|:---:|:---:|:---:|
| YEAR | Year surveyed | *preselected* |
| SERIAL | Household serial number | *preselected* |
| HWTSUPP |Household-level weight necessary to generate statistics using March Annual Social and Economic (ASEC) Supplement data | *preselected* |
| METRO | Indicates whether the location of the household is in a metro area |
| HHINCOME | Household income |
| PUBHOUS | Indicates whether the household was in a public housing project |
| RENTSUB | Indicates whether the household's rent is federally subsidized |
| FOODSTMP | Indicates whether one or more members of the household are on foodstamps |
| STAMPVAL | Total value of foodstamps received by the household over the previous year |
| MONTH | Month surveyed | *preselected* |
| PERNUM | Person's number in the household |
| WTSUPP | Person-level weight necessary for analyses of individual-level CPS supplement data | *preselected* |
| MOMLOC | Indicates whether a person's mother lived in the household and, if so, gives her person number |
| STEPMOM | Presence of a stepmother in the household |
| POPLOC | Indicates whether a person's father lived in the household and, if so, gives his person number |
| SPLOC | Spouse's person number |
| NCHILD | Number of a person's own children, including step and adopted children, living in the household |
| ASPOUSE | Indicates whether a person's spouse lived in the household and, if so, gives his/her person number |
| RELATE | Relationship to head of household |
| AGE | Person's age at his/her last birthday |
| SEX | Person's sex |
| RACE | Person's race |
| MARST | Person's marital status |
| BPL | Indicates whether a person was born in the USA and, if not, gives his/her birth country |
| EDUC | Highest level of education attained |
| EMPSTAT | Person's employment status |
| OCCLY | Person's primary occupation during the previous calendar year |
| UHRSWORK | Usual number of hours worked per week)
| HIMCAID | Indicates whether the respondent was covered by Medicaid during the previous calendar year |
| GOTWIC | Indicates whether, during the previous calendar year, the respondent received benefits from WIC, the Special Supplemental Nutrition Program for Women, Infants and Children |


Preprocessing
--------

We selected data for March and June of 2008-2010 (inclusive). 
We first removed all households without a child under the age of three.
We then removed all households where all of the children under the age of three had a sibling over the age of three.
We then removed all households where every eligible child has a stepmother living in the house.
We added extra codes for Employment status, whether full time, part time, or unemployed. 
We also added extra unique codes for person, mother, father, and spouse (rather than just a number within the household)
