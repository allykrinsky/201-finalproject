library("shiny")
library("zoo")
library("dplyr")
library("tidyr")
library("plotly")
source("carter.R")
source("Ally.R")
source("Claire.R")
source("intro_page.R")

my_ui <- fluidPage(
  theme = "bootstrap.css",
  titlePanel("U.S. Economy Report"),

  tabsetPanel(
    type = "tabs",
    
    # first panel: introduction of the whole app
    tabPanel(
      "Introduction",
      h3("Background Infomation"),
      p(intro),
      h3("Page Descriptions"),
      p(tab_intro),
      p(tab_1),
      p(third_tab)
    ),




    # Dow Jones tab: this tab shows an analysis on dow jones graohs
    tabPanel(
      "DOW Jones Seasonal",
      tags$h3("How does time of year affect the value of the DOW Jones?"),
      tags$p("Just looking at the graph, there doesn't seem to be any visible correlation between time of year and change in DOW. 
             If we test the correlation between the numeric month and percent change in DOW, we get an index of -0.24 which indicates 
             that there is very little correlation between the two factors. However, because this is a measure of linear correlation, 
             it's possible there's a more complex relationship between the two variables that won't be picked up with linear regression."),
      
      # side bar for user to make select years
      sidebarLayout(
        sidebarPanel(
          checkboxGroupInput("years",
            label = h3("Years:"),
            choices = list("2014", "2015", "2016", "2017", "2018", "2019"),
            selected = c("2014", "2015", "2016", "2017", "2018", "2019")
          )
        ),
        
        # main panel renders the plot for the dow jones 
        mainPanel(
          plotOutput("dow_monthly")
        )
      )
    ),
    
    # second tab: compare GDP with Dow Jones
    tabPanel(
      "GDP vs. Dow Jones",
      # side bar panel for user input, main panel for render picture
      sidebarLayout(
        # side bar for user to choose year range 
        sidebarPanel(
          # slider for choose year range
          sliderInput(
            inputId = "slider", label = "Select Year",
            min = 2014, max = 2019, value = c(2016, 2018), sep = ""
          ),
          # summary table for gdp and down jones
          tableOutput("gdp_dow_table")
        ),
        # renders the GDP vs Down jones graph 
        mainPanel(
          h1("GDP vs. Dow Jones Index"),
          textOutput(outputId = "gdp_dow_text"),
          plotOutput("gdp_dow")
        )
      )
    ),
    
    # third tab shows the USA GDP
    tabPanel(
      "United States GDP",
      tags$h3("Is there any correlation between geographic locations and GDP?"),
      # sidebar layout: side bar for user input, main panel for rendering graph
      sidebarLayout(
        sidebarPanel(
          # drop dow selection to choose a region
          selectInput(
            inputId = "region1", label = "Select First Region", selected = "Washington",
            region_list
          ),
          # drop down selection to choose a second region
          selectInput(
            inputId = "region2", label = "Select Second Region", selected = "California",
            region_list
          ),
          # drop down selection to select industry
          selectInput(inputId = "industry", label = "Select Indutry", selected = "All industry total", industry_list),
          tableOutput("gdp_table")
        ),
        #renders the gdp graph
        mainPanel(
          textOutput("gdp_text"),
          br(),
          br(),
          plotlyOutput("gdp_graph")
        ) # main panel
      ) # sidebar layout
    ), # tabPanel
    
    tabPanel(
      "References"
    )
  )
)

my_server <- function(input, output) {
  # render the dow jones graph
  output$dow_monthly <- renderPlot({
    create_monthly_dow_graph(input$years)
  })
  # render the gdp vs. dow jones graph
  output$gdp_dow <- renderPlot({
    gdp_dow_plot(input$slider[1], input$slider[2])
  })

  # renders the ineteractive GDP graph
  output$gdp_graph <- renderPlotly({
    compared_gdp(input$region1, input$region2, input$industry)
  })
  # renders the gdp table
  output$gdp_table <- renderTable({
    gdp_table(input$region1, input$region2, input$industry)
  })
  # render gdp vs dow table
  output$gdp_dow_table <- renderTable({
    gdp_dow_table(input$slider[1], input$slider[2])
  })
  # renders text for the gdp vs dow tab
  output$gdp_dow_text <- renderText({
    make_text_gdp_dow
  })
  output$gdp_text <- renderText({gdp_text(input$region1, input$region2, input$industry)})
}




shinyApp(ui = my_ui, server = my_server)
