library('shiny')
library('ggplot2')
library('dplyr')
library('plotly')
ucr.wa.crime.data <- read.csv('ucr.wa.crime.data.csv')
wa.average.crime <- read.csv('wa.average.crime.csv')



#UI

ui <- fluidPage(
  #Title Panel
  titlePanel(title = "Crime in Washington"),
  #Includes Sidebar Panel
  sidebarLayout(
    sidebarPanel(
      h5("Please Choose a County and Crime"),
      #Selects County 
      selectInput('county', label = 'County', choices  = c("ADAMS", "ASOTIN","BENTON","CHELAN","CLALLAM","CLARK","COLUMBIA",
                                                           "COWLITZ","DOUGLAS","FERRY","FRANKLIN","GARFIELD","GRANT","GRAYS HARBOR","ISLAND",
                                                           "JEFFERSON","KING","KITSAP","KITTITAS","KLICKITAT","LEWIS","LINCOLN","MASON",
                                                           "OKANOGAN","PACIFIC","PEND OREILLE","PIERCE","SAN JUAN","SKAGIT","SKAMANIA",
                                                           "SNOHOMISH","SPOKANE","STATE","STEVENS","THURSTON","WAHKIAKUM","WALLA WALLA","WHATCOM",
                                                           "WHITMAN","YAKIMA"), selected = "ADAMS"),
      #Selecting Which Crime
      selectInput('crime', label = "Crime", choices = c('Aggrevated_Assault', 'Arson', 'Burglary', 'Murder', 
                                                         'Motor_Vehicle_Theft', 'Rape', 'Robbery', 'Theft'), 
                                                          #Initial Pick of Crime
                                                          selected = 'Aggrevated_Assult')
      
    ),
    
    mainPanel(h5("Average Crime In a County. "),
              plotlyOutput("plot"),
              dataTableOutput('table')
    )
  )
)
