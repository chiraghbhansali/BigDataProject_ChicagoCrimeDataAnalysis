# install.packages("SparkR")
# install.packages("cluster")
library(SparkR)
library(cluster)
library(factoextra)
library(dplyr)
library(datasets)

setwd("C:/Users/manis/Desktop/SEM2/BDT/Project/CrimeDataAnalysis-master/CrimeDataAnalysis-master")

set.seed(20)

#Reads the dataset into a dataframe
Dst <- read.csv("new_clean_data_final.csv", header = T)


#Makes sure the predictors and target variable are factors 
Dst$Primary.Type <- as.factor(Dst$Primary.Type)
Dst$Location.Description <- as.factor(Dst$Location.Description)
Dst$District <- as.factor(Dst$District)


#Categories the hours in 5 times of the day 
Dst$TimeOfTheDay <- "Night"

Dst$Hour <- as.numeric(Dst$Hour)

Dst[Dst$Hour >= 1 & Dst$Hour < 4,]$TimeOfTheDay <- 'Early Morning'
Dst[Dst$Hour >= 4 & Dst$Hour < 6,]$TimeOfTheDay <- 'Dawn'
Dst[Dst$Hour >= 6 & Dst$Hour < 12,]$TimeOfTheDay <- 'Morning'
Dst[Dst$Hour >= 12 & Dst$Hour < 16,]$TimeOfTheDay <- 'Afternoon'
Dst[Dst$Hour >= 16 & Dst$Hour < 21,]$TimeOfTheDay <- 'Evening'


Dst$TimeOfTheDay <- as.factor(Dst$TimeOfTheDay)

NewDst <- data.frame(Dst$Primary.Type, Dst$Location.Description, Dst$District, Dst$TimeOfTheDay, Dst$Season)
NewDst <- setNames(NewDst, c("PrimaryType", "LocationDescription", "District", "TimeOfTheDay", "Season"))

# new.for.corelation <- data.frame(NewDst$PrimaryType, NewDst$LocationDescription, NewDst$District, NewDst$TimeOfTheDay)
new.df <- filter(NewDst, NewDst$LocationDescription == "STREET" | NewDst$LocationDescription == "RESIDENCE" | NewDst$LocationDescription == "APARTMENT" | NewDst$LocationDescription == "SIDEWALK" | NewDst$LocationDescription == "OTHER" | NewDst$LocationDescription == "CTA TRAIN" | NewDst$LocationDescription == "BAR OR TAVERN" | NewDst$LocationDescription == "ALLEY" | NewDst$LocationDescription == "DEPARTMENT STORE" | NewDst$LocationDescription == "RESTRAURANT")
new.df <- filter(new.df, new.df$PrimaryType == "BATTERY" | new.df$PrimaryType == "NARCOTICS" |  new.df$PrimaryType == "THEFT")

write.csv(new.df,"C:/Users/manis/Desktop/SEM2/BDT/Project/CrimeDataAnalysis-master/CrimeDataAnalysis-master/prepareddata.csv", row.names = FALSE)

RFDst <- read.csv("prepareddata.csv", header = T, nrows = 200000)

RFDst$PrimaryType <- as.factor(RFDst$PrimaryType)
RFDst$LocationDescription <- as.factor(RFDst$LocationDescription)
RFDst$District <- as.factor(RFDst$District)
RFDst$TimeOfTheDay <- as.factor(RFDst$TimeOfTheDay)
RFDst$Season <- as.factor(RFDst$Season)

#Splits the dataset into train and test datasets in 80-20 proportion 
library(caTools)
# set.seed(123)
split = sample.split(RFDst, SplitRatio = 0.8)
Train = subset(RFDst, split == TRUE)
Test = subset(RFDst, split == FALSE)

v <- data.frame(Train$LocationDescription, Train$District, Train$TimeOfTheDay, Train$Season)
v <- setNames(v, c("LocationDescription", "District", "TimeofTheDay", "Season"))

library(randomForest)
set.seed(123)
classifier2 = randomForest(x = v,
                           y = Train$PrimaryType,
                           ntree = 500)

w <- data.frame(Test$LocationDescription, Test$District, Test$TimeOfTheDay, Test$Season)
w <- setNames(w, c("LocationDescription", "District", "TimeofTheDay", "Season"))

y_pred2 = predict(classifier2, newdata = w)

# Confusion matrix to check the accuray and precision.
cm2 = confusionMatrix(reference = Test$PrimaryType, data = y_pred2)
cm2
