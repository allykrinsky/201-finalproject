library("shiny")
source("carter.R")


my_ui <- fluidPage(
  radioButtons("ag_type", "Aggregation Type:",
               list("Average Closing" = 1,
                 "Maximum Closing" = 2,
                 "Minimum Closing" = 3), 1),
  plotOutput("dow_monthly")
)

my_server <- function(input, output){
  output$dow_monthly <- renderPlot({create_monthly_dow_graph(input$ag_type)})
}


shinyApp(ui = my_ui, server = my_server)
