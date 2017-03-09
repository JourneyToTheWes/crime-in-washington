library(shiny)
library(dplyr)
library(plotly)

wa.average.crime <- read.csv("data/wa.average.crime.csv")
wa.average.crime.select <- filter(wa.average.crime, county != 'STATE')

wa.average.select.crime<- filter(wa.average.crime, county != 'STATE') %>% select(county,Average_Population, Average_Assult,
                                 Average_Arson, Average_Burglary, Average_Murder, Average_MVT, 
                                 Average_Rape, Average_Robbery, Average_Theft)
server<- function(input, output){

    output$plot <- renderPlotly({
      
      p <- plot_ly(wa.average.crime.select, x= ~Average_Population,y= ~Average_Total)
      
      return(p)
    })
    
    output$plot2 <- renderPlotly({
      name <- input$choice
      
      x<- select_(wa.average.select.crime, input$choice)
      
      p <- ggplot(data = wa.average.select.crime, mapping = aes(x = select_(wa.average.select.crime, input$choice), y = county)) +
        geom_point() +
        xlab('Occurance')
      
      p <- ggplotly(p)
      
      
      return(p)
    })
    
    
  }

