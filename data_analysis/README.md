# Data Analysis

## Overview

The [Nurse-Family Partnership] (http://www.nursefamilypartnership.org) (NFP) would like to know what effect it has on several birth outcomes, child health and development outcomes, mother's life course outcomes, and abuse outcomes.  We used data from NFP and nationally representative surveys to estimate the effect NFP has on immunization and breastfeeding rates.  More information about our motivation and our process are available in our project [wiki](https://github.com/dssg/nfp/wiki).

This directory contains the R code used to explore and analyze our data.  These analyses generally used a combination of proprietary datasets from NFP and publicly available datasets from nationally representative surveys.  See the `data_preparation` directory for details on how we brought these sources together.

Although the data used for these analyses is not public, our code is presented in the hope that it might provide a useful guide to anyone doing a similar project with different data.


## Sample Simulations: `example_simulations`

This directory contains scripts that demonstrate some of our methodological questions and challenges more simply through example scripts and simulations.  More information about each of the scripts is available from the folder's README.


## Exploratory Analysis: `nfp_summary_plots.R` and `NIS_graphs.R`

The file `nfp_summary_plots.R` contains the code for exploratory analysis we did using NFP data only.  We wanted to get a sense for the population that participated in the program.  This analysis shows some of the distributions and correlations we explored.  Its contents also provide examples of charts prepared using R's ggplot2 library.

The file `NIS_graphs.R` contains the code for exploratory analysis we did using data from both NFP and nationally representative surveys.  The script shows some of the distributions and correlations we explored and provide examples of charts prepared using R's ggplot2 library.


## Immunizations Analysis: `NIS_Analysis.R`

The `NIS_Analysis.R` script works with data output from [NIS_Prep.R](https://github.com/dssg/nfp/blob/master/data_preparation/NIS_Prep.R), which combines NFP administrative data with the 2008, 2009, and 2010 National Immunization Surveys.  The script plots the states that NFP operates in, 


## Breastfeeding Analysis: `NSCH_Analysis.R`

The `NSCH_Analysis.R` script works with data output from [NSCH_Prep.R](https://github.com/dssg/nfp/tree/master/data_prepartion).  The prep script prepared two datasets that are used by `NSCH_Analysis.R`: 

1.  **"breastfeeding_data.csv"** (read in as "breast") contains a combined set of observations from NFP and NSCH manipulated to share a common set of variables.  The binary "treatment" variable indicates whether the observation originated in NFP's data (breast$treatment==1) or in the NSCH file (breast$treatment==0).  Only NSCH individuals meeting the eligibility criteria for NFP participation are included (children of first time mothers born in a comparable time period, to families make less than 200% of the federal poverty level), since these are the only valid matches to NFP participants.  This is the primary dataset for matching analysis.

2.  **"breast_pop_comparison.csv"** (read in as "pop") includes the same variables as in "breast", but it includes exclusively NSCH observations, and all NSCH observations (even those that are not eligible to participate in NFP) are included.  This dataset is included for the production of population-level statistics (such as the rate of breastfeeding in the general population).  For more information about working with complex surveys, see our [Methodology wiki] (https://github.com/dssg/nfp/wiki/Methodology).

The first and second sections of the `NSCH_Analysis.R` script explore the data and compare means across the NFP and NSCH populations, looking first at the demographics used for matching (Section 1) and then at the outcomes in question (Section 2).

Section 3 is the core of the matching analysis.  It is divided into four different analyses.  The first two look at breastfeeding incidence (i.e., was the infant ever breastfed) while the second two look at breastfeeding duration (age of infant in weeks when breastfeeding stopped).  Within each outcome, the first analysis includes all available demographic variables for matching and the second analysis does not include the indicator for whether or not the mother had any post-high school education.  Because our data included scattered null values and our analyses required complete cases, each analysis begins with limiting the dataset to only the variables required for that analysis and then to only observations that were not null for any of those variables.  The most significant number of nulls were found in the higher education indicator variable, and each analysis was conducted with and without this variable to see whether the omitted observations biased the results.  For both outcomes, our estimates were robust to the change (i.e. including or omit the higher education variable and the additional observations did not meaningfully impact our estimates).

The first analysis in Section 3 is conducted using propensity score matching, as we did with immunizations.  However, because we were unable to match on income (as discussed in the [data preparation README] (https://github.com/dssg/nfp/tree/master/data_preparation)), our treatment and control observations were very similar demographically, and PSM matching was unable to improve balance between the two groups.  We switched to Coarsened Exact Matching (CEM) to correct this problem.  More information about this problem and CEM is available in [our wiki's methodology section] (https://github.com/dssg/nfp/wiki/Methodology).
