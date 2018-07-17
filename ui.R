library(shinydashboard)

#UI page setup

shinyUI(dashboardPage(
          dashboardHeader(title = "Visualizing PM2.5 Levles in 5 Chinese Cities", titleWidth = 400),
          dashboardSidebar(sidebarUserPanel(name = "Arthur Yu"),
                   sidebarMenu(
                     menuItem("Overview", tabName = "overview", icon = icon('align-left')),
                     menuItem("Map", tabName = "map", icon = icon('map'))
                   ),
                   width = 200
          ),
          dashboardBody(
            tabItems(
              tabItem(tabName = "overview", 'Text'),
              tabItem(tabName = "map", 'Map')
            )
          )
)
)
