
# intro to report 


intro <- "Our report studies the U.S economy in the past years. There are two main data sets we used to do the analysis. 
One is the Dow Jones Industrial Average (DJIA) from 2014 to 2019, which measures the overall stock market performance in the
U.S. DJIA was accessed from ecoddata, and the data is updated daily from the stock market. U.S.. DJIA is a index measuring the stock performance of 30 companies which are the most valuable companies in the U.S. and can largely influence the overall economy of the U.S.. 
Another one is the GDP for United States from 2005 to 2018. We use the USA quarterly GDP to measure the US economy. GDP refers to 
gross domestic product, which measures the total value of goods and services produced in a given amount of time. In the GDP data table,
we have GDP for each individual state for each quarter in all different industries including construction, manufacturer and et. 
Using these two data sets, we are going to have a better understanding of the US economy, and their interrelation."


tab_intro <- "Our report has three tabs: Dow Jones Seasonal, GDP VS. Dow Jones, and United States GDP. These three tabs will help three questions respectively."

tab_1 <- HTML(paste0("Under the ","<b>","GDP vs. Dow tab, ","</b>", "you will find information answering the question, 'How does change in the Dow Jones Index 
affect the change in US GDP?'. These two fields are measures of the US econmoy and from our preliminary analysis seem to 
follow a similiar pattern. To learn more on the relationship between the Dow Jones Index and US GDP, click on the GDP vs. Dow tab."))


third_tab <- HTML(paste0("The ","<b>","United States GDP Tab","</b>"," will provide help  to answer the question: Is there any correlation between geographic locations and GDP?",
                   "The question will provide the user  with a better understanding of the US economy by providing the GDP stats in individual states and region. 
                   The user can choose two regions including states and larger areas, and a certain industry. Then the graph will show the U.S. GDP trend and GDP 
                   tend in these two regions from 2005 to 2018 in each quarter in the certain industry. If the user choose to compare two states’ GDP change, the 
                   graph can visualize the GDP change trend in these two states and visualize the correlation between them. If the user choose to compare a state
                   to a larger area, the user can see if the state’s GDP influence the GDP change in that larger area. For example, the user can choose Minnesota 
                   and Midwest, and compare how much does Minnesota’s GDP change contribute to the overall GDP change in Midwest. The GDP for the United States is 
                   always shown on the graph because it provides the user with the overview of the country’s GDP change. The table will provide the user a quantitative 
                   analysis on the GDP changes for these regions from 2005 to 2018. Combining the graph and table, the user can understand US economy from different perspectives.",
                   sep = "\n"
))

# three tab description will inlcude the question, significance of the question, how the user can navigate the tab. 







