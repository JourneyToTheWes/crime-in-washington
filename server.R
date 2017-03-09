library(ggplot2)
library(tidyr)
library(plotly)
library(dplyr)
library(shiny)
library(leaflet)

wa.average.crime <- read.csv("data/wa.average.crime.csv")
wa.average.crime.select <- filter(wa.average.crime, county != 'STATE')
wa.average.select.crime<- filter(wa.average.crime, county != 'STATE') %>% select(county,Average_Population, Average_Assult,
                                                                                 Average_Arson, Average_Burglary, Average_Murder, Average_MVT, 
                                                                                 Average_Rape, Average_Robbery, Average_Theft)
ucr.wa.crime.data <- read.csv("data/ucr.wa.crime.data.csv")
wa.average.crime <- read.csv("data/wa.average.crime.csv")

# Gets all the necessary washington state county data
states <- map_data("state")
washington.state <- subset(states, region == "washington")
counties <- map_data("county")
wa.counties <- subset(counties, region == "washington")

# Combine county and average crime data
colnames(wa.counties)[6] <- "county"
wa.average.crime$county <- tolower(wa.average.crime$county)
all.data <- inner_join(wa.average.crime, wa.counties, by = "county")

# Variable to get rid of all unnecessary labels
ditch_the_axes <- theme(
  axis.text = element_blank(),
  axis.line = element_blank(),
  axis.ticks = element_blank(),
  panel.border = element_blank(),
  panel.grid = element_blank(),
  axis.title = element_blank()
)

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
      
      #make a plotly scatter plot for Average Population V. Average Total Crime in order to see correlation 
      output$plot <- renderPlotly({
        
        p <- plot_ly(wa.average.crime.select, x= ~Average_Population,y= ~Average_Total, size = ~Average_Population, color = ~Average_Population,
                     type = 'scatter')%>%
          layout(title = "Average Population V. Average Total Crime",
                 xaxis = list(title = "Average Population"),
                 yaxis = list(title = "Average Total Crime"))
        
        return(p)
      })
      
      output$plot1 <- renderPlot({
        
        p <- ggplot(data = wa.average.crime.select, mapping = aes(x = Average_Population, y = Average_Total))+
          geom_point() +
          xlab('Average Population') +
          ylab('Average Total Crime')
        
        p <- p + geom_smooth(se = FALSE)
        
        return(p)
      })
    
      #make a plotly scatter plot, and use the user input for different visualization
      output$plot2 <- renderPlotly({
        x <- select_(wa.average.select.crime, input$choice)
        p <- ggplot(data = wa.average.select.crime, mapping = aes(x = x, y = county, color = county)) +
          geom_point() +
          xlab('Crime Occurance')
        
        p <- ggplotly(p)
        
        return(p)
      })
      
  #Render a plotly display with boxplot to display min and max for each crime committed in each county
  output$plot3 <- renderPlotly({
    ucr.wa.crime.data.county <- filter(ucr.wa.crime.data, ucr.wa.crime.data$county == input$county2)
    #Changing the colnames to something understandable
    colnames(ucr.wa.crime.data.county) <- c('x','Year','County','Total Female Population','Total Male Population','Total Population','Aggrevated_Assault', 'Arson', 'Burglary', 'Murder', 'Motor_Vehicle_Theft', 'Rape', 'Robbery', 'Theft','Total_Crime')
    
    #If statement to determine which crime is being chosen
    if(input$crime == "Aggrevated_Assault"){
      p <- plot_ly(ucr.wa.crime.data.county, x = input$county2, y = ~Aggrevated_Assault, type = "box")
    } else if(input$crime == "Arson"){
      p <- plot_ly(ucr.wa.crime.data.county, x = input$county2, y = ~Arson, type = "box")
    } else if(input$crime == "Burglary"){
      p <- plot_ly(ucr.wa.crime.data.county, x = input$county2, y = ~Burglary, type = "box")
    } else if(input$crime == "Murder"){
      p <- plot_ly(ucr.wa.crime.data.county, x = input$county2, y = ~Murder, type = "box")
    } else if(input$crime == "Motor_Vehicle_Theft"){
      p <- plot_ly(ucr.wa.crime.data.county, x = input$county2, y = ~Motor_Vehicle_Theft, type = "box")
    } else if(input$crime == "Rape"){
      p <- plot_ly(ucr.wa.crime.data.county, x = input$county2, y = ~Rape, type = "box")
    } else if(input$crime == "Robbery"){
      p <- plot_ly(ucr.wa.crime.data.county, x = input$county2, y = ~Robbery, type = "box")
    } else if(input$crime == "Theft"){
      p <- plot_ly(ucr.wa.crime.data.county, x = input$county2, y = ~Theft, type = "box")
    }
  })
  
  #Filter Dataset by county for table
  filtered <- reactive({
    data <- ucr.wa.crime.data %>% 
      filter(county == input$county3)
  })
  
  #Create Table
  output$table.display <- renderDataTable({
    output$mytable <- renderText(input$county3)
    return(filtered())
  })
  
  filtered2 <- reactive({
    data <- wa.average.crime
    return(data)
  })
  
  output$plot4 <- renderPlot({
    
    # creates washington state map with county lines
    if(input$checkbox == "Average_Population"){
      p <- ggplot(data = washington.state, mapping = aes(x = long, y = lat, group = group)) + 
        coord_quickmap() + 
        geom_polygon(data = all.data, aes(fill = Average_Population), color = "white")+
        geom_polygon(color = "black", fill = NA)+
        theme_bw() +
        ditch_the_axes +
        scale_fill_gradient(trans = "log10", low = "white", high = "red")+
        labs(title = "Total Crime Average")
      return(p)
    } else {
      p <- ggplot(data = washington.state, mapping = aes(x = long, y = lat, group = group)) + 
        coord_quickmap() + 
        geom_polygon(data = all.data, aes(fill = Average_Arson), color = "white")+
        geom_polygon(color = "black", fill = NA)+
        theme_bw() +
        ditch_the_axes +
        scale_fill_gradient(trans = "log10", low = "white", high = "red")+
        labs(title = "Total Crime Average")
      return(p)
    }
  })
  
  output$info <- renderText({
    paste0("x = ", input$plot_hover$x, "\ny = ", input$plot_hover$y)
  })
  
  output$table <- renderDataTable({
    return(filtered2())
  })
})