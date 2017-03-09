library(shiny)
library(dplyr)
library(ggplot2)
library(tidyr)

ucr.wa.crime.data <- read.csv("data/ucr.wa.crime.data.csv")
wa.average.crime <- read.csv("data/wa.average.crime.csv")

shinyServer(
  
  function(input, output) {
    output$bar <- renderPlot({
        ucr.wa.crime.condensed.data <- select(ucr.wa.crime.data, year, county, UCR_AG_ASSLT, UCR_ARSON,
                                              UCR_BURGLARY, UCR_MURDER, UCR_MVT, UCR_RAPE, UCR_ROBBERY,
                                              UCR_THEFT)
        ucr.wa.crime.condensed.data.1 <- filter(ucr.wa.crime.condensed.data, ucr.wa.crime.condensed.data$county == input$county)

        ucr.wa.crime.condensed.data.2 <- filter(ucr.wa.crime.condensed.data.1, ucr.wa.crime.condensed.data.1$year == input$year)
        
        ucr.wa.crime.condensed.data.3 <- select(ucr.wa.crime.condensed.data.2, UCR_AG_ASSLT, UCR_ARSON, UCR_BURGLARY,
                                                      UCR_MURDER, UCR_MVT, UCR_RAPE, UCR_ROBBERY, UCR_THEFT)
        
        pie.data <- gather(ucr.wa.crime.condensed.data.3, key = type.of.crime, value = crimes)
        
        bp <- ggplot(data = pie.data) +
          aes(x = "", y = crimes, fill = type.of.crime) +
          geom_bar(width = 1, stat = "identity")
          scale_color_brewer(palette = "set3")
        bp 
        pie <- bp + coord_polar("y", start = 0, direction = -1) + xlab('Crime Amount') +
               ylab('Type of Crime') + labs(title = "Crime Rate for Individual County and Year", align = "center")
        pie
        
        
      
    })
  }
)
