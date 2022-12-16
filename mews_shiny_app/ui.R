ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = "Housing Prices"),
  dashboardSidebar(
    selectInput("li_addr",
                "Select an address:",
                choices = c("All",
                            li %>%
                              sort()
                )
    ),
    selectInput("ddlGroups",
                "Select Group:",
                choices = c("All",
                            groups_df %>%
                              sort()
                )
    ),
    
    
    sidebarMenu(
      menuItem("Map", #icon = icon("glyphicon"), 
               tabName = "Map",
               badgeLabel = "new", badgeColor = "green"),
      menuItem('scatter plot', tabName = "plots")
    )
  ),
  
  dashboardBody(
    fluidRow(
      box(width = 12,
          title = "House sales within one mile of development",
          leafletOutput("map_distance"))
      
    ),
    
    fluidRow(
      dataTableOutput("filteredSales")
    ),
    
    tags$head(tags$style(HTML('
      .main-header .logo {
        font-family: "Georgia", Times, "Times New Roman", serif;
        font-weight: bold;
        font-size: 24px;
      }
    '))),
    
    tabItems(
      tabItem(tabName = "Map",
              h2("Map")
      ),
      
      tabItem(tabName = "Plots",
              h2("Plots")
      )
    )

  )
)