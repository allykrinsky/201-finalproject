#install.packages("zoo")
library("dplyr")
library("tidyr")
library("zoo")

gdp <- read.csv("data/gdp.csv", stringsAsFactors = FALSE)

#View(gdp)

dow <- read.csv("data/DOW.csv", stringsAsFactors = FALSE)
#is.numeric.Date(dow$date)
#View(dow)

gdp_2014_2018 <- gdp %>% 
  select(GeoName, Description, X2014.Q1:X2018.Q3) %>% 
  filter(GeoName == "United States*") %>% 
  filter(Description == "All industry total") %>% 
  gather(
    key = year,
    value = gdp,
    X2014.Q1:X2018.Q3
  ) %>% mutate(
    quarter = substr(year, 7, 8),
    gdp_2 = as.numeric(gdp),
    change =  ((gdp_2  - lag(gdp_2, 1)) / lag(gdp_2, 1)) * 100
  ) 
gdp_2014_2018$year <- substr(gdp_2014_2018$year, 2, 5)

gdp_plot <- gdp_2014_2018 %>% 
  select(year, quarter, change)

gdp_plot$quarter <- ifelse(gdp_plot$quarter == "Q1", "01",
                    ifelse(gdp_plot$quarter == "Q2", "04",
                    ifelse(gdp_plot$quarter == "Q3", "07",
                    ifelse(gdp_plot$quarter == "Q4", "10", "NA"))))


dow_plot <- dow %>% 
  select(date, high, low) %>% 
  mutate(
    avg = (high + low) / 2,
    change = ((avg - lag(avg, 1)) / lag(avg, 1))  * 100
  ) %>% select(date, change) %>% 
  mutate(
    year = substr(date, 1, 4),
    month = substr(date, 6, 7),
    month_year = paste0(year, "-", month)
  ) %>% group_by(month_year) %>% 
  summarise(
    change_monthly = mean(change)
  ) %>% mutate(
    month = substr(month_year, 6, 7),
    year = substr(month_year, 1, 4),
    date = as.Date(as.yearmon(month_year, "%Y-%m"))
  )
#View(for_plot)


for_plot <- left_join(dow_plot, gdp_plot, by = c("month" = "quarter", "year" = "year"))

colnames(for_plot)[2] <- "dow_change"
colnames(for_plot)[6] <- "gdp_change"

for_plot <- for_plot %>% 
  gather(
    key = Type ,
    value = value,
    dow_change, gdp_change
  ) 


for_plot <- filter(for_plot, is.na(value) == FALSE) 

gdp_dow_table <- function(year_1, year_2){
  
  for_table <- for_plot %>% 
    select(year, Type, value) %>% 
    filter(year >= year_1 & year <= year_2) %>% 
    group_by(Type) %>% 
    summarise(
      Average = mean(value)
    )
  
  for_table
}
 
gdp_dow_plot <- function(year_1, year_2){
  

  for_plot <- for_plot %>% filter(year >= year_1 & year <= year_2)

  
  gdp_dow <- ggplot(data = for_plot) +
    geom_line(mapping = aes(
      x = date,
      y = value,
      color = Type,
      group = Type

    ))  + ylab("Percent Change")  +
    scale_x_date(date_breaks = 'year') +
    xlab("Date") + theme(legend.background = element_rect(color = "gray"))

  
  gdp_dow 
  
}



make_text_gdp_dow  <- paste("Looking to compare the overall US GDP to the Dow Jones 
              Index, we plotted a line graph showing the percent change in both overtime. ",
              "The overall trend for the Dow Jones showed us that there are many highs and 
              lows each year and that is a common reoccurrence throughout the range of dates.
              These spikes average out to keep the price increasing by a small percentage each year. The 
              more recent data from 2019 shows that we have just recovered from a large down 
              period.", "The trend for the United States GDP is a lot less predictable. The reports
              we plotted came from quarterly reports. The GDP data is has been increasing over
              this range of dates by about 1% each year. ", "The overall trend of both lines in the 
              largest scale from 2014-2019 does seem to follow the same pattern of ups and downs. This correlation can be 
              usuful for those investing in the market. Although we do observer a similar trend, we can not tell from this 
              data whether this is a causal relationship or just a correlation.")
  



