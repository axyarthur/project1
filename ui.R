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
                      tabBox(title = "Backgroun Information", id = 'bg tab', height = 250, 
                             tabPanel("Data"), 
                             tabPanel("Questions")
                             )
                
                           )
                      ),
              tabItem(tabName = "map", 'Map'),
              tabItem(tabName = "series", 'Time Series'),
              tabItem(tabName = "plots", 'Plots Here')
            )
          )
)
)
