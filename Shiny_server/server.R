library(shiny)
library(datasets)

# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {
  
  # Return the requested dataset
  datasetInput <- reactive({
     input$week
  })
  
  # Generate a summary of the dataset
  output$summary <- renderPrint({
    dataset <- as.numeric(datasetInput())
    remaining_weeks <- 40-dataset+1
    if(remaining_weeks<5) visits <- remaining_weeks  else  visits <- 4 + floor(.8*(remaining_weeks-4)/2)
    visits
  })
})
