library(shinydashboard)

#UI page setup

shinyUI(dashboardPage(
          dashboardHeader(title = "Visualizing PM2.5 Levles in 5 Chinese Cities", titleWidth = 450),
          dashboardSidebar(sidebarUserPanel(name = "Arthur Yu"),
                   sidebarMenu(
                     menuItem("Overview", tabName = "overview", icon = icon('bars')),
                     menuItem("Map", tabName = "map", icon = icon('map')),
                     menuItem("Plots", tabName = 'plots', icon = icon('book')),
                     menuItem("Time Series", tabName = 'series', icon = icon('columns')),
                     menuItem("Conclusion", tabName = 'conclude', icon = icon('bars'))
                   ),
                   width = 200
          ),
          dashboardBody(
            tabItems(
              tabItem(tabName = "overview", 
                  fluidRow(tags$div(
                           h2("Overview"),
                           p("PM 2.5 are microparticles with a size around 2.5 or less micrometers in diameter. 
                                  They posed a high health hazard due to their ability to get deep inside people's lungs and even bloodstream. 
                                  China has had particular problems with air pollution in recent years due to the rapid industrialization and 
                                  lax air quality laws. This app aims to study the level of PM 2.5 in major cities in China."),
                           
                           h2(a(href = 'https://www.kaggle.com/uciml/pm25-data-for-five-chinese-cities', "Data")),
                           p("The dataset used provides measurements of PM 2.5 levels in Beijing, Chengdu, Guangzhou, Shanghai, and Shenyang, 
                             from 2010 to 2015. In addition to PM 2.5 levels, the dataset also provides information on temperature, air pressure, 
                             humidity, and precipitation. PM 2.5 levels were measured in 3-4 locations within each city. For this study, 
                             those measurements are averaged to yield single PM 2.5 level at each city"),
                           h2("Questions:"),
                           tags$ul(
                             tags$li("How do the PM 2.5 levels differ in different regions in China?"),
                             tags$li("Do other variables like temperature, air pressure, and humidity correlate with PM 2.5 levels?"),
                             tags$li("Do PM 2.5 levels change at different times of the year?"),
                             tags$li("Have PM 2.5 levels improve over the 5 year period?")
                           )
                           ))
                      ),
              tabItem(tabName = "map",  #Page for the Map
                      fluidRow(
                        htmlOutput(outputId = 'map')
                        ),
                      fluidRow(
                        dateRangeInput("dates", label = h4("Date range"), start = '2010-01-01', end = '2015-12-31', 
                                       min ='2010-01-01', max = '2015-12-31', startview = 'year'))
                      ),
              tabItem(tabName = "plots",    #Page for the scatter plots and histogram
                      fluidRow(column(width = 6,
                                      htmlOutput(outputId = 'scatter')),
                               column(width = 6,
                                      htmlOutput(outputId = 'histogram'))
                               ),
                      fluidRow(column(width = 3, 
                                      selectInput("dataIn", label = h4("PM 2.5 vs. "), 
                                           choices = list("Temperature" = 'TEMP', "Dew Point" = "DEWP", "Pressure" = "PRES"), 
                                           selected = 'TEMP'),
                                      selectInput("year", label = h4("Choose Year"), 
                                           choices = unique(allCity[, 'year']), 
                                           selected = 2010)),
                               column(width = 3, 
                                      selectInput("city", label = h4("Choose City"),
                                                  choices = unique(allCity[, 'city']),
                                                  selected = 'Beijing'),
                                      radioButtons("group", label = h4("Data Grouping"), choices = list("Daily" = 'day', "Monthly" = 'month'),
                                                   selected = 'day')
                                      )
                              )
                      
                      ),
              tabItem(tabName = "series", #Page for Time series plots
                      fluidRow(htmlOutput(outputId = 'series')),
                      fluidRow(htmlOutput(outputId = 'barchart')),
                      fluidRow(checkboxGroupInput("time_city", label = h4("Choose City"), 
                                                  choices = unique(allCity[, 'city']),
                                                  selected = "Beijing", inline = T, width = '450px'))
                      ),
              tabItem(tabName = 'conclude',
                      fluidRow( h2("Conclusions"),
                                tags$ul(
                                  tags$li("PM 2.5 levels in northern China (Beijing, Shenyang) is substantially worse than southern China
                                          (Guangzhou, Shanghai). Interior city such as Chengdu is also worse than costal cities like Guangzhou 
                                          and Shanghai."),
                                  tags$li("PM 2.5 levels are in general negatively correlated with temperature. In all cities, it spiked during 
                                          winter months."),
                                  tags$li("There is no clear relations between PM 2.5 level and Dew point and air pressure."),
                                  tags$li("Over the period of the dataset, there is improvement in PM 2.5 level in all cities studied.")
                                ),
                                h2("Future Work"),
                                tags$ul(
                                  tags$li("More quantitative analysis"),
                                  tags$li("Incorporating data from other areas, i.e. industry, climate, coal / oil usage rate")
                                )
                        
                      )
                      )
            )
          )
))
