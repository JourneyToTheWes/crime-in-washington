library(shiny)
library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)

ucr.wa.crime.data <- read.csv("data/ucr.wa.crime.data.csv")
wa.average.crime <- read.csv("data/wa.average.crime.csv")

shinyServer(
  
  function(input, output) {
    output$bar <- renderPlotly({
      ucr.wa.crime.condensed.data <- select(ucr.wa.crime.data, year, county, UCR_AG_ASSLT, UCR_ARSON,
                                            UCR_BURGLARY, UCR_MURDER, UCR_MVT, UCR_RAPE, UCR_ROBBERY,
                                            UCR_THEFT)
      ucr.wa.crime.condensed.data.1 <- filter(ucr.wa.crime.condensed.data, ucr.wa.crime.condensed.data$county == input$county)
      
      ucr.wa.crime.condensed.data.2 <- filter(ucr.wa.crime.condensed.data.1, ucr.wa.crime.condensed.data.1$year == input$year)
      
      ucr.wa.crime.condensed.data.3 <- select(ucr.wa.crime.condensed.data.2, UCR_AG_ASSLT, UCR_ARSON, UCR_BURGLARY,
                                              UCR_MURDER, UCR_MVT, UCR_RAPE, UCR_ROBBERY, UCR_THEFT)
      
      pie.data <- gather(ucr.wa.crime.condensed.data.3, key = type.of.crime, value = crimes)
      
    bp <- plot_ly(pie.data, x = ~type.of.crime, y = ~crimes, type = "bar",
                  marker = list(color = c("#FF0000", "#B700FF", "#2B00FF", "#00FF5A", "#FFF700", 
                                  "#FFB300", "#FF00F3", "#00F7FF"))) %>%
      layout(title = "Crime Rate for Individual County and Year",
             xaxis = list(title = "Type of Crime"),
             yaxis = list(title = "Amount of Crime"))
    })
    
    output$pie <- renderPlotly({
        ucr.wa.crime.condensed.data <- select(ucr.wa.crime.data, year, county, UCR_AG_ASSLT, UCR_ARSON,
                                              UCR_BURGLARY, UCR_MURDER, UCR_MVT, UCR_RAPE, UCR_ROBBERY,
                                              UCR_THEFT)
        ucr.wa.crime.condensed.data.1 <- filter(ucr.wa.crime.condensed.data, ucr.wa.crime.condensed.data$county == input$county)

        ucr.wa.crime.condensed.data.2 <- filter(ucr.wa.crime.condensed.data.1, ucr.wa.crime.condensed.data.1$year == input$year)
        
        ucr.wa.crime.condensed.data.3 <- select(ucr.wa.crime.condensed.data.2, UCR_AG_ASSLT, UCR_ARSON, UCR_BURGLARY,
                                                      UCR_MURDER, UCR_MVT, UCR_RAPE, UCR_ROBBERY, UCR_THEFT)
        
        pie.data <- gather(ucr.wa.crime.condensed.data.3, key = type.of.crime, value = crimes)
        
        p <- plot_ly(pie.data, labels = ~type.of.crime, values = ~crimes, type = 'pie',
                     marker = list(line = list(color = '#FFFFFF', width = 0.5)),
                     insidetextfont = list(color = '#FFFFFF'),
                     textinfo = 'value+percent') %>%
          layout(title = 'Crime Rate for Individual County and Year',
                 xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                 yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    })
  }
)
