library(ggplot2)
library(gPlots)


## What are the most occurring crimes in the city?
crime.freq.df <- read.csv("C:\\Project\\Results\\HiveResults\\MostOccuringCrimes.csv", header = F, stringsAsFactors = F)

colnames(crime.freq.df) <- c("crimes","crimes.frequency")

png(file="C:\\Project\\Results\\Plots\\MostOccuringCrimes.png", width=400, height=207, units="mm", res=100)

ggplot(crime.freq.df, aes(x=crimes, y= crimes.frequency))+
  xlab("CRIMES")+
  ylab("FREQUENCY") +
geom_bar(stat = "identity", fill="red") +
  coord_flip() +
  labs(title="Most Occuring Crimes", 
       subtitle="In City of Chicago") +
  theme(axis.text.x = element_text(vjust=0.6))


theme_set(theme_classic())

dev.off()


##How many crimes are being committed at a specific location? (e.g. street, residence)

location.freq.df  <- read.csv("C:\\Project\\Results\\HiveResults\\LocationWiseCrimes.csv", header = F, stringsAsFactors = F)
colnames(location.freq.df) <- c("Locations", "Frequency")

png(file="C:\\Project\\Results\\Plots\\LocationWiseCrimes.png", width=400, height=207, units="mm", res=100)

pie <- ggplot(location.freq.df, aes(x = "", y=Frequency, fill = factor(Locations))) + 
  geom_bar(width = 1, stat = "identity") +
  theme(axis.line = element_blank(), 
        plot.title = element_text(hjust=0.5)) + 
  labs(fill="Locations", 
       x=NULL, 
       y=NULL, 
       title="Location wise crime frequncy")

pie + coord_polar(theta = "y", start=0)

dev.off()

## Which crimes are being committed at a specific time of the day?

hours.crimes.df <- read.csv("C:\\Project\\Results\\HiveResults\\HourWiseCrimesV1.csv", header = F, stringsAsFactors = F)
hours.crimes.df[1,1] = 1
colnames(hours.crimes.df) <- c("AtHour", "CrimeType", "Freq")
hours.crimes.df$AtHour <- suppressWarnings(as.numeric(hours.crimes.df$AtHour))
hours.crimes.df$CrimeType <- as.factor(hours.crimes.df$CrimeType)
hours.crimes.df <- hours.crimes.df[order(hours.crimes.df$AtHour),]
test.res <- xtabs(hours.crimes.df$Freq~hours.crimes.df$AtHour+hours.crimes.df$CrimeType, data=hours.crimes.df)
png(file="C:\\Project\\Results\\Plots\\HourWiseCrimesV1.png", width=200, height=207, units="mm", res=100)
heatmap.2(test.res, scale = "none", col = bluered(100), trace = "none", density.info = "none", key = T,
		  dendrogram="none",srtCol=90 , cexRow=1 , cexCol=0.8 , margins=c(25,10))
		  
dev.off()

##Analysis of Location with respect to locations and time of the day
location.hours.df <- read.csv("C:\\Project\\Results\\HiveResults\\LocationNhourWiseCrimes.csv", header = F, stringsAsFactors = F)

location.hours.df[1,1] = 1
colnames(location.hours.df) <- c("Location", "Hour", "Freq")
location.hours.df$hour <- suppressWarnings(as.numeric(location.hours.df$Hour))
location.hours.df$Location <- as.factor(location.hours.df$Location)
location.hours.df <- location.hours.df[order(location.hours.df$hour),]
test.res <- xtabs(location.hours.df$Freq~location.hours.df$Hour+location.hours.df$Location, data=location.hours.df)
png(file="C:\\Project\\Results\\Plots\\LocationNhourWiseCrimes.png", width=800, height=207, units="mm", res=100)
heatmap.2(test.res, scale = "none", col = bluered(100), trace = "none", density.info = "none", key = T,
		  dendrogram="none",srtCol=90 , cexRow=1 , cexCol=0.8 , margins=c(30,30))
		  
dev.off()


