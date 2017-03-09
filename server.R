library("shiny")
library("leaflet")
library('dplyr')

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
    filtered <- reactive({
      data <- wa.average.crime
      return(data)
    })
    output$plot <- renderPlot({
      
      # creates washington state map with county lines
      p <- ggplot(data = washington.state, mapping = aes(x = long, y = lat, group = group)) + 
        coord_quickmap() + 
        geom_polygon(data = all.data, aes(fill = Average_Arson), color = "white")+
        geom_polygon(color = "black", fill = NA)+
        theme_bw() +
        ditch_the_axes +
        scale_fill_gradient(trans = "log10", low = "white", high = "red")+
        labs(title = "Total Crime Average")
      return(p)
      
    })
    output$info <- renderText({
      paste0("x = ", input$plot_hover$x, "\ny = ", input$plot_hover$y)
    })
    output$table <- renderDataTable({
      return(filtered())
    })
  }
)