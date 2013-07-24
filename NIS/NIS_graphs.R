require(ggplot2)

load("/mnt/data/NIS/immunizations_analysis.RData")

summary(immunizations)

# Matching: Income
results <- table(immunizations$income_recode, immunizations$treatment)
colnames(results) <- c("Not NFP", "NFP")
rownames(results) <- c("$0-7.5k", "$7.5-20k", "20-30k",
                       "$30-40k", "$40k+", "parents")
results_data <- data.frame(results)
names(results_data) = c("Income", "Enrollment", "Frequency")

results_data = results_data[results_data$Income != "parents",]

nfp_percent = results_data[results_data$Enrollment == "NFP",]$Frequency/sum(results_data[results_data$Enrollment == "NFP",]$Frequency)
not_nfp_percent = results_data[results_data$Enrollment == "Not NFP",]$Frequency/sum(results_data[results_data$Enrollment == "Not NFP",]$Frequency)

results_data$Percent = c(not_nfp_percent,nfp_percent)



require(ggplot2)

## Shadow Plot
#ggplot(results_data, aes(Income)) + geom_bar(subset 
 #                                          = .(Enrollment == "NFP"), aes(y = Percent, fill = Enrollment),  
  #                                         stat = "identity") + geom_bar(subset = .(Enrollment == "not NFP"),
   #                                       aes(y = -Percent, fill = Enrollment),  stat = "identity") +
  #ggtitle("Income Brackets by Enrollment") + scale_y_continuous(labels = percent)

## Side-by-side barcharts
ggplot(results_data, aes(x = Income, y = Percent)) + geom_bar(aes(fill = Enrollment), stat = "identity") + facet_wrap(~ Enrollment, nrow = 1) + scale_y_continuous(labels = percent) +
  theme(axis.text.x = element_text(angle = 30, hjust = 1)) + ggtitle("Income Brackets by Enrollment")

results <- table(immunizations$HSgrad, immunizations$treatment)
rownames(results) <- c("Didn't Graduate HS", "HS grad")
colnames(results) <- c("Not NFP", "NFP")
results_data <- data.frame(results)
names(results_data) = c("HighSchoolGraduation", "Enrollment", "Frequency")

nfp_percent = results_data[results_data$Enrollment == "NFP",]$Frequency/sum(results_data[results_data$Enrollment == "NFP",]$Frequency)
not_nfp_percent = results_data[results_data$Enrollment == "Not NFP",]$Frequency/sum(results_data[results_data$Enrollment == "Not NFP",]$Frequency)
results_data$Percent = c(not_nfp_percent,nfp_percent)

ggplot(results_data, aes(x = HighSchoolGraduation, y = Percent)) + geom_bar(aes(fill = Enrollment), stat = "identity") + 
  facet_wrap(~ Enrollment, nrow = 1) + scale_y_continuous(labels = percent) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1)) + ggtitle("High School Graduation by Enrollment") +
  labs(x = "High School Graduation")



results <- table(immunizations$married, immunizations$treatment)
rownames(results) <- c("Not Married", "Married")
colnames(results) <- c("Not NFP", "NFP")
results_data <- data.frame(results)
names(results_data) = c("Marital", "Enrollment", "Frequency")

nfp_percent = results_data[results_data$Enrollment == "NFP",]$Frequency/sum(results_data[results_data$Enrollment == "NFP",]$Frequency)
not_nfp_percent = results_data[results_data$Enrollment == "Not NFP",]$Frequency/sum(results_data[results_data$Enrollment == "Not NFP",]$Frequency)
results_data$Percent = c(not_nfp_percent,nfp_percent)

ggplot(results_data, aes(x = Marital, y = Percent)) + geom_bar(aes(fill = Enrollment), stat = "identity") + 
  facet_wrap(~ Enrollment, nrow = 1) + scale_y_continuous(labels = percent) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1)) + ggtitle("Marital Status by Enrollment") +
  labs(x = "Marital Status")


results <- table(immunizations$male, immunizations$treatment)
rownames(results) <- c("Female", "Male")
colnames(results) <- c("Not NFP", "NFP")

