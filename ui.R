library(shiny)
library(ggplot2)

shinyUI(fluidPage(
  titlePanel(title = "Crime in Washington"),
  
  sidebarLayout(
    sidebarPanel(
      h5("hello")
    ),
    
    mainPanel(h5("Crime in Washington is different in each county."),
      plotOutput('table')
    )
  )
))
