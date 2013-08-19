require(ggplot2)

load("/mnt/data/NIS/immunizations_analysis.RData")

summary(immunizations)

# Matching: Income
results <- table(immunizations$income_recode, immunizations$treatment)
colnames(results) <- c("Not NFP", "NFP")
rownames(results) <- c("$0-7.5k", "$7.5-20k", "20-30k",
                       "$30-40k", "$40k+", "parents")


# Convert from table format to dataframe format
results_data <- data.frame(results)
names(results_data) = c("Income", "Enrollment", "Frequency")

# Remove information about participants living off of their parents because it is insignificant
results_data = results_data[results_data$Income != "parents",]

# Convert the frequency column to percentage
nfp_percent = results_data[results_data$Enrollment == "NFP",]$Frequency/sum(results_data[results_data$Enrollment == "NFP",]$Frequency)
not_nfp_percent = results_data[results_data$Enrollment == "Not NFP",]$Frequency/sum(results_data[results_data$Enrollment == "Not NFP",]$Frequency)
results_data$Percent = c(not_nfp_percent,nfp_percent)


## Side-by-side barcharts of income distribution for participants and non-participants
ggplot(results_data, aes(x = Income, y = Percent)) + geom_bar(aes(fill = Enrollment), stat = "identity") + facet_wrap(~ Enrollment, nrow = 1) + scale_y_continuous(labels = percent) +
  theme(axis.text.x = element_text(angle = 30, hjust = 1)) + ggtitle("Income Brackets by Enrollment")


# Same thing as before but for High School Graduation
results <- table(immunizations$HSgrad, immunizations$treatment)
rownames(results) <- c("Didn't Graduate HS", "HS grad")
colnames(results) <- c("Not NFP", "NFP")

# Convert from table to dataframe
results_data <- data.frame(results)
names(results_data) = c("HighSchoolGraduation", "Enrollment", "Frequency")

# Convert frequency to percentage
nfp_percent = results_data[results_data$Enrollment == "NFP",]$Frequency/sum(results_data[results_data$Enrollment == "NFP",]$Frequency)
not_nfp_percent = results_data[results_data$Enrollment == "Not NFP",]$Frequency/sum(results_data[results_data$Enrollment == "Not NFP",]$Frequency)
results_data$Percent = c(not_nfp_percent,nfp_percent)

# Side by side barcharts to compare education across participants and non-participants
ggplot(results_data, aes(x = HighSchoolGraduation, y = Percent)) + geom_bar(aes(fill = Enrollment), stat = "identity") + 
  facet_wrap(~ Enrollment, nrow = 1) + scale_y_continuous(labels = percent) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1)) + ggtitle("High School Graduation by Enrollment") +
  labs(x = "High School Graduation")


# Same as above but to compare marriage between datasets
results <- table(immunizations$married, immunizations$treatment)
rownames(results) <- c("Not Married", "Married")
colnames(results) <- c("Not NFP", "NFP")

# Converts from table to a dataframe
results_data <- data.frame(results)
names(results_data) = c("Marital", "Enrollment", "Frequency")

# Converts frequency to percentage
nfp_percent = results_data[results_data$Enrollment == "NFP",]$Frequency/sum(results_data[results_data$Enrollment == "NFP",]$Frequency)
not_nfp_percent = results_data[results_data$Enrollment == "Not NFP",]$Frequency/sum(results_data[results_data$Enrollment == "Not NFP",]$Frequency)
results_data$Percent = c(not_nfp_percent,nfp_percent)

# Side by side barcharts of marriage across both datasets
ggplot(results_data, aes(x = Marital, y = Percent)) + geom_bar(aes(fill = Enrollment), stat = "identity") + 
  facet_wrap(~ Enrollment, nrow = 1) + scale_y_continuous(labels = percent) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1)) + ggtitle("Marital Status by Enrollment") +
  labs(x = "Marital Status")


# Create a chart of child's gender
results <- table(immunizations$male, immunizations$treatment)
rownames(results) <- c("Female", "Male")
colnames(results) <- c("Not NFP", "NFP")

# Convert from table to dataframe
results_data <- data.frame(results)
names(results_data) = c("Gender", "Enrollment", "Frequency")

