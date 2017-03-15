library(shiny)
library(config)
uiConfig <- config::get("ui", file = "~/r/fiit-bp/webapp/config.yml")
  
function(input, output) {
  
  output$svrResult <- renderText({
    inputFile <- input$inputFile
    if (is.null(inputFile))
      return(NULL)
     
    readFunction <- uiConfig$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$readData
    preparedData <- do.call(readFunction, list(inputFile$datapath, 96, as.numeric(input$testDatasetProportion)))
    
    trainingMatrix <<- preparedData$trainingMatrix
    testingMatrix <<- preparedData$testingMatrix
    verificationData <<- preparedData$verificationData
    accuracyFunction <<- uiConfig$fitnessFunctions[[as.numeric(input$fitnessFunction)]]$accuracyFunction
    
    svrOptimize(c(1, 0.1))
  })
  
  output$filename <- renderText({
    getwd()
  })
  
  # tmp <- input$inputFile
  
  # output$numberOfParameters <- renderUI({
  #   parameters <- algorithmsList[[1]][2:3]
  #   # textInput(paste("param", parameters[1], sep = ""), label = paste ("Parameter", parameters[1]), value = "ahoj")
  # 
  #   lapply(1:2, function(i) {
  #     textInput(
  #       paste("param", parameters[i], sep = ""), label = paste ("Parameter", parameters[i]), value = "ahoj"
  #       )
  #   })
  #   
    
    # for (p in parameters) {
    #   print(p)
    #   textInput(paste("param", p, sep = ""), label = paste ("Parameter", p), value = "ahoj")
    # }
  # })
  
  # output$selectUI <- renderUI({ 
  #   selectInput("partnerName", "Select your choice", list("raz", "dva", "tri"))
  # })
  
  # output$random <- renderPlot({
  #   test(10)
  # })
}
