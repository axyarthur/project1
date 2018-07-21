library(shinydashboard)

#UI page setup

shinyUI(dashboardPage(
          dashboardHeader(title = "Visualizing PM2.5 Levles in 5 Chinese Cities", titleWidth = 400),
          dashboardSidebar(sidebarUserPanel(name = "Arthur Yu"),
                   sidebarMenu(
                     menuItem("Overview", tabName = "overview", icon = icon('align-left')),
                     menuItem("Map", tabName = "map", icon = icon('map')),
                     menuItem("Time Series", tabName = 'series', icon = icon('chart-bar')),
                     menuItem("Plots", tabName = 'plots', icon = icon('chart-line'))
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
              tabItem(tabName = "map", 'Map'),
              tabItem(tabName = "series", 
                      fluidRow(htmlOutput(outputId = 'series')),
                      fluidRow(checkboxGroupInput("time_city", label = h4("Choose City"), 
                                                  choices = list("Beijing" = "Beijing", "Chengdu" = "Chengdu", "Guangzhou" = "Guangzhou",
                                                                 "Shanghai" = "Shanghai", "Shenyang" = "Shenyang"),
                                                  selected = "Beijing", inline = T, width = '450px')
                               
                      )
                      ),
              tabItem(tabName = "plots", 
                      fluidRow(column(width = 6,
                                      htmlOutput(outputId = 'scatter')),
                               column(width = 6,
                                      htmlOutput(outputId = 'histogram'))
                               ),
                      fluidRow(column(width = 3, 
                                      selectInput("dataIn", label = h4("PM 2.5 vs. "), 
                                           choices = list("Temperature" = 'TEMP', "Humidity" = "HUMI", "Pressure" = "PRES"), 
                                           selected = 'TEMP'),
                                      selectInput("year", label = h4("Choose Year"), 
                                           choices = list("2010" = 2010, "2011" = 2011, "2012" = 2012, "2013" = 2013, "2014" = 2014,
                                                          "2015" = 2015), 
                                           selected = 2010)),
                               column(width = 3, 
                                      selectInput("city", label = h4("Choose City"),
                                                  choices = list("Beijing" = "Beijing", "Guangzhou" = "Guangzhou", 
                                                  "Chengdu" = "Chengdu", "Shanghai" = "Shanghai", "Shenyang" = "Shenyang"),
                                                  selected = 'Beijing'),
                                      radioButtons("group", label = h4("Data Grouping"), choices = list("Daily" = 'day', "Monthly" = 'month'),
                                                   selected = 'day')
                                      ),
                               column(width = 3,
                                      numericInput("bin", label = h4("Bin Width"), value = 10)
                                 
                               )
                              )
                      
                      )
            )
          )
))
