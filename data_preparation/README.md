# Data Preparation
 
To analyze the effectiveness of the Nurse-Family Partnership, we need data on NFP's clients as well as women and children not enrolled in the program.  We used nationally representative survey datasets to construct groups of mothers who are not enrolled in NFP but are on average the same as NFP mothers on a range of observable characteristics.  We used two primary comparison datasets, the National Immunization Survey (NIS) and the National Survey of Children's Health (NSCH).  We also did some exploratory work with the Current Population Survey (CPS) and the National Vital Statistics System (NVSS). This folder contains the scripts we used to analyze and modify our datasets.


More details about each of the datasets used by these scripts is available in [the Data section of our wiki](https://github.com/dssg/nfp/wiki/Data).

## Preparing NFP Data

Two of these scripts, convert_SAS_to_CSV.R and Merge_NFP_Data.R.  The first is a short script that demonstrates how a SAS dataset can be converted to a CSV.  The second script was written to combine a number of different datasets from NFP using common ID values.


## Preparing Data for Immunizations Analysis

FIPS_codes.py (converts FIPS values in NIS to state abbreviations, as in NIS)
NIS_Prep.R


## Preparing Data for Breastfeeding Analysis

The NSCH_Prep.R script shows how we prepared the data for our breastfeeding analysis.  (The next steps of this analysis are available in the [data_analysis directory](https://github.com/dssg/nfp/tree/master/data_analysis) as NSCH_Analysis.R.)


## Exploratory Analysis: The Current Population Survey and National Vital Statistical System

CPS_Prep.R

Finally, the NVSS_Prep.py script is designed to convert the National Vital Statistics Survey from a fixed width format into a comma-separated value (CSV) format.