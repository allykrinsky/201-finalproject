library("shiny")
source("carter.R")
source("Ally.R")


my_ui <- fluidPage(
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
                                min = 2014, max = 2018, value = 2016, sep = "")
                  ),
                  mainPanel(
                    plotOutput("gdp_dow")
                  )
                )
              )
  )
)

my_server <- function(input, output){
  output$dow_monthly <- renderPlot({create_monthly_dow_graph(input$ag_type)})
  output$gdp_dow <- renderPlot({gdp_dow})
}


shinyApp(ui = my_ui, server = my_server)