results_data <- data.frame(results)
names(results_data) = c("Gender", "Enrollment", "Frequency")

nfp_percent = results_data[results_data$Enrollment == "NFP",]$Frequency/sum(results_data[results_data$Enrollment == "NFP",]$Frequency)
not_nfp_percent = results_data[results_data$Enrollment == "Not NFP",]$Frequency/sum(results_data[results_data$Enrollment == "Not NFP",]$Frequency)
results_data$Percent = c(not_nfp_percent,nfp_percent)

ggplot(results_data, aes(x = Gender, y = Percent)) + geom_bar(aes(fill = Enrollment), stat = "identity") + 
  facet_wrap(~ Enrollment, nrow = 1) + scale_y_continuous(labels = percent) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1)) + ggtitle("Child's Gender by Enrollment") +
  labs(x = "Gender")


results <- table(immunizations$language, immunizations$treatment)
colnames(results) <- c("Not NFP", "NFP")
results_data <- data.frame(results)
#results_data = rbind(results_data[1,],results_data[3,],results_data[2,],results_data[4,],results_data[6,],results_data[5,])
names(results_data) = c("Language", "Enrollment", "Frequency")

nfp_percent = results_data[results_data$Enrollment == "NFP",]$Frequency/sum(results_data[results_data$Enrollment == "NFP",]$Frequency)
not_nfp_percent = results_data[results_data$Enrollment == "Not NFP",]$Frequency/sum(results_data[results_data$Enrollment == "Not NFP",]$Frequency)
results_data$Percent = c(not_nfp_percent,nfp_percent)

ggplot(results_data, aes(x = Language, y = Percent)) + geom_bar(aes(fill = Enrollment), stat = "identity") + 
  facet_wrap(~ Enrollment, nrow = 1) + scale_y_continuous(labels = percent) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1)) + ggtitle("Primary Language by Enrollment") +
  labs(x = "Language")


results <- table(immunizations$MothersAge, immunizations$treatment)
colnames(results) <- c("Not NFP", "NFP")
rownames(results) <- c("≤19 Years", "20-29 Years", "≥30 Years")
results_data <- data.frame(results)

names(results_data) = c("Age", "Enrollment", "Frequency")

nfp_percent = results_data[results_data$Enrollment == "NFP",]$Frequency/sum(results_data[results_data$Enrollment == "NFP",]$Frequency)
not_nfp_percent = results_data[results_data$Enrollment == "Not NFP",]$Frequency/sum(results_data[results_data$Enrollment == "Not NFP",]$Frequency)
results_data$Percent = c(not_nfp_percent,nfp_percent)

ggplot(results_data, aes(x = Age, y = Percent)) + geom_bar(aes(fill = Enrollment), stat = "identity") + 
  facet_wrap(~ Enrollment, nrow = 1) + scale_y_continuous(labels = percent) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1)) + ggtitle("Mother's Age by Enrollment") +
  labs(x = "Age")



results <- table(immunizations$Race, immunizations$treatment)
rownames(results) <- c("Hispanic", "White", "Black", "Other")
colnames(results) <- c("Not NFP", "NFP")
results_data <- data.frame(results)

names(results_data) = c("Race", "Enrollment", "Frequency")

nfp_percent = results_data[results_data$Enrollment == "NFP",]$Frequency/sum(results_data[results_data$Enrollment == "NFP",]$Frequency)
not_nfp_percent = results_data[results_data$Enrollment == "Not NFP",]$Frequency/sum(results_data[results_data$Enrollment == "Not NFP",]$Frequency)
results_data$Percent = c(not_nfp_percent,nfp_percent)

ggplot(results_data, aes(x = Race, y = Percent)) + geom_bar(aes(fill = Enrollment), stat = "identity") + 
  facet_wrap(~ Enrollment, nrow = 1) + scale_y_continuous(labels = percent) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1)) + ggtitle("Race by Enrollment") +
  labs(x = "Race") + opts(legend.position = "none")

