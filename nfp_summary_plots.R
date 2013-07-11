library(ggplot2)
library(plyr)
setwd("/mnt/data/csv_data")

nfp_demographics <- read.csv("nfp_demographics_expanded.csv", header = TRUE)

# Language
nfp_demographics$language_factor <- factor(nfp_demographics$Primary_language,
                                           labels = c("No Response", "English", "Other", "Spanish"),
                                           exclude = NULL)
nfp_demographics$language_factor <- factor(nfp_demographics$language_factor, levels = c("English", "Spanish", "Other", "No Response"))
language <- ggplot(nfp_demographics, aes(language_factor, fill=language_factor)) + geom_bar() + labs(x = "Primary Language", 
                                                                               y = "Count") +
  ggtitle("Language Spoken at Home") + theme(legend.position = "none")

language

# Age vs Smoking
nfp_demographics$smoker = 
  factor(nfp_demographics$pgsmoker, labels = c("Nonsmoker", "Smoker", "No Response"))

smoking_vs_age <- ggplot(nfp_demographics, aes(x=MomsAgeBirth,fill=smoker)) +
  geom_histogram(binwidth=1) + facet_wrap(~ smoker,ncol = 1) +
  labs(x = "Mother's Age at Birth") + ggtitle("Mothers Age vs Smoking")

smoking_vs_age

# Age vs. Prematurity Status
nfp_demographics$Premature_factor = 
  factor(nfp_demographics$premature, labels = c("Full Term", "Premature"))

med.fac = ddply(nfp_demographics, .(Premature_factor), function(.d)
  data.frame(x=median(.d$MomsAgeBirth, na.rm = TRUE)))

smoking_vs_premie <- ggplot(nfp_demographics, aes(x=MomsAgeBirth,fill=Premature_factor)) +
  geom_histogram(binwidth=1) + facet_wrap(~ Premature_factor,ncol =
                                            1) + geom_vline(data=med.fac, aes(xintercept=x), linetype =
                                                              "longdash") +
  labs(x = "Mother's Age at Birth", y = "Count") + ggtitle("Mothers Age vs Prematurity Status") + scale_fill_hue(name = "Prematurity Status")

smoking_vs_premie

# Relabel income brackets
nfp_demographics$income_description = 
  factor(nfp_demographics$INCOME, labels = 
           c("$0-$6,000", "$6,000-$12,000", "$12,000-$20,000", "$20,000-$30,000",
             "$30,000-$40,000","$40,000+", "Lives off of parents", "No Response"), exclude = NULL)

# Relabel race statistics
nfp_demographics$race_factor <- 
  factor(nfp_demographics$maternalrace, 
         labels = c("White", "Black","Latina","Other", "No Response"), exclude = NULL)

race_vs_income <- ggplot(nfp_demographics, aes(income_description,fill=race_factor)) + 
  geom_bar() + theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Income", y = "Count") + scale_fill_brewer(palette="YlOrRd",name="Race") +
  ggtitle("Income Brackets by Race")
race_vs_income

# Show divisions for people living off their parents
parents_data = nfp_demographics[nfp_demographics$income_description == "Lives off of parents",]

race_vs_income.parents <- ggplot(parents_data, aes(income_description,fill=race_factor)) + 
  geom_bar()  +
  labs(x = "Income", y = "Count") + scale_fill_brewer(palette="YlOrRd",name="Race") +
  ggtitle("Income Brackets by Race")
race_vs_income.parents

# Education
nfp_demographics$education_factor <- factor(nfp_demographics$HSGED, labels =
                                              c("Graduated High School", "Received GED",
                                                "Neither", "No Response"), exclude = NULL)

levels(nfp_demographics$education_factor) = c(levels(nfp_demographics$education_factor), c("4th Grade", "5th Grade", "6th Grade",
                                                                                           "7th Grade", "8th Grade", 
                                                                                           "9th Grade", "10th Grade", "11th Grade", "No Response"))

earlier_education_factor <- factor(nfp_demographics$HSGED_Last_Grade_1, labels = 
                                     c("4th Grade", "5th Grade", "6th Grade",
                                       "7th Grade", "8th Grade", 
                                       "9th Grade", "10th Grade", "11th Grade", "No Response"), exclude = NULL)

nfp_demographics$education_factor[nfp_demographics$education_factor == "Neither"] = earlier_education_factor[nfp_demographics$education_factor == "Neither"]

nfp_demographics$education_factor <- factor(nfp_demographics$education_factor, levels= c("4th Grade", "5th Grade", "6th Grade", "7th Grade",
                                              "8th Grade", "9th Grade", "10th Grade", "11th Grade",
                                              "Received GED", "Graduated High School", "No Response"))

nfp_demographics$education_factor[nfp_demographics$education_factor == "Neither"] = earlier_education_factor[nfp_demographics$education_factor == "Neither"]

education <- ggplot(nfp_demographics, aes(education_factor)) + geom_bar(fill="green") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) + labs(x = "Education Received", y = "Count") + ggtitle("Highest Pre-College Education")

education

# Marital Status
nfp_demographics$marital_factor <- factor(nfp_demographics$marital_status,
                                          labels = c("Not Married", "Married", "No Response"),
                                          exclude = NULL)

race_vs_marriage <- ggplot(nfp_demographics, aes(race_factor, fill=marital_factor)) + geom_bar() + 
  theme(axis.text.x = element_text(angle = 20, hjust = 1)) + labs(x = "Race", y = "Count") +
  ggtitle("Race vs. Marital Status") + scale_fill_hue(name = "Marital Status")
race_vs_marriage





