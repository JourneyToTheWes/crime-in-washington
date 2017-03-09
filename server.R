library(shiny)
library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)

ucr.wa.crime.data <- read.csv("data/ucr.wa.crime.data.csv")
wa.average.crime <- read.csv("data/wa.average.crime.csv")
colnames(ucr.wa.crime.data)
shinyServer(
  
  function(input, output) {
    output$bar <- renderPlotly({
        
      # Creates a new data frame, ucr.wa.crime.condensed.data, removing the "X" column, any population column and "UCR_TOTAL".
      # The other condensed data frames are created filters the data frame into a new data frame giving the specific year and
      # county the user chooses. Column names are modified to be more readable. 
      ucr.wa.crime.condensed.data <- select(ucr.wa.crime.data, year, county, UCR_AG_ASSLT, UCR_ARSON,
                                            UCR_BURGLARY, UCR_MURDER, UCR_MVT, UCR_RAPE, UCR_ROBBERY,
                                            UCR_THEFT)
      ucr.wa.crime.condensed.data.1 <- filter(ucr.wa.crime.condensed.data, ucr.wa.crime.condensed.data$county == input$county)
      ucr.wa.crime.condensed.data.2 <- filter(ucr.wa.crime.condensed.data.1, ucr.wa.crime.condensed.data.1$year == input$year)
      ucr.wa.crime.condensed.data.3 <- select(ucr.wa.crime.condensed.data.2, UCR_AG_ASSLT, UCR_ARSON, UCR_BURGLARY,
                                              UCR_MURDER, UCR_MVT, UCR_RAPE, UCR_ROBBERY, UCR_THEFT)
      colnames(ucr.wa.crime.condensed.data.3) <- c("Aggragated Assault", "Arson", "Burglary", "Murder", "Motor Vehicle Theft", 
                                                   "Rape", "Robbery", "Theft")
      
      # Gathers the data ucr.wa.crime.condensed.data.3 of one row and makes it into two columns one with types of crimes
      # and it's corresponding amount of crimes in the next column.
      pie.data <- gather(ucr.wa.crime.condensed.data.3, key = type.of.crime, value = crimes)
      
      # Using plotly a bar chart is graphed with type of crime on the x axis and the crime amount on the y axis.
      # Colors are different for each crime and labels are given for title and axis. Plotly allows the users to 
      # hover over the bar chart and see each crime and the amount of crimes committed for that crime. 
      bp <- plot_ly(pie.data, x = ~type.of.crime, y = ~crimes, type = "bar",
                    marker = list(color = c("#FF0000", "#B700FF", "#2B00FF", "#00FF5A", "#FFF700", 
                                  "#FFB300", "#FF00F3", "#00F7FF"),
                                  line = list(color = 'rgb(8, 48, 10, 7)', width = 1.5))) %>%
      layout(title = "Crime Rate for Individual County and Year",
             xaxis = list(title = "Type of Crime"),
             yaxis = list(title = "Amount of Crime"))
    })
    
    output$pie <- renderPlotly({
      
      # Creates a new data frame, ucr.wa.crime.condensed.data, removing the "X" column, any population column and "UCR_TOTAL".
      # The other condensed data frames are created filters the data frame into a new data frame giving the specific year and
      # county the user chooses. Column names are modified to be more readable.   
      ucr.wa.crime.condensed.data <- select(ucr.wa.crime.data, year, county, UCR_AG_ASSLT, UCR_ARSON,
                                            UCR_BURGLARY, UCR_MURDER, UCR_MVT, UCR_RAPE, UCR_ROBBERY,
                                            UCR_THEFT)
      ucr.wa.crime.condensed.data.1 <- filter(ucr.wa.crime.condensed.data, ucr.wa.crime.condensed.data$county == input$county)
      ucr.wa.crime.condensed.data.2 <- filter(ucr.wa.crime.condensed.data.1, ucr.wa.crime.condensed.data.1$year == input$year)
      ucr.wa.crime.condensed.data.3 <- select(ucr.wa.crime.condensed.data.2, UCR_AG_ASSLT, UCR_ARSON, UCR_BURGLARY,
                                              UCR_MURDER, UCR_MVT, UCR_RAPE, UCR_ROBBERY, UCR_THEFT)
      colnames(ucr.wa.crime.condensed.data.3) <- c("Aggragated Assault", "Arson", "Burglary", "Murder", "Motor Vehicle Theft", 
                                                   "Rape", "Robbery", "Theft")
        
      # Gathers the data ucr.wa.crime.condensed.data.3 of one row and makes it into two columns one with types of crimes
      # and it's corresponding amount of crimes in the next column.
      pie.data <- gather(ucr.wa.crime.condensed.data.3, key = type.of.crime, value = crimes)
      
      # Using plotly a pie chart is graphed with label of each pie slice being the type of crime and values of each 
      # of those slices being the crime amount. Text in each slice is displayed in white with the amount of crime and percentage
      # out of 100%. A line outlines each pie slice to better distinguish where the pie slice breaks at.  Plotly allows the user
      # to hover over each pie slice and see the type of crime and statistics about it. 
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
