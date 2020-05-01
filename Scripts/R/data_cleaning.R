library(cluster)
library(factoextra)
library(dplyr)
library(datasets)
set.seed(20)

chicago.df <- read.csv("C:\\Project\\Data\\Crimes_-_2001_to_present.csv", header = T, stringsAsFactors = F)
#str(chicago.df)

sapply(chicago.df, function(x) sum(x=="" | is.na(x)))


sapply(chicago.df, function(x) sum(x=="" | is.na(x)))*100/nrow(chicago.df)

missing <- apply(chicago.df, 1, function(x) sum(x=="" | is.na(x)))/ncol(chicago.df)

head(missing[order(-missing)])

chicago.df <- chicago.df[missing == 0,]

jpeg('C:\\Project\\Results\\Plots\\rplot1.jpg')
boxplot(chicago.df$X.Coordinate)
dev.off()
jpeg('C:\\Project\\Results\\Plots\\rplot2.jpg')
boxplot(chicago.df$Y.Coordinate)
dev.off()

chicago.df <- filter(chicago.df, X.Coordinate != 0, Y.Coordinate != 0)

jpeg('C:\\Project\\Results\\Plots\\rplot1.jpg')
boxplot(chicago.df$X.Coordinate)
dev.off()
jpeg('C:\\Users\\Project\\Results\\Plots\\rplot2.jpg')
boxplot(chicago.df$Y.Coordinate)
dev.off()

write.csv(chicago.df,"C:\\Project\\Data\\clean_data.csv")
