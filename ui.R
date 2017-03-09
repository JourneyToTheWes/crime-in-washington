library(shiny)
library(ggplot2)

crime.total <- range(wa.average.crime$Average_Total)
pop <- range(wa.average.crime$Average_Population)
wa.average.select.crime<- select(wa.average.crime.select, Average_Population,Average_Assult,
                                 Average_Arson, Average_Burglary, Average_Murder, Average_MVT, 
                                 Average_Rape, Average_Robbery, Average_Theft)

ui <- fluidPage(
  titlePanel(title = "Crime in Washington"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput('choice', label="Crime", choices= colnames(wa.average.select.crime))
      
    ),

    mainPanel(
      
      h5("Crime in Washington is different in each county."),
      
      plotlyOutput('plot'),
      
      plotlyOutput('plot2')
    )
  )
)
