# Nurse Family Partnership Immunization Study 

## Simulation Scripts

We used propensity score matching (PSM) (e.g. http://faculty.smu.edu/Millimet/classes/eco7377/papers/rosenbaum%20rubin%2083a.pdf) to estimate the Nurse-Family Partnership's impact on immunization rates. PSM is a form of matching where cases are paired by their estimated probability of selection into treatment. For example, income, age, and educational background plausibly affect whether a pregnant woman enrolls in NFP. If we estimated the probability that each woman enrolls in NFP based on these characteristics (using, say, probit regression), then we could match an NFP enrollee with a 70% chance of enrolling with a non-enrollee with a 70% chance of enrolling. Assuming we account for all the relevant factors that determine NFP enrollment, then the differences we observe between women in the program and women not in the program will on average be a good estimate of the program's effectiveness. 

matching_examples.R demonstrates average treatment effect (ATE) estimation using an example where the explanatory variables are independent and another where they are not and average treatment effect for the treated (ATET) and average treatment effect for the control (ATEC) estimation using an example where the treatment effect varies and influences whether the subject receives treatment (e.g. you are more likely to enroll in college if you would benefit from college).  The script shows estimates from ordinary linear regression, stratification (a generalization of matching), exact matching, and propensity-score matching, and it includes explanations for each step. 


