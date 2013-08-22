# Data Analysis

## Example and Simulation Scripts

This folder contains scripts that demonstrate some of our methodological questions and challenges more simply.

`PSM_Script.R` is a rough overview of using the matching package in R - the inputs, commands, and general structure needed.

`matching_examples.R` demonstrates average treatment effect (ATE) estimation using an example where the explanatory variables are independent and another where they are not as well as average treatment effect for the treated (ATET) and average treatment effect for the control (ATEC) estimation using an example where selection into treatment depends on treatment effect (e.g. you are more likely to enroll in college if you would benefit from college).  The script shows estimates from ordinary linear regression, stratification (a generalization of matching), exact matching, and propensity-score matching, and it includes explanations for each step. 

`PSM and complex surveys example.R` contains the beginning of code that can help understanding about whether [Zanutto's (2006)](http://www.jds-online.com/v4-1) point about the necessity of using survey weights post-PSM is valid when only one group -- in this case the control group -- comes from a complex survey.  This analysis will continue past the end of the Data Science for Social Good fellowship.
