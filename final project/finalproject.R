library('shiny')
library('ggplot2')
library('dplyr')
library('plotly')
library('rsconnect')

crime.stats <- read.csv("wastate.csv")
View(crime.stats)

#Selecting needed data values
basic.crime.stats <- select(crime.stats, year, county, POP_F_TOTAL, POP_M_TOTAL, 13:213)
#Filters out years from 1990-1999
filter.years <- basic.crime.stats[!grepl("199", basic.crime.stats$year),]
View(filter.years)
#Sum of Population Population - MAY CHECK UP ON THIS
filter.years <- mutate(filter.years, Total.Pop = POP_F_TOTAL + POP_M_TOTAL)
View(filter.years)
#Select total crimes under UCR - United Crime Report
crime.category <- select(filter.years, year, county, POP_F_TOTAL, POP_M_TOTAL,UCR_AG_ASSLT,UCR_ARSON,UCR_BURGLARY,UCR_MURDER,UCR_MVT,UCR_RAPE,UCR_ROBBERY,UCR_THEFT,UCR_TOTAL)
filter <- mutate(crime.category, TOTAL.POP = POP_F_TOTAL + POP_M_TOTAL)
#Brings total.pop to front
crime.pop.front<- select(filter, year, county, POP_F_TOTAL, POP_M_TOTAL, TOTAL.POP,UCR_AG_ASSLT,UCR_ARSON,UCR_BURGLARY,UCR_MURDER,UCR_MVT,UCR_RAPE,UCR_ROBBERY,UCR_THEFT,UCR_TOTAL)
View(crime.pop.front)


