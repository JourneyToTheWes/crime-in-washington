library("shiny")
library("ggplot2")


shinyUI(fluidPage(
  titlePanel(title = "Crime in Washington"),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons("checkbox", label = "Choose Crime", choices = list("Average_Population", "Average_Arson"))
    ),
    
    mainPanel(
      plotOutput("plot", hover = "plot_hover"),
      dataTableOutput("table"),
      verbatimTextOutput("info")       
    )
  )
))
