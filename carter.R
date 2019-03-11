library(ggplot2)

dow <- read.csv("data/DOW.csv")
gdp <- read.csv("data/GDP.csv")

# How does the time of year affect the Dow Jones?
create_monthly_dow_graph <- function(ag_type){
  if(is.null(ag_type)){
    ag_type <- "1"
  }
  
  ag_types <- list("1" = "average_close", "2" = "max_close", "3" = "min_close")
  
  dow_monthly <- dow %>% 
    mutate(month = substr(label, 1, 4), year = substr(date, 1, 4), month_num = substr(date, 6, 7)) %>% 
    group_by(month, year, month_num) %>% 
    summarise(average_close = mean(close), max_close = max(close), min_close = min(close), average_volume = mean(volume)) %>% 
    select(month_num, month, year, value = ag_types[[ag_type]])
  
  ggplot(data = dow_monthly) +
    geom_line(mapping = aes(x = month_num, y = value, group = year, color = year)) +
    labs(title = "DOW Closing vs Month", x = "Month", y = "GDP Value")+
    scale_x_discrete(labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))
}

#I don't think is is correct. Is there a better way to do this?
#cor(as.numeric(dow_monthly$month_num), as.numeric(dow_monthly$average_close), use = "everything")
