## Important essential libararies
import numpy as np
import pandas as pd
from pyspark.ml.feature import VectorAssembler
from pyspark.ml.evaluation import ClusteringEvaluator
from pyspark.ml.clustering import KMeans
import matplotlib.pyplot as plt
import seaborn as sns

#Read the data and store it in a dataframe
chicagoDF = pd.read_csv("/u01/BDT_project/CrimeData/clean_data.csv")

# rename dataframe columns to remove '.' from there names
chicagoDF.rename(columns={'X.Coordinate':'xcor','Y.Coordinate':'ycor','Primary.Type':'primary'},inplace=True)

# create dataframe only with essential columns
mapDF = chicagoDF[['xcor','ycor','primary']]

## create spark dataframe
SparkMapdf = spark.createDataFrame(mapDF)

## prepare the dataframe for k means training
features=('xcor','ycor')
assembler = VectorAssembler(inputCols=features,outputCol="features")
mapDataset=assembler.transform(SparkMapdf)

#mapDataset.select("features").show(truncate=False)

## Train a kemeans model
kmeans = KMeans().setK(60).setSeed(1)
model = kmeans.fit(mapDataset)

#model.summary

# Make predictions
predictions = model.transform(mapDataset)

# Evaluate clustering by computing Silhouette score
evaluator = ClusteringEvaluator()
silhouette = evaluator.evaluate(predictions)
print("Silhouette with squared euclidean distance = " + str(silhouette))

# Evaluate clustering.
cost = model.computeCost(mapDataset)
print("Within Set Sum of Squared Errors = " + str(cost))

# print results
print("Cluster Centers: ")
ctr=[]
centers = model.clusterCenters()
for center in centers:
    ctr.append(center)
    print(center)


# Create dataframe from predictions
pandasDF=predictions.toPandas()
pandasDF.to_csv('/home/hadoop/pandasDF.csv')

label=pd.DataFrame(list(range(0,60)))
frames=(centers,label)
centerLabel=pd.concat(frames,axis=1)

## extract predictions from dataframe
y_means=pandasDF["prediction"]

## Visualize clustering results
plot=sns.lmplot(data=pandasDF,x='xcor',y='ycor',hue='cluster',fit_reg=False,legend=False,legend_out=False,height=7)
plot.fig.legend(ncol=2)
plot.savefig('/home/hadoop/KMeans.png')

##y_kmeans = model.predict(mapDataset)


#Extract most occurring crime for every cluster
from pyspark.sql.types import StructField, StructType, StringType, IntegerType
CrimeDataSchema = StructType([
StructField("id", IntegerType(), True),
StructField("xcor", IntegerType(), True),
StructField("ycor", IntegerType(), True),
StructField("primary", StringType(), True),
StructField("cluster", IntegerType(), True),
])
CrimeData = spark.read.format("csv")\
.schema(CrimeDataSchema)\
.load("/project/pandasDF.csv")

CrimeData.createOrReplaceTempView("CrimeDataView")

t=spark.sql('select primary,cluster,count(*) as cnt from CrimeDataView group by primary,cluster')
t.createOrReplaceTempView('tt')

y=spark.sql('select cluster,primary,cnt from tt where (cluster,cnt) in (select cluster,max(cnt) from tt group by cluster) order by cluster')
y.show(60)

## Create most occuring crime cluster.csv file