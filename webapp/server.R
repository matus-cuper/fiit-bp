library(shiny)
source("plot.R")

shinyServer(function(input, output) {
  
  output$selectUI <- renderUI({ 
    selectInput("partnerName", "Select your choice", list("raz", "dva", "tri"))
  })
  
  output$random <- renderPlot({
    test(input$parameter2)
  })
})
