library(shinydashboard)

shinyServer(function(input,output, session){
    
  # organizing data for scatter plts
    plotdf = reactive({
        tempdf = (mutate(allCity, season = case_when(season == 1 ~"Spring", season == 2 ~ "Summer", season == 3 ~ "Fall", season == 4 ~ "Winter"))
                  %>% filter(., city == input$city, year == input$year))
        if(input$group == 'day'){    
          tempdf = group_by(tempdf, season, month, day)
        }else{
          tempdf = group_by(tempdf, season, month)
        }
        tempdf = (summarise(tempdf, DEWP = mean(DEWP), PRES = mean(PRES), TEMP = mean(TEMP), mean_PM = mean(mean_PM, na.rm = T)) %>% ungroup(.) 
                  %>% spread(., key = season, value = mean_PM) %>% select(., input$dataIn, one_of('Spring', 'Summer', 'Winter', 'Fall')))
      })
    
    #update select input for scatter plots
    observe({
        year_choice = unique(allCity[(!is.na(allCity$mean_PM) & allCity$city == input$city), 'year'])
        updateSelectizeInput(session = session, inputId = 'year', choices = year_choice)
    })
    
    #scatter plot options
    scatter_options = list(hAxis = "{title: 'Selected Variable'}", vAxis = "{title: 'PM 2.5 Level'}",
                           explorer = "{actions: ['dragToZoom', 'rightClickToReset']}", title = "Scatter Plots of PM 2.5",
                           width = 660, height = 320, legend = "{textStyle: {fontSize: 12}}")
    
    #output scatter plot
    output$scatter = renderGvis({ 
      gvisScatterChart(plotdf(), options = scatter_options)
    }) 
    
    #organizing data for time series plots
    plotdf2 = allCity %>% group_by(., date, city) %>% summarise(., Temp = mean(TEMP), PM25 = mean(mean_PM)) %>% spread(., key = city, value = PM25)
        
    #options for time plots
    time_options = list(hAxis = "{title: 'Time'}", vAxis = "{title: 'PM 2.5 Level', gridlines: {count: -1}}", 
                      explorer = "{actions: ['dragToZoom', 'rightClickToReset']}", width = 1200, height = 320, legend = "{textStyle:{fontSize: 12}}",
                      title = "PM 2.5 Over Time")
    
    #output for time series plots
    output$series = renderGvis({
      gvisLineChart(plotdf2, xvar = 'date', yvar = input$time_city, options = time_options) 
    })
    
    #organizing data for histogram
    plotdf3 = reactive({
      tempdf2 = filter(allCity, city == input$city, year == input$year) %>% group_by(., city, month, day) %>% summarise(., PM25 = mean(mean_PM, na.rm = T))
      tempdf2 = tempdf2[, 'PM25']
    })
    
    #options for historgram plot, 
    hist_options = list(hAxis = "{title: 'PM 2.5 Level'}", vAxis = "{title: 'Frequency'}", historgram = "{bucketSize: 10, maxValue: 500, 
                        lastBucketPercentile: 5}", title = "Histogram of Daily PM 2.5 Levels", width = 660, height = 320, 
                        legend = "{textStyle: {fontSize: 12}}")
    
    #output for historgram
    output$histogram = renderGvis({
      gvisHistogram(plotdf3(), options = hist_options)
    })
    
    #organizing data for mapping
    mapdf = reactive({
      dateVec = c(input$dates)
      (allCity %>% filter(., dateVec[1] <= date & date <= dateVec[2]) %>% group_by(., city) %>% summarise(., PM25 = mean(mean_PM)) 
      %>% mutate(.,latlong = case_when(city == 'Beijing' ~ '39.9042:116.4074', city == 'Chengdu' ~ '30.5728:104.0668', 
                                      city == 'Guangzhou' ~ '23.1291:113.2644', city == 'Shenyang' ~ '41.8057:123.4315',
                                      city == 'Shanghai' ~ '31.2304:121.4737')))
    })
    #options for Map
    map_options = list(region = "CN", width = 800, resolution = 'provinces', sizeAxis = "{minSize: 6}", 
                       colorAxis = "{colors: ['#F6CECE', '#8A0808']}")
    
    #output for GeoMap
    output$map = renderGvis({
      gvisGeoChart(mapdf(), locationvar = 'latlong', colorvar = 'PM25', hovervar = 'city', options = map_options)
      })
    
    #organizing data for bar chart
    bardf = allCity %>% group_by(., year, city) %>% summarise(., PM25 = mean(mean_PM, na.rm = T)) %>% spread(., key = city, value = PM25)
                  
    #options for bar chart
    bar_options = list(hAxis = "{ticks: [2010,2011,2012,2013,2014,2015], title: 'Year', format: 'decimal'}", legend = "{textStyle: {fontSize: 12}}", 
                       title = "Yearly Average PM 2.5 Levels", vAxis = "{title: 'PM 2.5 Levels'}", width = 1200)
    
    #output for bar chart
    output$barchart = renderGvis({
      gvisColumnChart(bardf, xvar = 'year', yvar = c(input$time_city), options = bar_options)
    })
})
