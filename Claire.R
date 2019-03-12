library("dplyr")
library("tidyr")
library("httr")
library("stringr")
library("ggplot2")
library("shiny")
library("plotly")

gdp <- read.csv("data/gdp.csv",stringsAsFactors = FALSE)
gdp <- select(gdp, -1, -3)
# get the list of region
get_region_name <- filter(gdp, Description == "All industry total")
region_list <- get_region_name$GeoName
# get the list of industry
get_all_industry <- filter(gdp, GeoName == "Washington")
industry_list <- trimws(get_all_industry$Description, "left")

#question <- 
compared_gdp <- function(state_one,state_two, industry){
    state_gdp <- filter(gdp, GeoName == state_one |GeoName == state_two | GeoName == "United States*")
  
  # remove the blank space in the begining
  remove_space <- trimws(state_gdp$Description, "left")
  state_gdp$Description = remove_space
  industry_gdp <- filter(state_gdp,Description == industry)
  #View(industry_gdp)
  
  gathered_industry <- gather(industry_gdp, time, GDP, 3:57) %>% 
    # add a column for the year
    mutate(year = substr(time, 2,5)) 
  gathered_industry$GDP = as.numeric(gathered_industry$GDP)

  
  p <- ggplot(data = gathered_industry) +
    
    geom_line(mapping = aes(x= year, y = GDP, group = GeoName, color = GeoName))+
    geom_point(mapping = aes(x= year, y = GDP, group = GeoName, color = GeoName))+
    theme(
      panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
      panel.background = element_blank(), axis.line = element_line(colour = "black")
    )+
    labs(
      title = paste("The GDP in United States,",state_one,"and",state_two, " \n from 2005 to 2018 \n in", industry),
      x = "year",
      y = "GDP"
    )
  
  ggplotly(p)
  
  
}


gdp_table <- function (state_one,state_two, industry){
# remove the blank space in the begining
state_gdp <- filter(gdp, GeoName == state_one |GeoName == state_two | GeoName == "United States*")
#View(state_gdp)
remove_space <- trimws(state_gdp$Description, "left")
state_gdp$Description = remove_space
industry_gdp <- filter(state_gdp,Description == industry)
#View(industry_gdp)

gathered_industry <- gather(industry_gdp, time, GDP, 3:57) %>% 
  # add a column for the year
  mutate(year = substr(time, 2,5)) 
gathered_industry$GDP = as.numeric(gathered_industry$GDP)
grouped <- gathered_industry %>% 
  group_by(GeoName,year) %>% 
  summarise(mean_gdp = mean(GDP))

grouped_diff <- grouped %>% 
  group_by(GeoName) %>% 
  arrange(year) %>% 
  mutate(diff = mean_gdp - lag(mean_gdp), default = first(mean_gdp)) %>% 
  select(1,2,4)  

avg_change <- grouped_diff %>% 
  group_by(GeoName) %>% 
  summarise(avg_change = mean(diff, na.rm = TRUE))
avg_change
#View(avg_change)
}
#gdp_table("Washington", "California","Construction")



