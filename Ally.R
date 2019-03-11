library("dplyr")
library("tidyr")

gdp <- read.csv("data/gdp.csv", stringsAsFactors = FALSE)

#View(gdp)

dow <- read.csv("data/DOW.csv", stringsAsFactors = FALSE)

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

?switch
dow_plot <- dow %>% 
  select(date, high, low) %>% 
  mutate(
    avg = (high + low) / 2,
    change = ((avg - lag(avg, 1)) / lag(avg, 1))  * 100
  ) %>% select(date, change) %>% 
  mutate(
    year = substr(date, 1, 4),
    month = substr(date, 6, 7),
    month_year = paste(month, year)
  ) %>% group_by(month_year) %>% 
  summarise(
    change_monthly = mean(change)
  ) %>% mutate(
    year = substr(month_year, 4, 7),
    month = substr(month_year, 1, 2)
  )


for_plot <- left_join(dow_plot, gdp_plot, by = c("month" = "quarter", "year" = "year"))

colnames(for_plot)[2] <- "dow_change"
colnames(for_plot)[5] <- "gdp_change"

for_plot <- for_plot %>% 
  gather(
    key = type ,
    value = value,
    dow_change, gdp_change
  ) 


for_plot <- filter(for_plot, is.na(value) == FALSE) %>% 
  mutate(
    scales = (as.numeric(year) - 2014) * 12 + as.numeric(month)
  )

gdp_dow_plot <- function(year_1, year_2){
  
  for_plot <- for_plot %>% filter(year >= year_1 & year <= year_2) 
  #label <- paste0(for_plot$month_year, collapse = ", ")
  
  gdp_dow <- ggplot(data = for_plot) +
    geom_line(mapping = aes(
      x = scales,
      y = value,
      color = type,
      group = type
    )) + xlab("Date") + ylab("Percent Change") 
  
  gdp_dow
  
}

#gdp_dow_plot(2014, 2017)

#for_plot$month_year



