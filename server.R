library(shinydashboard)

shinyServer(function(input,output){
    # organizing data for scatter plts
    plotdf = reactive({
        tempdf = filter(allCity, city == input$city, year == input$year)
        if(input$group == 'day'){    
          tempdf = group_by(tempdf, season, month, day)
        }else{
          tempdf = group_by(tempdf, season, month)
        }
        tempdf = summarise(tempdf, HUMI = mean(HUMI), PRES = mean(PRES), TEMP = mean(TEMP), mean_PM = mean(mean_PM)) 
        tempdf$PM_Spring = ifelse(tempdf$season == 1, tempdf$mean_PM, NA)
        tempdf$PM_Summer = ifelse(tempdf$season == 2, tempdf$mean_PM, NA)
        tempdf$PM_Fall = ifelse(tempdf$season == 3, tempdf$mean_PM, NA)
        tempdf$PM_Winter = ifelse(tempdf$season == 4, tempdf$mean_PM, NA)
        tempdf$mean_PM = NULL
        tempdf = tempdf[, c(input$dataIn, 'PM_Spring', 'PM_Summer', 'PM_Fall', 'PM_Winter')]
      })
    #scatter plot options
    scatter_options = list(hAxis = "{title: 'Selected Variable'}", vAxis = "{title: 'PM 2.5 Level'}",
                           explorer = "{actions: ['dragToZoom', 'rightClickToReset']}", title = "Scatter Plots of PM 2.5",
                           width = 720)
    
    #output scatter plot
    output$scatter = renderGvis({ 
      gvisScatterChart(plotdf(), options = scatter_options)
    }) 
    
    #organizing data for time series plots
    plotdf2 = allCity %>% group_by(., date, city) %>% summarise(., Temp = mean(TEMP), PM25 = mean(mean_PM)) %>% spread(., key = city, value = PM25)
        
    #options for time plots
    time_options = list(hAxis = "{title: 'Time'}", vAxis = "{title: 'PM 2.5 Level'}", 
                      explorer = "{actions: ['dragToZoom', 'rightClickToReset']}", width = 1400)
    
    #output for time series plots
    output$series = renderGvis({
      gvisLineChart(plotdf2, xvar = 'date', yvar = input$time_city, options = time_options) 
    })
    
    #organizing data for histogram
    plotdf3 = reactive({
      tempdf2 = filter(allCity, city == input$city, year == input$year) %>% group_by(., city, month, day) %>% summarise(., PM25 = mean(mean_PM))
      tempdf2 = tempdf2[, 'PM25']        
    })
    
    #options for historgram plot
    hist_options = list(hAxis = "{title: 'PM 2.5 Level'}", vAxis = "{title: 'Frequency'}", historgram = "{bucketSize: 10, maxValue: 500, 
                        lastBucketPercentile: 5}", title = "Histogram of Daily PM 2.5 Levels", width = 720)
    
    #output for historgram
    output$histogram = renderGvis({
      gvisHistogram(plotdf3(), options = hist_options)
    })
})
