crimes.cluster.df <- read.csv("C:\\Project\\Data\\MostOccuringCrimesinClusters.csv", header = T, stringsAsFactors = F)

crimes.cluster.df[1,1] = 1
colnames(crimes.cluster.df) <- c("Cluster", "Primary", "Freq")
crimes.cluster.df$Cluster <- suppressWarnings(as.numeric(crimes.cluster.df$Cluster))
crimes.cluster.df$Primary <- as.factor(crimes.cluster.df$Primary)
crimes.cluster.df <- crimes.cluster.df[order(crimes.cluster.df$Cluster),]
test.res <- xtabs(crimes.cluster.df$Freq~crimes.cluster.df$Cluster+crimes.cluster.df$Primary, data=crimes.cluster.df)
png(file="C:\\Project\\Results\\Plots\\MostOccuringCrimesinClusters.png", width=800, height=407, units="mm", res=100)
heatmap.2(test.res, scale = "none", col = bluered(100), trace = "none", density.info = "none", key = T,
		  dendrogram="none",srtCol=90 , cexRow=1 , cexCol=0.8 , margins=c(30,30))
		  
dev.off()