library(googleVis)
library(tidyr)
library(ggplot2)

allCity2 = spread(allCity3, key = city, value = PM25)
allCity3 = group_by(allCity, date, city) %>% summarise(., Temp = mean(TEMP), PM25 = mean(mean_PM))   # dataframe for time plots

inputcity = "Beijing"

my_options = list(hAxis = "{title: 'Time'}", vAxis = "{title: 'PM 2.5 Level'}", 
                  explorer = "{actions: ['dragToZoom', 'rightClickToReset']}")
  
testplot = gvisLineChart(filter(allCity3, city == inputcity), xvar = 'date', yvar = 'PM25', options = my_options)
plot(testplot)

my_options2 = list(hAxis = "{title: 'Time'}", vAxis = "{title: 'Temperature (C)'}", 
                  explorer = "{actions: ['dragToZoom', 'rightClickToReset']}")
testplot2 = gvisLineChart(filter(allCity3, city == inputcity), xvar = 'date', yvar = 'Temp', options = my_options2)
plot(testplot2)
binw = 10
inputyear = 2010
inputcity = "Beijing"
inputTScale1 = 'day'
inputTScale2 = 'month'
inputTScale3 = 'season'
groupvec = c('season', 'month', 'day')
inputTScale1 == groupvec
groupvec[inputTScale1 == groupvec]

allCity4 = filter(allCity, city == inputcity, year == inputyear)    #dataframe for scatter plots, histogram
allcity5 = group_by(allCity4, month, day) %>% summarise(., PM25 = mean(mean_PM))

ggplot(allcity5, aes(x = PM25)) + geom_histogram(fill = 'blue', color = 'black', binwidth = binw)

testplot2 = gvisHistogram(allCity4[,c('mean_PM', 'city')])
plot(testplot2)
#function to choose grouping options for plot

if(inputTScale1 == 'day'){
    allCity5 = group_by(allCity4, season, month, day)
    }else{
      allCity5 = group_by(allCity4, season, month)
    }
inputData = 'temp'


allCity6 = summarise(allCity5, mean_Temp = mean(TEMP), mean_PM = mean(mean_PM))

allCity7 = allCity6[, c('mean_Temp', 'mean_PM')]
allCity7$PM_Spring = ifelse(allCity6$season == 1, allCity6$mean_PM, NA)
allCity7$PM_Summer = ifelse(allCity6$season == 2, allCity6$mean_PM, NA)
allCity7$PM_Fall = ifelse(allCity6$season == 3, allCity6$mean_PM, NA)
allCity7$PM_Winter = ifelse(allCity6$season == 4, allCity6$mean_PM, NA)
allCity7$mean_PM = NULL

testplot3 = gvisScatterChart(allCity7)
plot(testplot3)

start_date = as.Date('2011/01/01')#, '%Y-%m-%d')
end_date = as.Date('2013/02/03')#, '%Y-%m-%d')

start_date
#data format for map
allCity6 = (allCity %>% filter(., start_date <= date & date <= end_date) %>% group_by(., city) %>% summarise(., PM25 = mean(mean_PM))
            %>% mutate(.,latlong = case_when(city == 'Beijing' ~ '39.9042:116.4074', city == 'Chengdu' ~ '30.5728:104.0668', 
                                             city == 'Guangzhou' ~ '23.1291:113.2644', city == 'Shenyang' ~ '41.8057:123.4315',
                                             city == 'Shanghai' ~ '31.2304:121.4737') ))
start_date == allCity[1, 'date']
end_date > allCity[100, 'date']
testvec = c(start_date, end_date)
allCity[100, 'date'] >testvec[1]

M_options = list(region = "CN")
testplot4 = gvisGeoChart(allCity6, locationvar = 'latlong', colorvar = 'PM25', options = M_options)
plot(testplot4)

data("Andrew")
Andrew[]
gvisG


