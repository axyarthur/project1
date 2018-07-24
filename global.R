library(dplyr)
library(ggplot2)
library(stringr)
library(googleVis)
library(tidyr)

files = list.files(pattern="*.csv")           #generate list of file names
handle_each <- function(filename){
  city = str_extract(filename, "\\w+(?=PM)")  #extract city name from file
  temp = read.csv(filename)                   #read the file
  temp$city = city                            #add city information 
  return(temp)
}

dfs = lapply(files, handle_each)              #import all dataframes at once

#assign individual dataframes for each city
city1 = dfs[[1]]
city2 = dfs[[2]]
city3 = dfs[[3]]
city4 = dfs[[4]]
city5 = dfs[[5]]

#data preprocessing
#cacluate average 2.5 level across all sensors in a city, remove original individual PM2.5 sensor columns

city1p = mutate(city1, mean_PM = rowMeans(select(city1, starts_with("PM_")), na.rm = T)) %>% select(., -starts_with("PM_"))    
city2p = mutate(city2, mean_PM = rowMeans(select(city2, starts_with("PM_")), na.rm = T)) %>% select(., -starts_with("PM_")) 
city3p = mutate(city3, mean_PM = rowMeans(select(city3, starts_with("PM_")), na.rm = T)) %>% select(., -starts_with("PM_")) 
city4p = mutate(city4, mean_PM = rowMeans(select(city4, starts_with("PM_")), na.rm = T)) %>% select(., -starts_with("PM_")) 
city5p = mutate(city5, mean_PM = rowMeans(select(city5, starts_with("PM_")), na.rm = T)) %>% select(., -starts_with("PM_")) 

#combine all data into 1 data frame
allCity = rbind(city1p, city2p, city3p, city4p, city5p)

#remove NAs from PM2.5 column
allCity = filter(allCity, !is.na(mean_PM))           #data keeping all the time information, master df
allCity = mutate(allCity, date = paste(year, month, day, sep = '/'))   #get date information
allCity = mutate(allCity, date = as.Date(date, format = "%Y/%m/%d"))

#map options
#slider to choose time interval, calculate mean within time interval, intensity of PM2.5 in each city. button to advance / rewind time interval
#show text / shade on map depending on season 

#plots to make:
#PM2.5 time series (compare 5 citys, option to toggle plot for each city on/off)
#Temperature time series next to PM 2.5 

#plot options: choose time scale (day / month) group by season
#PM2.5 vs. temperature (scatter, choose year, choose city)
#PM2.5 vs. humidity (scatter, per city, choose year)
#PM2.5 vs. pressure (scatter, pre city, choose year)

#historgram of PM2.5 each year / each city 
#bar graph of mean / median PM25 level each year / each city

#39.9042° N, 116.4074° E Beijing
#31.2304° N, 121.4737° E Shanghai
#41.8057° N, 123.4315° E Shenyang
#30.5728° N, 104.0668° E Chengdu
#23.1291° N, 113.2644° E Guangzhou
