
library('shiny')
library('ggplot2')
library('dplyr')
library('plotly')
library('rsconnect')
install.packages("maps")
install.packages("mapdata")


crime.stats <- read.csv("data/wastate.csv", stringsAsFactors = FALSE)
View(crime.stats)

#Selecting needed data values
basic.crime.stats <- select(crime.stats, year, county, POP_F_TOTAL, POP_M_TOTAL, 13:213)
#Filters out years from 1990-1999
filter.years <- basic.crime.stats[!grepl("199", basic.crime.stats$year),]
filter.years2012 <- filter.years[!grepl("2012", filter.years$year),]
filter.years2013 <- filter.years2012[!grepl("2013", filter.years2012$year),]
filter.years.removed <- filter.years2013[!grepl("2014", filter.years2013$year),]

#Sum of Population Population - MAY CHECK UP ON THIS
new.filter.years <- mutate(filter.years.removed, Total.Pop = POP_F_TOTAL + POP_M_TOTAL)
#Select total crimes under UCR - United Crime Report
crime.category <- select(new.filter.years, year, county, POP_F_TOTAL, POP_M_TOTAL,UCR_AG_ASSLT,UCR_ARSON,UCR_BURGLARY,UCR_MURDER,UCR_MVT,UCR_RAPE,UCR_ROBBERY,UCR_THEFT,UCR_TOTAL)
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

# state data
states <- map_data("state")

# gets only washington state
wa_df <- subset(states, region == "washington")

# county data
counties <- map_data("county", fill = TRUE)

# Only washington counties
wa.counties <- subset(counties, region == "washington")

# creates washington state map with county lines
wa.map <- ggplot(data = wa_df, mapping = aes(x = long, y = lat, group = group)) + 
  coord_quickmap() + 
  geom_polygon(color = "black", fill = "gray")
wa.map + geom_polygon(data = wa.counties, fill = NA, color = "white") +
          geom_polygon(color = "black", fill = NA)

# Combine county and average crime data
colnames(wa.counties)[6] <- "county"
average.crime$county <- tolower(average.crime$county)
all.data <- inner_join(average.crime, wa.counties, by = "county")
View(all.data)

ditch_the_axes <- theme(
  axis.text = element_blank(),
  axis.line = element_blank(),
  axis.ticks = element_blank(),
  panel.border = element_blank(),
  panel.grid = element_blank(),
  axis.title = element_blank()
)

crime.by.county <- wa.map + 
                    geom_polygon(data = all.data, aes(fill = Average_Total), color = "white")+
                    geom_polygon(color = "black", fill = NA)+
                    theme_bw() +
                    ditch_the_axes+ 
                    scale_fill_gradient(trans = "log10", low = "white", high = "red")




