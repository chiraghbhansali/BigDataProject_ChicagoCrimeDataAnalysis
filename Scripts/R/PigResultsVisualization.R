library(ggplot2)
library(gplots)



### What are the most occurring crimes in different seasons?
crimes.by.season <- read.csv("C:\\Project\\Results\\PigResults\\crime_per_season_per_type.csv", header = F, stringsAsFactors = F)
colnames(crimes.by.season) <- c("Season", "Crime", "Freq")
crimes.by.season$Season <- as.factor(crimes.by.season$Season)
crimes.by.season$Crime <- as.factor(crimes.by.season$Crime)
crimes.by.season <- crimes.by.season[order(crimes.by.season$Season),]
test.res <- scale(xtabs(crimes.by.season$Freq~crimes.by.season$Season+crimes.by.season$Crime, data=crimes.by.season))
png(file="C:\\Project\\Results\\plots\\CrimesPerSeasonPerType.png", width=400, height=207, units="mm", res=100)
heatmap.2(test.res, scale = "none", col = bluered(100), trace = "none", density.info = "none", key = T,
		  dendrogram="none",srtCol=90 , cexRow=1 , cexCol=0.8 , margins=c(20,20))

dev.off()


## Analysis of crimes with respect to locations and seasons
locations.by.season <- read.csv("C:\\Project\\Results\\PigResults\\crime_per_season_per_location.csv", header = F, stringsAsFactors = F)
colnames(locations.by.season) <- c("Season", "Location", "Freq")
locations.by.season$Season <- as.factor(locations.by.season$Season)
locations.by.season$Location <- as.factor(locations.by.season$Location)
locations.by.season <- locations.by.season[order(locations.by.season$Season),]
test.res <- scale(xtabs(locations.by.season$Freq~locations.by.season$Season+locations.by.season$Location, data=locations.by.season))
png(file="C:\\Project\\Results\\plots\\CrimesPerSeasonPerLocation.png", width=1000, height=207, units="mm", res=80)
heatmap.2(test.res, scale = "none", col = bluered(100), trace = "none", density.info = "none", key = T,
		  dendrogram="none",srtCol=90 , cexRow=1 , cexCol=0.8 , margins=c(26,26))

		  
dev.off()

## Analysis of a particular crime type(theft) over the years
theft.all <- read.csv("C:\\Project\\Results\\PigResults\\theft_per_year.csv", header = F, stringsAsFactors = F)
colnames(theft.all) <- c("Year","Freq")
png(file="C:\\Project\\Results\\plots\\TheftperYEar.png", width=300, height=207, units="mm", res=80)
ggplot(theft.all, aes(x=theft.all$Year, y= theft.all$Freq))+
  xlab("Year")+
  ylab("FREQUENCY") +
  geom_bar(stat = "identity", fill="blue") +
  coord_flip() +
  labs(title="Most theft Occurrences By Year", 
       subtitle="In City Of Chicago") +
  theme(axis.text.x = element_text( vjust=0.6))
  
  dev.off()

