library(shiny)
library(ggplot2)

ucr.wa.crime.data <- read.csv("data/ucr.wa.crime.data.csv")
wa.average.crime <- read.csv("data/wa.average.crime.csv")

shinyUI(fluidPage(
  titlePanel(title = "Crime in Washington"),
  
  sidebarLayout(
    sidebarPanel(
      h5("hello"),
      selectInput('county', 'County', ucr.wa.crime.data$county),
      selectInput('year', 'Year',  ucr.wa.crime.data$year)
    ),
    
    mainPanel(h5("Crime in Washington is different in each county."),
      plotOutput('bar')        
    )
  )
))
