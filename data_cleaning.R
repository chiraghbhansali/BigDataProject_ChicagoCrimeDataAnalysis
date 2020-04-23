library(cluster)
library(factoextra)
library(dplyr)
library(datasets)
set.seed(20)

setwd("C:\\CrimeDataAnalysis-Master")
chicago.df <- read.csv("C:\\CrimeDataAnalysis-Master\\Crimes_-_2001_to_present.csv", header = T, stringsAsFactors = F)
#str(chicago.df)

sapply(chicago.df, function(x) sum(x=="" | is.na(x)))


sapply(chicago.df, function(x) sum(x=="" | is.na(x)))*100/nrow(chicago.df)

missing <- apply(chicago.df, 1, function(x) sum(x=="" | is.na(x)))/ncol(chicago.df)

head(missing[order(-missing)])

chicago.df <- chicago.df[missing == 0,]

jpeg('rplot1.jpg')
boxplot(chicago.df$X.Coordinate)
dev.off()
jpeg('rplot2.jpg')
boxplot(chicago.df$Y.Coordinate)
dev.off()

chicago.df <- filter(chicago.df, X.Coordinate != 0, Y.Coordinate != 0)

write.csv(chicago.df,"C:\\CrimeDataAnalysis-Master\\clean_data.csv")
