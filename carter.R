library(ggplot2)

dow <- read.csv("data/DOW.csv")
gdp <- read.csv("data/GDP.csv")

# How does the time of year affect the Dow Jones?
create_monthly_dow_graph <- function(years){
  dow_monthly <- dow %>% 
    mutate(month = substr(label, 1, 4), year = substr(date, 1, 4), month_num = substr(date, 6, 7)) %>% 
    group_by(month, year, month_num) %>% 
    summarise(average_change = mean(change), average_volume = mean(volume)) %>% 
    select(month_num, month, year, average_change) %>% 
    filter(year %in% years)
  
  ggplot(data = dow_monthly) +
    geom_line(mapping = aes(x = month_num, y = average_change, group = year, color = year)) +
    labs(title = "DOW Closing vs Month", x = "Month", y = "GDP Value")+
    scale_x_discrete(labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))
}

#I don't think is is correct. Is there a better way to do this?
#cor(as.numeric(dow_monthly$month_num), as.numeric(dow_monthly$average_close), use = "everything")
