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
#Sum of Population Population - MAY CHECK UP ON THIS
filter.years <- mutate(filter.years, Total.Pop = POP_F_TOTAL + POP_M_TOTAL)
#Select total crimes under each category
crime.category <- select(filter.years, year, county, POP_F_TOTAL, POP_M_TOTAL,UCR_TOTAL,NIB_TOTAL,ARR_TOTAL,ARN_TOTAL,SCF_TOTAL,JST_TOTAL)
View(crime.category)




