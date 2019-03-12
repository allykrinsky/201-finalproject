library("shiny")
library("dplyr")
library("tidyr")
library("plotly")
source("carter.R")
source("Ally.R")
source("Claire.R")

my_ui <- fluidPage(theme = "bootstrap.css",
  titlePanel("GDP vs DOW Jones"),
  tabsetPanel(type = "tabs",
              tabPanel(
                "DOW Jones Seasonal",
                tags$h3("How does time of year affect the value of the DOW Jones?"),
                tags$p("Question Answer"),
                sidebarLayout(
                  sidebarPanel(
                    checkboxGroupInput("years", label = h3("Years:"), 
                                       choices = list("2014", "2015", "2016", "2017", "2018", "2019"),
                                       selected = c("2014","2015", "2016", "2017", "2018", "2019"))
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
  output$dow_monthly <- renderPlot({create_monthly_dow_graph(input$years)})
  output$gdp_dow <- renderPlot({gdp_dow_plot(input$slider[1], input$slider[2])})
  output$gdp_graph <- renderPlotly({
    compared_gdp(input$region, input$industry)
  })
}


shinyApp(ui = my_ui, server = my_server)
