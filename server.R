library(shiny)
library(dplyr)

ucr.wa.crime.data <- read.csv("ucr.wa.crime.data.csv")
wa.average.crime <- read.csv("wa.average.crime.csv")
View(ucr.wa.crime.data)
server <-function(input, output){
  #Filter Dataset by county for table
  filtered <- reactive({
    data <- ucr.wa.crime.data %>% 
      filter(county == input$county)
  })
  #Render a plotly display with boxplot to display min and max for each crime committed in each county
  output$plot <- renderPlotly({
    ucr.wa.crime.data.county <- filter(ucr.wa.crime.data, ucr.wa.crime.data$county == input$county)
    #Changing the colnames to something understandable
    colnames(ucr.wa.crime.data.county) <- c('x','Year','County','Total Female Population','Total Male Population','Total Population','Aggrevated_Assault', 'Arson', 'Burglary', 'Murder', 'Motor_Vehicle_Theft', 'Rape', 'Robbery', 'Theft','Total_Crime')
    
    #If statement to determine which crime is being chosen
    if(input$crime == "Aggrevated_Assault"){
      p <- plot_ly(ucr.wa.crime.data.county, x = input$county, y = ~Aggrevated_Assault, type = "box")
    } else if(input$crime == "Arson"){
      p <- plot_ly(ucr.wa.crime.data.county, x = input$county, y = ~Arson, type = "box")
    } else if(input$crime == "Burglary"){
      p <- plot_ly(ucr.wa.crime.data.county, x = input$county,y = ~Burglary, type = "box")
    } else if(input$crime == "Murder"){
      p <- plot_ly(ucr.wa.crime.data.county, x = input$county,y = ~Murder, type = "box")
    } else if(input$crime == "Motor_Vehicle_Theft"){
      p <- plot_ly(ucr.wa.crime.data.county,x = input$county, y = ~Motor_Vehicle_Theft, type = "box")
    } else if(input$crime == "Rape"){
      p <- plot_ly(ucr.wa.crime.data.county,x = input$county, y = ~Rape, type = "box")
    } else if(input$crime == "Robbery"){
      p <- plot_ly(ucr.wa.crime.data.county,x = input$county, y = ~Robbery, type = "box")
    } else if(input$crime == "Theft"){
      p <- plot_ly(ucr.wa.crime.data.county,x = input$county, y = ~Theft, type = "box")
    }
  })
  

  
  #Create Table
  output$table <- renderDataTable({
    return(filtered())
  }) 
  
  
}
shinyApp(ui=shinyUI(ui),server=shinyServer(server))




