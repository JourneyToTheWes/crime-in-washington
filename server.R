library(shiny)

ucr.wa.crime.data <- read.csv("ucr.wa.crime.data.csv")
wa.average.crime <- read.csv("wa.average.crime.csv")

server <-function(input, output){
  filtered <- reactive({
    data <- ucr.wa.crime.data %>% 
      filter(county == input$county)
    return(data)
  })
  
  output$county <- renderText({
    filtered()
  })

  output$table <- renderDataTable({
    output$mytable <- renderText(input$county)
    return(filtered())
  })
  
  
  output$plot <- renderPlot({
    while(ucr.wa.crime.data$county == input$county){
      boxplot(as.formula(filtered()), 
              data = wa.average.crime,
              outline = input$outliers)
    }
  })
  
  
}

shinyApp(ui=shinyUI(ui),server=shinyServer(server))

