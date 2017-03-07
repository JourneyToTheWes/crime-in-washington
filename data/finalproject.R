library('shiny')
library('ggplot2')
library('dplyr')
library('plotly')
library('rsconnect')

crime.stats <- read.csv("wastate.csv")


#Selecting needed data values
basic.crime.stats <- select(crime.stats, year, county, POP_F_TOTAL, POP_M_TOTAL, 13:213)
#Filters out years from 1990-1999
filter.years <- basic.crime.stats[!grepl("199", basic.crime.stats$year),]
#Sum of Population Population - MAY CHECK UP ON THIS
filter.years <- mutate(filter.years, Total.Pop = POP_F_TOTAL + POP_M_TOTAL)
#Select total crimes under UCR - United Crime Report
crime.category <- select(filter.years, year, county, POP_F_TOTAL, POP_M_TOTAL,UCR_AG_ASSLT,UCR_ARSON,UCR_BURGLARY,UCR_MURDER,UCR_MVT,UCR_RAPE,UCR_ROBBERY,UCR_THEFT,UCR_TOTAL)
filter <- mutate(crime.category, TOTAL.POP = POP_F_TOTAL + POP_M_TOTAL)
#Brings total.pop to front
crime.pop.front <- select(filter, year, county, POP_F_TOTAL, POP_M_TOTAL, TOTAL.POP,UCR_AG_ASSLT,UCR_ARSON,UCR_BURGLARY,UCR_MURDER,UCR_MVT,UCR_RAPE,UCR_ROBBERY,UCR_THEFT,UCR_TOTAL)
write.csv(crime.pop.front, file = "ucr.wa.crime.data.csv")

#Average of each crime committed within the years
average.crime <- crime.pop.front %>% 
  group_by(county) %>% 
  summarize(Average_Population =mean(TOTAL.POP),Average_Assult =mean(UCR_AG_ASSLT), Average_Arson = mean(UCR_ARSON), Average_Burglary= mean(UCR_BURGLARY), Average_Murder= mean(UCR_MURDER),
            Average_MVT =mean(UCR_MVT), Average_Rape =mean(UCR_RAPE), Average_Robbery =mean(UCR_ROBBERY), Average_Theft =mean(UCR_THEFT), Average_Total =mean(UCR_TOTAL))
write.csv(average.crime, file = "wa.average.crime.csv")




