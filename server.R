library(shinydashboard)

shinyServer(function(input,output){
    plotdf = filter(allCity, city == "Beijing", year == 2010) %>% group_by(., season, month, day) %>% 
        summarise(., mean_Temp = mean(TEMP), mean_PM = mean(mean_PM))
    plotdf2 = plotdf[, c('mean_Temp', 'mean_PM')]
    plotdf2$PM_Spring = ifelse(plotdf$season == 1, plotdf$mean_PM, NA)
    plotdf2$PM_Summer = ifelse(plotdf$season == 2, plotdf$mean_PM, NA)
    plotdf2$PM_Fall = ifelse(plotdf$season == 3, plotdf$mean_PM, NA)
    plotdf2$PM_Winter = ifelse(plotdf$season == 4, plotdf$mean_PM, NA)
    plotdf2$mean_PM = NULL
    
    output$scatter = renderGvis({ 
      gvisScatterChart(plotdf2)
    }) 
    
})
