library("shiny")
source("carter.R")


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
                "Test Panel #2",
                sidebarLayout(
                  sidebarPanel(
                    #Controls here
                  ),
                  mainPanel(
                    #Visualization here
                  )
                )
              )
  )
)

my_server <- function(input, output){
  output$dow_monthly <- renderPlot({create_monthly_dow_graph(input$ag_type)})
}


shinyApp(ui = my_ui, server = my_server)
