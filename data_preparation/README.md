# Data Preparation
 
To analyze the effectiveness of the Nurse-Family Partnership, we need data on NFP's clients as well as women and children not enrolled in the program.  We used nationally representative survey datasets to construct groups of mothers who are not enrolled in NFP but are on average the same as NFP mothers on a range of observable characteristics.  We used two primary comparison datasets, the National Immunization Survey (NIS) and the National Survey of Children's Health (NSCH).  We also did some exploratory work with the Current Population Survey (CPS) and the National Vital Statistics System (NVSS). This folder contains the scripts we used to analyze and modify our datasets.


More details about each of the datasets used by these scripts is available in [the Data section of our wiki](https://github.com/dssg/nfp/wiki/Data).

## Preparing NFP Data

<<<<<<< HEAD
There are two scripts, `convert_SAS_to_CSV.R` and `Merge_NFP_Data.R`,it  that prepares NFP's data for merging with the survey data.  We received the NFP data in SAS format, so the first script converts those files to CSV format, which R can handle without installing special packages.  The second script combines several NFP datasets into one using common anonymized ID values.
=======
Two of these scripts, `convert_SAS_to_CSV.R` and `Merge_NFP_Data.R`.  The first is a short script that demonstrates how a SAS dataset can be converted to a CSV.  The second script was written to combine a number of different datasets from NFP using common ID values.
>>>>>>> 7d29e38fb8db99cc45d6b2b63fd057b4032f0baa


## Preparing Data for Immunizations Analysis

<<<<<<< HEAD
Two files bring the NFP and NIS data together.  `FIPS_codes.py` scrapes FIPS codes and converts them to the more natural postal state abbreviations.  `NIS_Prep.R` is more complex.  Here are the general steps:

 - Load NIS data for 2009, 2010, and 2011
 - Replicate NIS estimates to ensure data quality
 - Merge the NIS datasets
 - Generate immunization variables we need for analysis
 - Clean NIS data

NFP 
 - Load NFP data
 - Make variables across NIS and NFP compatible

MERGE NIS and NFP data
=======
`FIPS_codes.py` (converts FIPS values in NIS to state abbreviations, as in NIS)
`NIS_Prep.R`
>>>>>>> 7d29e38fb8db99cc45d6b2b63fd057b4032f0baa


## Preparing Data for Breastfeeding Analysis

The `NSCH_Prep.R` script shows how we prepared the data for our breastfeeding analysis.  (The next steps of this analysis are available in the [data_analysis directory](https://github.com/dssg/nfp/tree/master/data_analysis) as `NSCH_Analysis.R`.)  In this script, variables that will be used for matching or to measure the desired outcomes are recoded from their presentation in NSCH to match NFP's formatting.  In some cases, NFP variables are also recoded and new variables are created for the sake of clarity (for example, recoding child gender in both datasets into a binary variable for male).

After the necessary recodes have been completed, variables that are not shared between the two datasets are dropped, and then the remaining data is merged into a single dataset for analysis.  This final dataset includes a binary variable indicating treatment status (equal to 1 if the observation originally came from the NFP data and 0 if the observation originally came from NSCH).


## Exploratory Analysis: The Current Population Survey and National Vital Statistical System

`CPS_Prep.R`

<<<<<<< HEAD
Finally, the `NVSS_Prep.py` script is designed to convert the National Vital Statistics Survey from a fixed width format into a comma-separated value (CSV) format.
=======
Finally, the `NVSS_Prep.py` script is designed to convert the National Vital Statistics Survey from a fixed width format into a comma-separated value (CSV) format.
>>>>>>> 7d29e38fb8db99cc45d6b2b63fd057b4032f0baa
