library(dplyr)
library(shiny)
library(ggplot2)
library(plotly)

ucr.wa.crime.data <- read.csv("data/ucr.wa.crime.data.csv")
wa.average.crime <- read.csv("data/wa.average.crime.csv")

wa.average.select.crime<- select(wa.average.crime, Average_Population,Average_Assult,
                                 Average_Arson, Average_Burglary, Average_Murder, Average_MVT, 
                                 Average_Rape, Average_Robbery, Average_Theft)

ui <- fluidPage(
  #Title Panel
  titlePanel(title = "Crime in Washington"),
  #Includes Sidebar Panel
  sidebarLayout(
    
    sidebarPanel(

      conditionalPanel(condition = 'input.tabs == "Bar Graph" || input.tabs == "Pie Chart"',
        strong(h5("Bar Graph & Pie Chart Widgets")),
        selectInput('county', 'County', ucr.wa.crime.data$county, selected = ucr.wa.crime.condensed.data$county == "ADAMS"),
        selectInput('year', 'Year',  ucr.wa.crime.data$year, selected = ucr.wa.crime.condensed.data$year == "2000")
      ),
      #make options for users to choose what time of crime data he/she would like to see
      conditionalPanel(condition = 'input.tabs == "Population v. Crime"',
        selectInput('choice', label="Crime", choices= colnames(wa.average.select.crime))
      ),
      
      conditionalPanel(condition = 'input.tabs == "Boxplot"',
        h5("Please Choose a County and Crime"),
        #Selects County 
        selectInput('county2', label = 'County', ucr.wa.crime.data$county, selected = ucr.wa.crime.data$county == "ADAMS"),
      
        #Selecting Which Crime
        selectInput('crime', label = "Crime", choices = c('Aggrevated_Assault', 'Arson', 'Burglary', 'Murder', 
                                                          'Motor_Vehicle_Theft', 'Rape', 'Robbery', 'Theft'), 
                    #Initial Pick of Crime
                    selected = 'Aggrevated_Assult')),
        
        conditionalPanel(condition = 'input.tabs == "Table"',
          h5("Please Choose a County"),
          #Selects County 
          selectInput('county3', label = 'County', ucr.wa.crime.data$county, selected = ucr.wa.crime.data$county == "ADAMS")              
        ),
        
        conditionalPanel(condition = 'input.tabs == "Map"',
          radioButtons("checkbox", label = "Choose Crime", choices = list("Average_Population", "Average_Arson"))
        )
        
      ),
    
    mainPanel(h4("Crime in Washington is different in each county."),
      tabsetPanel(type = "tabs", id= 'tabs',
        tabPanel("Bar Graph", h4("Washington County Crime Rates"), 
                              tags$em(h5("This bar graph displays the crime rates given the individual county and year
                                          in Washington.")),
                 plotlyOutput('bar')),
        tabPanel("Pie Chart", h4("Washington County Crime Rates"),
                            tags$em(h5("This pie chart displays the crime rates given the individual county and year
                                       in Washington.")),
                 plotlyOutput('pie')),
        
        tabPanel("Population v. Crime", h5("Crime in Washington is different in each county."),
                 p("The below visualization provides visualization for the number of crime occurances of each county in Washington State.
                  The plot changes depending on user's choice of crime"),
                 plotlyOutput('plot2', width = 1000, height = 800)),
        
        tabPanel("Crime Scatter Plot", h5("Crime in Washington is different in each county."),
                 #output as plotly and formating the graph
                 p("The below visualization shows a plot of average population of each county in Wahsingont State
                   V. average total crime in the county from year",em('2000'), "to year", em("2011"), ". The visualization
                   allows us to see that there's is a", strong("directly proportional"), "correlation between the average population and
                   the average crime. The more population in a county, the higer the crime rate"),
                 plotlyOutput('plot', width = 1000, height = 500),
                 p('The below visualization below draws a line to show the correlation'),
                 plotOutput('plot1')),
        
        tabPanel("Boxplot", h5("Average Crime In a County."),
                 plotlyOutput("plot3")
        ),
                 
        tabPanel("Table", 
                 dataTableOutput("table.display")
        ),
        
        tabPanel("Map",
                 plotOutput("plot4", hover = "plot_hover"),
                 dataTableOutput("table"),
                 verbatimTextOutput("info"))
        
        )
    )
    )
)


