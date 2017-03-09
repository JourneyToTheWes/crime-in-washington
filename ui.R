library('shiny')
library('ggplot2')
library('dplyr')
library('plotly')
ucr.wa.crime.data <- read.csv('ucr.wa.crime.data.csv')
wa.average.crime <- read.csv('wa.average.crime.csv')




ui <- fluidPage(
  titlePanel(title = "Crime in Washington"),
  
  sidebarLayout(
    sidebarPanel(
      h5("Please Choose a County"),
      selectInput('county', label = 'County', choices  = c("ADAMS", "ASOTIN","BENTON","CHELAN","CLALLAM","CLARK","COLUMBIA",
                                                           "COWLITZ","DOUGLAS","FERRY","FRANKLIN","GARFIELD","GRANT","GRAYS HARBOR","ISLAND",
                                                           "JEFFERSON","KING","KITSAP","KITTITAS","KLICKITAT","LEWIS","LINCOLN","MASON",
                                                           "OKANOGAN","PACIFIC","PEND OREILLE","PIERCE","SAN JUAN","SKAGIT","SKAMANIA",
                                                           "SNOHOMISH","SPOKANE","STATE","STEVENS","THURSTON","WAHKIAKUM","WALLA WALLA","WHATCOM",
                                                           "WHITMAN","YAKIMA"), selected = "ADAMS"),
      checkboxInput("outliers", "Show outliers", FALSE)
      
    ),
    
    mainPanel(h5("Average Crime In a County. "),
              dataTableOutput('table'),
              plotOutput('plot', click = "plot_click"),
              verbatimTextOutput("info")
              
    )
  )
)

