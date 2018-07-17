library(readr)
library(dplyr)
library(ggplot2)

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
city1p = mutate(city1, mean_PM = rowMeans(select(city1, starts_with("PM_")), na.rm = T))   # calculate average PM2.5 level across all sensors in a city