# Convert frequency to percentage
nfp_percent = results_data[results_data$Enrollment == "NFP",]$Frequency/sum(results_data[results_data$Enrollment == "NFP",]$Frequency)
not_nfp_percent = results_data[results_data$Enrollment == "Not NFP",]$Frequency/sum(results_data[results_data$Enrollment == "Not NFP",]$Frequency)
results_data$Percent = c(not_nfp_percent,nfp_percent)

# Side-by-side barcharts of gender by enrollment
ggplot(results_data, aes(x = Gender, y = Percent)) + geom_bar(aes(fill = Enrollment), stat = "identity") + 
  facet_wrap(~ Enrollment, nrow = 1) + scale_y_continuous(labels = percent) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1)) + ggtitle("Child's Gender by Enrollment") +
  labs(x = "Gender")

# Create chart of language spoken
results <- table(immunizations$language, immunizations$treatment)
colnames(results) <- c("Not NFP", "NFP")

# Convert from table from dataframe
results_data <- data.frame(results)
names(results_data) = c("Language", "Enrollment", "Frequency")

# Convert proportion to percent
nfp_percent = results_data[results_data$Enrollment == "NFP",]$Frequency/sum(results_data[results_data$Enrollment == "NFP",]$Frequency)
not_nfp_percent = results_data[results_data$Enrollment == "Not NFP",]$Frequency/sum(results_data[results_data$Enrollment == "Not NFP",]$Frequency)
results_data$Percent = c(not_nfp_percent,nfp_percent)

# Make plot of language spoken by enrollment
ggplot(results_data, aes(x = Language, y = Percent)) + geom_bar(aes(fill = Enrollment), stat = "identity") + 
  facet_wrap(~ Enrollment, nrow = 1) + scale_y_continuous(labels = percent) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1)) + ggtitle("Primary Language by Enrollment") +
  labs(x = "Language")

# Make a chart of mother's age
results <- table(immunizations$MothersAge, immunizations$treatment)
colnames(results) <- c("Not NFP", "NFP")
rownames(results) <- c("≤19 Years", "20-29 Years", "≥30 Years")

# Convert from table to dataframe
results_data <- data.frame(results)
names(results_data) = c("Age", "Enrollment", "Frequency")

# Convert frequency to percentage
nfp_percent = results_data[results_data$Enrollment == "NFP",]$Frequency/sum(results_data[results_data$Enrollment == "NFP",]$Frequency)
not_nfp_percent = results_data[results_data$Enrollment == "Not NFP",]$Frequency/sum(results_data[results_data$Enrollment == "Not NFP",]$Frequency)
results_data$Percent = c(not_nfp_percent,nfp_percent)

# Side-by-side barcharts of age by enrollment
ggplot(results_data, aes(x = Age, y = Percent)) + geom_bar(aes(fill = Enrollment), stat = "identity") + 
  facet_wrap(~ Enrollment, nrow = 1) + scale_y_continuous(labels = percent) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1)) + ggtitle("Mother's Age by Enrollment") +
  labs(x = "Age")


# Construct a char of race
results <- table(immunizations$Race, immunizations$treatment)
rownames(results) <- c("Hispanic", "White", "Black", "Other")
colnames(results) <- c("Not NFP", "NFP")

# Convert from table to dataframe
results_data <- data.frame(results)
names(results_data) = c("Race", "Enrollment", "Frequency")

# Convert frequency to percentage
nfp_percent = results_data[results_data$Enrollment == "NFP",]$Frequency/sum(results_data[results_data$Enrollment == "NFP",]$Frequency)
not_nfp_percent = results_data[results_data$Enrollment == "Not NFP",]$Frequency/sum(results_data[results_data$Enrollment == "Not NFP",]$Frequency)
results_data$Percent = c(not_nfp_percent,nfp_percent)

# Side-by-side barchart of race by enrollment
ggplot(results_data, aes(x = Race, y = Percent)) + geom_bar(aes(fill = Enrollment), stat = "identity") + 
  facet_wrap(~ Enrollment, nrow = 1) + scale_y_continuous(labels = percent) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1)) + ggtitle("Race by Enrollment") +
  labs(x = "Race") + opts(legend.position = "none")

