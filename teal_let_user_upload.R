# program is from: https://github.com/insightsengineering/teal/issues/952

library(teal)

app <- init(
  data = teal_data_module(
    ui = function(id) {
      ns <- NS(id)
      fluidPage(
        mainPanel(
          shiny::fileInput(ns("file"), "Upload a file"),
          actionButton(ns("submit"), "Submit"),
          DT::dataTableOutput(ns("preview"))
        )
      )
    },
    server = function(id) {
      moduleServer(id, function(input, output, session) {
        data <- eventReactive(input$submit, {
          req(input$file)
          td <- within(teal_data(), my_data <- read.csv(path), path = input$file$datapath)
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
