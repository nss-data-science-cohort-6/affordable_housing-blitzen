ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = "Housing Prices"),
  dashboardSidebar(
    
    
    
    sidebarMenu(
      menuItem("Sales Table", tabName = "sales_table", icon = icon("table")),
      menuItem("Map", icon = icon("list-alt"), tabName = "map"),
      menuItem('Scatter Plots', icon = icon("bar-chart-o"), tabName = "plots")
    ),
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
    )
  ),
  
  dashboardBody(
    
    tags$head(tags$style(HTML('
      .main-header .log;o {
        font-family: "Georgia", Times, "Times New Roman", serif;
        font-weight: bold;
        font-size: 24px
      }
    '))),
    
    tabItems(
      tabItem(tabName = "sales_table",
              h2("Table of Sales within 1 mile of Nearest Affordable Housing Development"),
              fluidRow(height = 100, width = 3,
                       dataTableOutput("filteredSales")
              )
              
      ),
      
      tabItem(tabName = "map",
              h2("Map of Sales within 1 mile of Nearest Affordable Housing Development"),
              fluidRow(
                height= 300,    
                width = 12,
                    title = "House sales within one mile of development",
                    leafletOutput("map_distance")
                
              )
      ),
      
      tabItem(tabName = "plots",
              h2("Scatter Plots"),
              fluidRow(
                #height= 300,    
                width = 12,
                plotOutput("actual_scatter")
                
              ),
              fluidRow(
                #height= 300,    
                width = 12,
                plotOutput("predicted_scatter")
                
              )
      )
    )
    
    
  )
)