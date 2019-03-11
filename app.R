library("shiny")
library("dplyr")
library("tidyr")
source("carter.R")
source("Ally.R")
source("Claire.R")

my_ui <- fluidPage(theme = "bootstrap.css",
  titlePanel("GDP vs DOW Jones"),
  tabsetPanel(type = "tabs",
              tabPanel(
                "DOW Jones Seasonal",
                sidebarLayout(
                  sidebarPanel(
                    radioButtons("ag_type", "Aggregation Type:",
                                 list("Average Closing" = 1,
                                   "Maximum Closing" = 2,
                                   "Minimum Closing" = 3), 1)
                  ),
                  mainPanel(
                    plotOutput("dow_monthly")
                  )
                )
              ),
              tabPanel(
                "GDP vs. Dow Jones",
                sidebarLayout(
                  sidebarPanel(
                    sliderInput(inputId = "slider", label = "Select Year", 
                                min = 2014, max = 2018, value = c(2015,2016), sep = "")
                  ),
                  mainPanel(
                    plotOutput("gdp_dow")
                  )
                )
              ),
              
              tabPanel(
                "United States GDP",
                sidebarLayout(
                  sidebarPanel(
                    selectInput(
                      inputId = "region", label = "Select Region", selected = "Washington",
                      region_list
                    ),
                    selectInput(inputId = "industry", label = "Select Indutry", selected = "All industry total", industry_list)
                  ),
                  mainPanel(
                    plotlyOutput("gdp_graph")
                  )# main panel
                )#sidebar layout
              )# tabPanel
  )
)

my_server <- function(input, output){
  output$dow_monthly <- renderPlot({create_monthly_dow_graph(input$ag_type)})
  output$gdp_dow <- renderPlot({gdp_dow_plot(input$slider[1], input$slider[2])})
  output$gdp_graph <- renderPlotly({
    compared_gdp(input$region, input$industry)
  })
}


shinyApp(ui = my_ui, server = my_server)
