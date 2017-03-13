library(shiny)
source("plot.R")

shinyServer(function(input, output) {
  
  output$numberOfParameters <- renderUI({
    parameters <- algorithmsList[[1]][2:3]
    # textInput(paste("param", parameters[1], sep = ""), label = paste ("Parameter", parameters[1]), value = "ahoj")

    lapply(1:2, function(i) {
      textInput(
        paste("param", parameters[i], sep = ""), label = paste ("Parameter", parameters[i]), value = "ahoj"
        )
    })
    
    
    # for (p in parameters) {
    #   print(p)
    #   textInput(paste("param", p, sep = ""), label = paste ("Parameter", p), value = "ahoj")
    # }
  })
  
  # output$selectUI <- renderUI({ 
  #   selectInput("partnerName", "Select your choice", list("raz", "dva", "tri"))
  # })
  
  # output$random <- renderPlot({
  #   test(10)
  # })
})
