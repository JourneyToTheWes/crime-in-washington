library(shiny)
library(dplyr)
library(plotly)

wa.average.crime <- read.csv("data/wa.average.crime.csv")
wa.average.crime.select <- filter(wa.average.crime, county != 'STATE')

wa.average.select.crime<- filter(wa.average.crime, county != 'STATE') %>% select(county,Average_Population, Average_Assult,
                                 Average_Arson, Average_Burglary, Average_Murder, Average_MVT, 
                                 Average_Rape, Average_Robbery, Average_Theft)
server<- function(input, output){
    #make a plotly scatter plot for Average Population V. Average Total Crime in order to see correlation 
    output$plot <- renderPlotly({
      
      p <- plot_ly(wa.average.crime.select, x= ~Average_Population,y= ~Average_Total, size = ~Average_Population, color = ~Average_Population,
                   type = 'scatter')
      
      return(p)
    })
    
    output$plot1 <- renderPlot({
      
      p <- ggplot(data = wa.average.crime.select, mapping = aes(x = Average_Population, y = Average_Total))+
        geom_point()
      
      p <- p + geom_smooth(se = FALSE)
      
      return(p)
    })
    
    #make a plotly scatter plot, and use the user input for different visualization
    output$plot2 <- renderPlotly({
      
      p <- ggplot(data = wa.average.select.crime, mapping = aes(x = select_(wa.average.select.crime, input$choice), y = county, color = county)) +
        geom_point() +
        xlab('Crime Occurance')
      
      p <- ggplotly(p)
      
      return(p)
    })
    
    
  }

