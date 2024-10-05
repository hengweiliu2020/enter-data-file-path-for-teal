
# modified from original program in 
# https://github.com/insightsengineering/teal/issues/952
# user input the Windows path, e.g.: C:\\Users\\hengw\\OneDrive\\Documents\\My Games\\myfile.csv
# user input the Linux path, e.g., /home/hengweiliu/Documents/input_path/myfile.csv

library(teal)
library(plotly)

app <- init(
  data = teal_data_module(
    ui = function(id) {
      ns <- NS(id)
      fluidPage(
        mainPanel(
          plotlyOutput("plot", width = '100%'),
          br(),
          textAreaInput(ns("list"), "Input Path", ""),
          actionButton(ns("submit"), "Submit", icon = icon("refresh"), 
                       style="float:right"), 
          DT::dataTableOutput(ns("preview"))
        )
      )
    },
    server = function(id) {
      moduleServer(id, function(input, output, session) {
        
        my_text <- reactive({
          input$list 
          
        }) %>% 
          shiny::bindCache(input$list
          ) %>% 
          shiny::bindEvent(input$submit)
        
        hello_out  <- renderText({
          my_text()
        })

        data <- eventReactive(input$submit, {
          
          td <- within(teal_data(), my_data <- read.csv(path), path = hello_out())
          datanames(td) <- "my_data"
          td
        })
        
        output$preview <- DT::renderDataTable({
          req(input$submit)
          req(input$file)
          data()[["my_data"]]
        })
        data
      })
    }
  ),
  modules = example_module()
)

shinyApp(app$ui, app$server)