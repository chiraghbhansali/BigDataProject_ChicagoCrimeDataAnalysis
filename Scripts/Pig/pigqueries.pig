Crime_Data = LOAD '/u01/BDT_project/CrimeData/clean_data.csv' USING PigStorage(',')
AS (
nochar:chararray,
no:int, 
id:int, 
case_number:chararray, 
date_field:chararray,
block:chararray, 
IUCR:chararray, 
primary_type:chararray,
description:chararray, 
location_description:chararray,
arrest:chararray, 
domestic:chararray, 
beat:int,
district:int, 
ward:int, 
community_area:int,
fbi_code:chararray, 
x_coordinate:int, 
y_coordinate:int,
year:int, 
updated_on:chararray, 
latitude:double,
longitude:double, 
location:chararray,
time_of_day:chararray, 
hour_of_the_day:int, 
month:chararray,  
season:chararray);
DESCRIBE Crime_Data;



-- Analysis of a particular crime type(theft) over the years
all_theft = FILTER Crime_Data BY (primary_type == '"THEFT"');
grouped_theft = GROUP all_theft BY year;
count_crimes_per_year = foreach grouped_theft GENERATE group, COUNT(all_theft.id);
STORE count_crimes_per_year INTO '/user/PigResults/count_crimes_per_year' using PigStorage(',');
Y = LIMIT count_crimes_per_year 10;

-- What are the most occurring crimes in different seasons?
Group_By_Season_Primary = GROUP Crime_Data BY (season, primary_type);
Count_Season = foreach Group_By_Season_Primary GENERATE group, COUNT(Crime_Data.id);
STORE Count_Season INTO '/user/PigResults/count_season' using PigStorage(',');

-- Analysis of crimes with respect to locations and seasons
Group_By_Season_Location = GROUP Crime_Data BY (season,location_description);
Count_location = foreach Group_By_Season_Location GENERATE group, COUNT(Crime_Data.id);
STORE Count_location INTO '/user/PigResults/count_location' using PigStorage(',');

