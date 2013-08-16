# Nurse Family Partnership Immunization Study
 
## Overview

The Nurse-Family Partnership has lots of data for the women and children enrolled in the program, but it does not have a lot of data for women and children not in
 


## Methodology

We intend to conduct an impact evaluation using propensity score matching (PSM) (e.g. http://faculty.smu.edu/Millimet/classes/eco7377/papers/rosenbaum%20rubin%2083a.pdf).  PSM is a form of matching where cases are paired by their estimated probability of selection into treatment.  For example, income, age, and educational background plausibly affect whether a pregnant woman enrolls in NFP.  If we estimated the probability that each woman enrolls in NFP based on these characteristics (using, say, probit regression), then we could match an NFP enrollee with a 70% chance of enrolling with a non-enrollee with a 70% chance of enrolling.  Assuming we account for all the relevant factors that determine NFP enrollment, then the differences we observe between women in the program and women not in the program will on average be a good estimate of the program's effectiveness.  matching_examples.R demonstrates matching using an example where the explanatory variables are independent, another where they are not, and a third where the treatment effect varies and selection into treatment depends on the treatment effect.  The script demonstrates ordinary linear regression, stratification (a generalization of matching), exact matching, and propensity-score matching and includes explanations for each step.  The last part, where the treatment effect varies, is not complete, but the first two parts are.  

PSM_Script.R contains the beginning of our matching algorithm.  We will modify and merge its contents into separate scripts for each set of outcomes, e.g. a script for immunization outcomes.

NFP intends to evaluate outcomes at birth; in child health and development; in mother's life course development; and in intimate partner violence, child abuse, and neglect.  They have asked that we particularly consider child development and mother's life course outcomes.  These outcomes include the following:

Child Development and Health:
- Immunization rates
- Breastfeeding rates
- Language, cognitive, behavioral, and emotional development (as measured by the Ages and Stages Questionnaire)
- Physical growth, including height and weight

Mother's Life Course:
- Educational attainment
- Employment
- Governmental and community assistance
- Pregnancy interval
- Smoking/substance abuse

Note that we have included a script to convert the National Vital Statistics Survey from a fixed width format into a comma-separated value (CSV) format. While we are not using this code in our analysis, it would be helpful in evaluating the outcomes at birth.

## Comparison Data Sets

We have identified the following comparison datasets:

1. Current Population Survey (CPS): The CPS is a joint venture between the Census Bureau and the Bureau of Labor Statistics. As such, it includes extensive information about American households. Participating households are followed over a sixteen month period. They are interviewed monthly for the first four months and for the last four months. The households followed represent physical addresses that may or may not change residents during the period in sample. For information, see the README in the cps folder.

2. National Survey of Children's Health (NSCH): The NSCH is conducted by the National Center for Health Statistics at the Centers for Disease Control.  It includes information on breastfeeding and child weight (though height is not available for children under age 10).  It also includes a variety of demographic data points that can be used to match individuals in the survey to comparable individuals in NFP's data set.  To read more about the NSCH and request a copy of the data, visit www.childhealthdata.org.  More detail about which variables we are using from the NSCH and how we are recoding them is available in the cleaning script, NSCH_Prep.R.

3. National Immunization Survey (NIS): The NIS is conducted jointly by the National Center for Immunizations and Respiratory Diseases and the National Center for Health Statistics.  It includes provider-reported immunizations for several vaccines and thousands of people each year.  It also includes demographic and socioeconomic variables that we can use to match with individuals in the NFP dataset.  To read more about the NIS and to download a copy of the data, visit www.cdc.gov/nchs/nis.htm.  More detail about which variables we are using from NIS and how we are recoding them is available in the cleaning script, NIS_Prep.R.


