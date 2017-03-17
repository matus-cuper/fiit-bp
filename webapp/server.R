library(shiny)
library(config)
serverConfig <- config::get("server", file = "~/r/fiit-bp/webapp/config.yml")

function(input, output) {
  
  output$optimizationParameters <- renderUI({
    numberOfParameters <- as.numeric(serverConfig$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$numberOfOptimizationParameters)
    fluidRow(
      lapply(1:numberOfParameters, function(i) {
        column(numberOfParameters,
               numericInput(serverConfig$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$optimizationParameters[[i]]$id,
                            label = serverConfig$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$optimizationParameters[[i]]$label,
                            value = as.numeric(serverConfig$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$optimizationParameters[[i]]$value),
                            min = as.numeric(serverConfig$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$optimizationParameters[[i]]$min),
                            max = as.numeric(serverConfig$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$optimizationParameters[[i]]$max)
               )
        )
      })
    )
  })
  
  output$predictionParameters <- renderUI({
    numberOfParameters <- as.numeric(serverConfig$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$numberOfPredictionParameters)
    fluidRow(
      lapply(1:numberOfParameters, function(i) {
        column(numberOfParameters,
               numericInput(serverConfig$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$predictionParameters[[i]]$id,
                            label = serverConfig$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$predictionParameters[[i]]$label,
                            value = serverConfig$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$predictionParameters[[i]]$value,
                            min = serverConfig$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$predictionParameters[[i]]$min,
                            max = serverConfig$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$predictionParameters[[i]]$max,
                            step = serverConfig$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$predictionParameters[[i]]$step
               )
        )
      })
    )
  })

  output$resultValues <- renderText({
    inputFile <- input$inputFile
    if (is.null(inputFile))
      return(NULL)

    readFunction <- serverConfig$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$readDataFunction
    preparedData <- do.call(readFunction, list(inputFile$datapath, 96, as.numeric(input$testDatasetProportion)))

    # Global assignment
    trainingMatrix <<- preparedData$trainingMatrix
    testingMatrix <<- preparedData$testingMatrix
    verificationData <<- preparedData$verificationData
    accuracyFunction <<- serverConfig$fitnessFunctions[[as.numeric(input$fitnessFunction)]]$accuracyFunction

    predictFunction <- serverConfig$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$predictFunction
    optimizeFunction <- serverConfig$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$optimizeFunction
    result <- do.call(optimizeFunction, list(match.fun(predictFunction), c(0, 0, 1, 1)))
    do.call(predictFunction, list(c(result$sol[1], result$sol[2])))

  })

  output$resultPlot <- renderText({
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
