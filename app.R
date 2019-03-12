library("shiny")
library("zoo")
library("dplyr")
library("tidyr")
library("plotly")
source("carter.R")
source("Ally.R")
source("Claire.R")
source("intro_page.R")

my_ui <- fluidPage(theme = "bootstrap.css",
  titlePanel("U.S. Economy Report"),
  tabsetPanel(type = "tabs",
              tabPanel(
                "Introduction",
                h1("Background Infomation"),
                p(intro),
                h3("Page Descriptions"),
                p(tab_1) ,
                p(tab_intro),
                p(third_tab)
                
              
              ),
              
              
              tabPanel(
                "DOW Jones Seasonal",
                tags$p("Test paragraph info"),
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
                                min = 2014, max = 2019, value = c(2016, 2018), sep = ""),
                    tableOutput("gdp_dow_table")
                  ),
                  mainPanel(
                    h1("GDP vs. Dow Jones Index"),
                    textOutput(outputId = "gdp_dow_text"),
                    plotOutput("gdp_dow")
                  )
                )
              ),
              
              tabPanel(
                "United States GDP",
                sidebarLayout(
                  sidebarPanel(
                    selectInput(
                      inputId = "region1", label = "Select First Region", selected = "Washington",
                      region_list
                    ),
                    selectInput(
                      inputId = "region2", label = "Select Second Region", selected = "California",
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
  output$gdp_dow_table <- renderTable({gdp_dow_table(input$slider[1], input$slider[2])})
  output$gdp_dow_text <- renderText({make_text_gdp_dow})
  output$gdp_graph <- renderPlotly({
    compared_gdp(input$region1,input$region2, input$industry)
  })
}


shinyApp(ui = my_ui, server = my_server)
