# Importing required libraries.
library(lubridate)
library(stringr)
# install.packages("dplyr")
library(dplyr)
library(data.table)
library(ggplot2)

#Read cleaned data
Dst <- read.csv("C:\\Project\\Data\\clean_data.csv", header = T, stringsAsFactors = F)

# Splitting Date and Time in two different Columns.
m<-str_split_fixed(Dst$Date, " ", 3)
Dst$Date <-m[,1]
Dst$Time <-m[,2]
Dst$AMPM <-m[,3]


#Splits the time as HH MM 
# split <- strsplit(Dst$Time, ":")

t<-str_split_fixed(Dst$Time, ":", 3)
Dst$Hour <-t[,1]
Dst$Minute <-t[,2]
# Dst$AMPM <-m[,3]


Dst$Hour <- as.numeric(Dst$Hour)
#Converts time in 24 hour format
condition <- Dst$AMPM == "PM"
Dst$Hour[condition] <- Dst$Hour[condition] + 12

v<-str_split_fixed(Dst$Date, "/", 3)
Dst$Month <-v[,1]

season <- c(rep("Winter", nrow(Dst)))

#Assigns the correct season according to the month
for(n in 1:nrow(Dst))
{
  if(Dst$Month[n] >= 3 && Dst$Month[n] < 6)
  {
    season[n] = "Spring"
  }
  else if (Dst$Month[n] >= 6 && Dst$Month[n] < 9)
  {
    season[n] = "Summer"
  }
  else if (Dst$Month[n] >= 9 && Dst$Month[n] < 12)
  {
    season[n] = "Fall"
  }
}

Dst <- cbind(Dst,season)

drops <- c("AMPM","Minute","")
Dst <- Dst[ , !(names(Dst) %in% drops)]

write.csv(Dst,"C:\\Project\\Data\\new_clean_data_final.csv")
