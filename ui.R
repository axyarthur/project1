library(shinydashboard)

#UI page setup

shinyUI(dashboardPage(
          dashboardHeader(title = "Visualizing PM2.5 Levles in 5 Chinese Cities", titleWidth = 400),
          dashboardSidebar(sidebarUserPanel(name = "Arthur Yu"),
                   sidebarMenu(
                     menuItem("Overview", tabName = "overview", icon = icon('bars')),
                     menuItem("Map", tabName = "map", icon = icon('map')),
                     menuItem("Plots", tabName = 'plots', icon = icon('book')),
                     menuItem("Time Series", tabName = 'series', icon = icon('columns'))
                   ),
                   width = 200
          ),
          dashboardBody(
            tabItems(
              tabItem(tabName = "overview", 
                  fluidRow(
                      tabBox(id = 'bg tab', height = 250, 
                             tabPanel("Data"), 
                             tabPanel("Questions")
                             )
                           )
                      ),
              tabItem(tabName = "map",  #Page for the Map
                      fluidRow(
                        htmlOutput(outputId = 'map')
                        ),
                      fluidRow(
                        dateRangeInput("dates", label = h4("Date range"), start = '2010-01-01', end = '2010-12-31', 
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
                      )
            )
          )
))
