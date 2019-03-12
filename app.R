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
                p(tab_intro),
                p(tab_1) ,
                p(third_tab)
                
              
              ),
              
              
              tabPanel(
                "DOW Jones Seasonal",
                tags$h3("How does time of year affect the value of the DOW Jones?"),
                tags$p("Just looking at the graph, there doesn't seem to be any visible correlation between time of year and change in DOW. If we test the correlation between the numeric month and percent change in DOW, we get an index of -0.24 which indicates that there is very little correlation between the two factors. However, because this is a measure of linear correlation, it's possible there's a more complex relationship between the two variables that won't be picked up with linear regression."),
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
                    plotlyOutput("gdp_graph"),
                    tableOutput("gdp_table")
                    
                  )# main panel
                )#sidebar layout
              )# tabPanel

  )
)

my_server <- function(input, output){
  output$dow_monthly <- renderPlot({create_monthly_dow_graph(input$years)})
  output$gdp_dow <- renderPlot({gdp_dow_plot(input$slider[1], input$slider[2])})


  output$gdp_graph <- renderPlotly({compared_gdp(input$region1,input$region2, input$industry)})
  output$gdp_table <- renderTable({gdp_table(input$region1,input$region2,input$industry)})

  output$gdp_dow_table <- renderTable({gdp_dow_table(input$slider[1], input$slider[2])})
  output$gdp_dow_text <- renderText({make_text_gdp_dow})
  
  }




shinyApp(ui = my_ui, server = my_server)
