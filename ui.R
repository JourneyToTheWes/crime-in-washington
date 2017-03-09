library(shiny)
library(ggplot2)
library(plotly)

ucr.wa.crime.data <- read.csv("data/ucr.wa.crime.data.csv")
wa.average.crime <- read.csv("data/wa.average.crime.csv")

shinyUI(fluidPage(
  titlePanel(title = "Crime in Washington"),
  
  sidebarLayout(
    sidebarPanel(
      strong(h5("Bar Graph & Pie Chart Widgets")),
      selectInput('county', 'County', ucr.wa.crime.data$county, selected = ucr.wa.crime.condensed.data$county == "ADAMS"),
      selectInput('year', 'Year',  ucr.wa.crime.data$year, selected = ucr.wa.crime.condensed.data$year == "2000")
    ),
    
    mainPanel(h4("Crime in Washington is different in each county."),
      tabsetPanel(type = "tabs",
        tabPanel("Bar Graph", h4("Washington County Crime Rates"), 
                              tags$em(h5("This bar graph displays the crime rates given the individual county and year
                                          in Washington.")),
                 plotlyOutput('bar')),
        tabPanel("Pie Chart", h4("Washington County Crime Rates"),
                            tags$em(h5("This pie chart displays the crime rates given the individual county and year
                                       in Washington.")),
                 plotlyOutput('pie')
        )
      )
    )
  )
))
