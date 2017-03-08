library(shiny)
library(dplyr)
library(ggplot2)
library(tidyr)
View(mpg)
ucr.wa.crime.data <- read.csv("data/ucr.wa.crime.data.csv")
wa.average.crime <- read.csv("data/wa.average.crime.csv")
View(ucr.wa.crime.data)
ucr.wa.crime.condensed.data <- select(ucr.wa.crime.data, X, year, county, UCR_AG_ASSLT, UCR_ARSON,
                                      UCR_BURGLARY, UCR_MURDER, UCR_MVT, UCR_RAPE, UCR_ROBBERY,
                                      UCR_THEFT, UCR_TOTAL)
View(ucr.wa.crime.condensed.data)
ucr.wa.crime.condensed.data.1 <- filter(ucr.wa.crime.condensed.data, ucr.wa.crime.condensed.data$X == "1")
View(ucr.wa.crime.condensed.data.1)
ucr.wa.crime.condensed.data.1.extra <- select(ucr.wa.crime.condensed.data.1, UCR_AG_ASSLT, UCR_ARSON, UCR_BURGLARY,
                                              UCR_MURDER, UCR_MVT, UCR_RAPE, UCR_ROBBERY, UCR_THEFT, UCR_TOTAL)
colnames(ucr.wa.crime.condensed.data.1)
pie.data <- gather(ucr.wa.crime.condensed.data.1.extra, key = type.of.crime, value = crimes)
View(pie.data)
shinyServer(
  
  function(input, output) {
    output$bar <- renderPlot({
      #pie(ucr.wa.crime.condensed.data.1.extra, labels = colnames(ucr.wa.crime.condensed.data.1.extra), 
      #    fill = rainbow(length(ucr.wa.crime.condensed.data.1.extra)))
      p <- ggplot(data = pie.data) +
        aes(x = type.of.crime, y = crimes) +
        geom_bar(stat = "identity")
      p + coord_flip()
    })
  }
)
