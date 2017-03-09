library(shiny)
library(ggplot2)

wa.average.select.crime<- select(wa.average.crime.select, Average_Population,Average_Assult,
                                 Average_Arson, Average_Burglary, Average_Murder, Average_MVT, 
                                 Average_Rape, Average_Robbery, Average_Theft)

ui <- fluidPage(
  titlePanel(title = "Crime in Washington"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      #make options for users to choose what time of crime data he/she would like to see
      selectInput('choice', label="Crime", choices= colnames(wa.average.select.crime))
      
    ),

    mainPanel(
      
      h5("Crime in Washington is different in each county."),
      
      p("The below visualization provides visualization for the number of crime occurances of each county in Washington State.
        The plot changes depending on user's choice of crime"),
      plotlyOutput('plot2', width = 1000, height = 800),
      
      #output as plotly and formating the graph
      p("The below visualization shows a plot of average population of each county in Wahsingont State
        V. average total crime in the county from year",em('2000'), "to year", em("2011"), ". The visualization
        allows us to see that there's is a", strong("directly proportional"), "correlation between the average population and
        the average crime. The more population in a county, the higer the crime rate"),
      plotlyOutput('plot', width = 1000, height = 500),
      
      p('The visualization below draws a line to show the correlation'),
      plotOutput('plot1')
      
      
    )
  )
)
