library(shiny)
library(kernlab)
library(config)
config.ui <- config::get("ui", file = "~/r/fiit-bp/webapp/config.yml")
config.server <- config::get("server", file = "~/r/fiit-bp/webapp/config.yml")

function(input, output) {

  output$optimizationParameters <- renderUI({
    numberOfParameters <- as.numeric(config.server$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$numberOfOptimizationParameters)
    fluidRow(
      lapply(1:numberOfParameters, function(i) {
        column(numberOfParameters,
               numericInput(config.server$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$optimizationParameters[[i]]$id,
                            label = config.server$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$optimizationParameters[[i]]$label,
                            value = as.numeric(config.server$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$optimizationParameters[[i]]$value),
                            min = as.numeric(config.server$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$optimizationParameters[[i]]$min),
                            max = as.numeric(config.server$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$optimizationParameters[[i]]$max)
               )
        )
      })
    )
  })


  output$predictionParameters <- renderUI({
    numberOfParameters <- as.numeric(config.server$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$numberOfPredictionParameters)
    fluidRow(
      lapply(1:numberOfParameters, function(i) {
        column(numberOfParameters,
               numericInput(config.server$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$predictionParameters[[i]]$id,
                            label = config.server$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$predictionParameters[[i]]$label,
                            value = config.server$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$predictionParameters[[i]]$value,
                            min = config.server$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$predictionParameters[[i]]$min,
                            max = config.server$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$predictionParameters[[i]]$max,
                            step = config.server$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$predictionParameters[[i]]$step
               )
        )
      })
    )
  })


  output$resultValues <- renderText({
    inputFile <- input$inputFile
    if (is.null(inputFile))
      return(NULL)

    readFunction <- config.server$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$readDataFunction
    preparedData <- do.call(readFunction, list(inputFile$datapath, input$measurementsPerDay, input$testDatasetProportion))

    # Global assignment
    trainingMatrix <<- preparedData$trainingMatrix
    testingMatrix <<- preparedData$testingMatrix
    verificationData <<- preparedData$verificationData
    accuracyFunction <<- config.server$fitnessFunctions[[as.numeric(input$fitnessFunction)]]$accuracyFunction

    svrError(trainingMatrix, testingMatrix, verificationData, "mape", 1, 0.1)
    # predictFunction <- config.server$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$predictFunction
    # optimizeFunction <- config.server$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$optimizeFunction
    # result <- do.call(optimizeFunction, list(match.fun(predictFunction), c(0, 0, 1, 1)))
    # do.call(predictFunction, list(c(result$sol[1], result$sol[2])))

  })


  output$resultPlot <- renderPlot({
    inputFile <- input$inputFile
    if (is.null(inputFile))
      return(NULL)

    matplot(data.frame(verificationData, svrPredict(trainingMatrix, testingMatrix, verificationData, accuracyFunction, 1, 0.1)),
            type = c("l"),
            col = 1:length(verificationData),
            xlab = config.ui$results$xlabel,
            ylab = config.ui$results$ylabel)
  })
}
