# Nurse Family Partnership Impact Evaluation
 
This is a [Data Science for Social Good Fellowship](http://dssg.io) project to help the Nurse Family Partnership evaluate its effectiveness at promoting healthy child developmental outcomes and stable families.
 
## The Problem
 
The Nurse-Family Partnership (NFP) is a home-visitation program that pairs a nurse with an at-risk first-time mother for the duration of her pregnancy and the first two years of her child's life. The Affordable Care Act of 2010 made new money available to home visitation programs such as NFP, but also required increased accountability for evidence-based demonstrations of effectiveness. NFP was founded on the basis of multiple randomized controlled trials (which are on-going, in follow-up), and is continuing to proactively study its impacts with more recent cohorts of children and mothers that they have served, and to do so at a national-scale. But while their formidable information tracking system affords them a large-scale, systematic basis for comparing the outcomes of children and mothers that they serve, they face two principle challenges to performing a large-scale evaluation:

1) They do not have data on child and mother outcomes for a comparison population (i.e. which they do not serve);

2) The lack of a randomized controlled study design raises challenges of self-selection or systematic attrition in drawing conclusions of NFP's impact.

## The Project 

To assist NFP, We are comparing administrative data from NFP to several public national datasets with the goal of identifying women who are similar on all observable characteristics (such as demographics) in the two datasets and comparing their outcomes.  More information about the challenges that shaped our project and methodology are available in our wiki [here] (https://github.com/dssg/nfp/wiki/Problem).

Our project has two goals:

1) To provide a rough evaluation of NFP's impact at a national level. Although this study will not have validity equivalent to a randomized controlled trial, it represents a significant improvement over the evidence basis that would otherwise be available to current decision processes.

2) To develop a methodology for basic impact evaluation of nonprofit programs where resource limitations and program size make traditional experimental evaluations impractical or impossible.


### Methodology

We intend to conduct an impact evaluation using propensity score matching (PSM) (e.g. http://faculty.smu.edu/Millimet/classes/eco7377/papers/rosenbaum%20rubin%2083a.pdf) and other matching methods as necessary.  PSM is a form of matching where cases are paired by their estimated probability of selection into treatment.  For example, income, age, and educational background plausibly affect whether a pregnant woman enrolls in NFP.  If we estimated the probability that each woman enrolls in NFP based on these characteristics (using, say, probit regression), then we could match an NFP enrollee with a 70% chance of enrolling with a non-enrollee with a 70% chance of enrolling.  Assuming we account for all the relevant factors that determine NFP enrollment, then the differences we observe between women in the program and women not in the program will on average be a good estimate of the program's effectiveness.  matching_examples.R demonstrates matching using an example where the explanatory variables are independent, another where they are not, and a third where the treatment effect varies and selection into treatment depends on the treatment effect.  The script demonstrates ordinary linear regression, stratification (a generalization of matching), exact matching, and propensity-score matching, and it includes explanations for each step.  

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

### Comparison Data Sets

We have identified the following comparison datasets:

1. Current Population Survey (CPS): The CPS is a joint venture between the Census Bureau and the Bureau of Labor Statistics. As such, it includes extensive information about American households. Participating households are followed over a sixteen month period. They are interviewed monthly for the first four months and for the last four months. The households followed represent physical addresses that may or may not change residents during the period in sample. For information, see the README in the cps folder.

2. National Survey of Children's Health (NSCH): The NSCH is conducted by the National Center for Health Statistics at the Centers for Disease Control.  It includes information on breastfeeding and child weight (though height is not available for children under age 10).  It also includes a variety of demographic data points that can be used to match individuals in the survey to comparable individuals in NFP's data set.  To read more about the NSCH and request a copy of the data, visit www.childhealthdata.org.  More detail about which variables we are using from the NSCH and how we are recoding them is available in the cleaning script, NSCH_Prep.R.

3. National Immunization Survey (NIS): The NIS is conducted jointly by the National Center for Immunizations and Respiratory Diseases and the National Center for Health Statistics.  It includes provider-reported immunizations for several vaccines and thousands of people each year.  It also includes demographic and socioeconomic variables that we can use to match with individuals in the NFP dataset.  To read more about the NIS and to download a copy of the data, visit www.cdc.gov/nchs/nis.htm.  More detail about which variables we are using from NIS and how we are recoding them is available in the cleaning script, NIS_Prep.R.

## Using R

All of our data analysis, impact estimation, and exhibit generation code is written in R, as an openly available and widely used statistics software. We made this choice to ensure accessibility of our work to the broad non-profit and research community that might be interested in this work. While R is widely--and increasingly--being used, we recognize that many potential users of this code may not have any, or at least, comfortable acquaintance with programming in R. Several references and tutorials that we highly recommend are:

* [Code School's free, interactive tutorial in R](http://www.codeschool.com/courses/try-r)
* Books tailored to one's programming background, such as [R for SAS and SPSS Users](http://www.amazon.com/SAS-SPSS-Users-Statistics-Computing/dp/1461406846/ref=sr_1_1?s=books&ie=UTF8&qid=1376955179&sr=1-1) by Robert Muenchen or  [R for Stata Users](http://www.amazon.com/R-Stata-Users-Statistics-Computing/dp/1461425964/ref=sr_1_2?s=books&ie=UTF8&qid=1376955179&sr=1-2) by Robert Muenchen and Joseph Hilbe
 * Note that these books have excellent, and freely available, code samples for many common operations in R, with comparisons to the equivalent commands in SAS, SPSS and Stata.
* [R in a Nutshell](http://web.udl.es/Biomath/Bioestadistica/R/Manuals/r_in_a_nutshell.pdf) by Joseph Adler, published by O'Reilly
* A number of freely available "quick reference" sheets such as ones by [Tom Short](http://cran.r-project.org/doc/contrib/Short-refcard.pdf), and staff at the [University of Auckland](https://www.stat.auckland.ac.nz/~stat380/downloads/QuickReference.pdf).
 
Searching the internet is also an excellent way to understand the commands that we used or to search for methods of interest to you, due to the large and active community of R users.


## License

Copyright (C) 2013 Data Science for Social Good Fellowship at the University of Chicago

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
