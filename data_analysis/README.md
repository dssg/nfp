# DSSG Nurse Family Partnership Study -- Data Analysis
 
## Overview

The Nurse-Family Partnership (NFP; http://www.nursefamilypartnership.org) would like to know what effect it has on several birth outcomes, child health and development outcomes, mother's life course outcomes, and abuse outcomes.  As part of the Eric and Wendy Schmidt Data Science for Social Good summer fellowship (http://dssg.io), we used data from NFP and nationally representative datasets to estimate the effect NFP has on immunization and breastfeeding rates.  More information about our motivation and our process are available in our project [wiki] (https://github.com/dssg/nfp/wiki).

This directory contains the R code used to explore and analyze our data.  The datasets input into this analysis generally contained datasets we created by combining proprietary NFP data with data from national datasets.  See the data_preparation directory for the more information about this process.

Although the data used for these analyses is not public, our code is presented in the hope that it might provide a useful guide to anyone doing a similar project with different data.


## Sample Simulations: *example_simulations*

The "example_simulations" directory contains two scripts.  The first script, matching_examples.R, demonstrates the behavior of OLS, stratification, exact matching, and propensity-score matching on three increasingly complex datasets.  The second, PSM and complex surveys example.R, contains the beginnings of code that help determine whether Zanutto's (2006) (http://www.jds-online.com/v4-1) point about the necessity of using survey weights applies when the treatment group does not come from the complex survey.  This part of the analysis is not complete.


## Exploratory Analysis: *nfp_summary_plots.R* 

The file nfp_summary_plots.R contains the code for some basic exploratory analysis we did.  This analysis was conducted only within the data provided by NFP.  We wanted to get a sense for the population that participated in the program.  This analysis shows some of the distributions and correlations we explored.  Its contents also provide examples of charts prepared using R's ggplot2 library.


## Immunizations Analysis: *NIS_graphs.R and NIS_Analysis.R*

Our immunizations analysis used [propensity score matching] (http://faculty.smu.edu/Millimet/classes/eco7377/papers/rosenbaum%20rubin%2083a.pdf) (PSM).  PSM is a form of matching where cases are paired by their estimated probability of selection into treatment.  For example, income, age, and educational background plausibly affect whether a pregnant woman enrolls in NFP.  If we estimated the probability that each woman enrolls in NFP based on these characteristics (using, say, probit regression), then we could match an NFP enrollee with a 70% chance of enrolling with a non-enrollee with a 70% chance of enrolling.  Assuming we account for all the relevant factors that determine NFP enrollment, then the differences we observe between women in the program and women not in the program will on average be a good estimate of the program's effectiveness.  matching_examples.R demonstrates matching using an example where the explanatory ve ariables are independent, another where they are not, and a third where the treatment effect varies and selection into treatment depends on the treatment effect.  The script demonstrates ordinary linear regression, stratification (a generalization of matching), exact matching, and propensity-score matching and includes explanations for each step.  The last part, where the treatment effect varies, is not complete, but the first two parts are.  


## Breastfeeding Analysis: *NSCH_Analysis.R*

The NSCH_Analysis.R script works with data output from [NSCH_Prep.R] (https://github.com/dssg/nfp/tree/master/data_prepartion).  The prep script prepared two datasets that are used by NSCH_Analysis.R: 

1.  Read in as "breast", the first dataset contains a combined set of observations from NFP and NSCH manipulated to share a common set of variables.  The binary "treatment" variable indicates whether the observation originated in NFP's data (breast$treatment==1) or in the NSCH file (breast$treatment==0).  Only NSCH individuals meeting the eligibility criteria for NFP participation are included (children of first time mothers born in a comparable time period, to families make less than 200% of the federal poverty level), since these are the only valid matches to NFP participants.  This is the primary dataset for matching analysis.

2.  Read in as "pop", the second dataset includes the same variables as in "breast", but it includes exclusively NSCH observations, and all NSCH observations (even those that are not eligible to participate in NFP) are included.  This dataset is included for the production of population-level statistics (such as the rate of breastfeeding in the general population).  For more information about the logistics of working with complex surveys, see our [Methodology wiki] (https://github.com/dssg/nfp/wiki/Methodology).

The first and second sections of the NSCH_Analysis.R script explore the data and compare means across the NFP and NSCH populations, looking first at the demographics used for matching (Section 1) and then at the outcomes in question (Section 2).

Section 3 is the core of the matching analysis.
