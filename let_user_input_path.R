
# modified from original program in 
# https://stackoverflow.com/questions/71756296/store-text-input-as-variable-in-r-shiny
# user input the Windows path, e.g.: C:\\Users\\hengw\\OneDrive\\Documents\\My Games\\myfile.csv
# user input the Linux path, e.g., /home/hengweiliu/Documents/input_path/myfile.csv

library(plotly)
library(shiny)

ui <- fluidPage(
  mainPanel(
    plotlyOutput("plot", width = '100%'),
    br(),
    textAreaInput("list", "Input Path", ""),
    actionButton("submit", "Submit", icon = icon("refresh"), 
                 style="float:right"),
    
    tableOutput("mydata")
  ))

server <- function(input, output, session) {
  my_text <- reactive({
    input$list 
    
  }) %>% 
    shiny::bindCache(input$list
    ) %>% 
    shiny::bindEvent(input$submit)
  
  hello_out  <- renderText({
    my_text()
  })
  
  output$mydata <- renderTable({
    mydata <- read.csv(hello_out())
    print(mydata)
  })
  
  
}

shinyApp(ui, server)
