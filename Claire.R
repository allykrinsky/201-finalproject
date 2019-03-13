library("dplyr")
library("tidyr")
library("httr")
library("stringr")
library("ggplot2")
library("shiny")
library("plotly")

gdp <- read.csv("data/gdp.csv", stringsAsFactors = FALSE)
gdp <- select(gdp, -1, -3)
# get the list of region
get_region_name <- filter(gdp, Description == "All industry total")
region_list <- get_region_name$GeoName
# get the list of industry
get_all_industry <- filter(gdp, GeoName == "Washington")
industry_list <- trimws(get_all_industry$Description, "left")

# this function will return a plot for GDP in the United States 
compared_gdp <- function(state_one, state_two, industry) {
  state_gdp <- filter(gdp, GeoName == state_one | GeoName == state_two | GeoName == "United States*")

  # remove the blank space in the begining
  remove_space <- trimws(state_gdp$Description, "left")
  state_gdp$Description <- remove_space
  industry_gdp <- filter(state_gdp, Description == industry)
  # View(industry_gdp)

  gathered_industry <- gather(industry_gdp, time, GDP, 3:57) %>%
    # add a column for the year
    mutate(year = substr(time, 2, 5))
  gathered_industry$GDP <- as.numeric(gathered_industry$GDP)

  # draw the plot with lines and points. the x axis is year and y axis is GDP
  p <- ggplot(data = gathered_industry) +

    geom_line(mapping = aes(x = year, y = GDP, group = GeoName, color = GeoName)) +
    geom_point(mapping = aes(x = year, y = GDP, group = GeoName, color = GeoName)) +
    theme(
      panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
      panel.background = element_blank(), axis.line = element_line(colour = "black")
    ) +
    labs(
      title = paste("The GDP in United States,", state_one, "and", state_two, " \n from 2005 to 2018 \n in", industry),
      x = "year",
      y = "GDP"

    )


  ggplotly(p)
}

# the function will return a table comparing the avg change of GDP in two states and U.S.

gdp_table <- function(state_one, state_two, industry) {
  # remove the blank space in the begining
  state_gdp <- filter(gdp, GeoName == state_one | GeoName == state_two | GeoName == "United States*")
  # View(state_gdp)
  remove_space <- trimws(state_gdp$Description, "left")
  state_gdp$Description <- remove_space
  industry_gdp <- filter(state_gdp, Description == industry)
  # View(industry_gdp)

  gathered_industry <- gather(industry_gdp, time, GDP, 3:57) %>%
    # add a column for the year
    mutate(year = substr(time, 2, 5))
  gathered_industry$GDP <- as.numeric(gathered_industry$GDP)
  grouped <- gathered_industry %>%
    group_by(GeoName, year) %>%
    summarise(mean_gdp = mean(GDP))
  # group by the region name and calculate the change of GDP for two consecutive years
  grouped_diff <- grouped %>%
    group_by(GeoName) %>%
    arrange(year) %>%
    mutate(diff = mean_gdp - lag(mean_gdp), default = first(mean_gdp)) %>%
    select(1, 2, 4)
  # group by region and calculate the average change of GDP for two consecutive years in the past 13 years. 
  avg_change <- grouped_diff %>%
    group_by(GeoName) %>%
    summarise(avg_change = mean(diff, na.rm = TRUE))
  avg_change
  # View(avg_change)
}
# gdp_table("Washington", "California","Construction")

# the function will return text description for the US gdp page
gdp_text <- function(state_one, state_two, industry) {
  paste("This page focused on the analysis of U.S. GDP. We are interested in the correlation between geographic regions and GDP.
  The following graph shows the GDP in", state_one, ",", state_two, "and United States from 2005 to 2018 for each individual qurater in", 
  industry, ". You can see the trend of GDP change in these two regions and United States as a whole. In general, when the United States GDP rises,
  the GDP for each individual state rises. Also, when the state's GDP rises, the GDP for that larger region rises as well. From the visualization,
  you can also compare the different levels of GDP for", state_one, "and", state_two, ". The table shows the quantitative analysis.
  We calculate the GDP change for", state_one, ",", state_two, "and United States for each year, and caluclate the average 
  change of GDP for the past 13 years. The statistics is shown on the left. You can compare the GDP change for", state_one, "and", state_two, ".",
  "From the table, you can see the different GDP growth level for these two regions and the nation as a whole.","Overall, U.S.is experiencing positive GDP change.
  The smaller regions experience a smaller GDP change compared with the larger region they belong to. Different states have dfferent levels of GDP (shown from the graph)
  and experience different levels of GDP growth (Shown in the table)."
  
        )
}
