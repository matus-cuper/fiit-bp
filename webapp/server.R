## Shiny app server side

library(shiny)
library(config)
ui.properties <- config::get("ui", file = "~/r/fiit-bp/webapp/config.yml")
server.properties <- config::get("server", file = "~/r/fiit-bp/webapp/config.yml")

function(input, output) {

  output$optimizationParameters <- renderUI({
    numberOfParameters <- as.numeric(server.properties$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$numberOfOptimizationParameters)
    fluidRow(
      lapply(1:numberOfParameters, function(i) {
        column(2,
               numericInput(server.properties$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$optimizationParameters[[i]]$id,
                            label = server.properties$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$optimizationParameters[[i]]$label,
                            value = as.numeric(server.properties$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$optimizationParameters[[i]]$value),
                            min = as.numeric(server.properties$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$optimizationParameters[[i]]$min),
                            max = as.numeric(server.properties$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$optimizationParameters[[i]]$max)
               )
        )
      })
    )
  })


  output$predictionParameters <- renderUI({
    numberOfParameters <- as.numeric(server.properties$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$numberOfPredictionParameters)
    fluidRow(
      lapply(1:numberOfParameters, function(i) {
        column(2,
               numericInput(server.properties$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$predictionParameters[[i]]$id,
                            label = server.properties$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$predictionParameters[[i]]$label,
                            value = server.properties$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$predictionParameters[[i]]$value,
                            min = server.properties$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$predictionParameters[[i]]$min,
                            max = server.properties$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$predictionParameters[[i]]$max,
                            step = server.properties$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$predictionParameters[[i]]$step
               )
        )
      })
    )
  })
  
  
  observeEvent({
    input$submitComputation
  }, {
    output$resultValues <- renderText({
      
      selectedAlgorithm <- as.numeric(input$predictionAlgorithms)
      numberOfParameters <- server.properties$predictionAlgorithms[[selectedAlgorithm]]$numberOfPredictionParameters
      parameters <- server.properties$predictionAlgorithms[[selectedAlgorithm]]$predictionParameters
        
      names <- list()
      values <- list()
      for (i in 1:numberOfParameters) {
        names <- c(names, parameters[[i]]$id)
          
        value <- eval(parse(text = paste("input", "$", parameters[[i]]$id, sep = "")))
        values <- c(values, value)
      }
      params.prediction <- as.list(setNames(values, names))
      
      
      selectedAlgorithm <- as.numeric(input$optimizationAlgorithms)
      numberOfParameters <- server.properties$optimizationAlgorithms[[selectedAlgorithm]]$numberOfOptimizationParameters
      parameters <- server.properties$optimizationAlgorithms[[selectedAlgorithm]]$optimizationParameters
      
      names <- list()
      values <- list()
      for (i in 1:numberOfParameters) {
        names <- c(names, parameters[[i]]$id)
        
        value <- eval(parse(text = paste("input", "$", parameters[[i]]$id, sep = "")))
        values <- c(values, value)
      }
      params.optimization <- as.list(setNames(values, names))

      params.optimization$numberOfParticles
      
    })
  })


  # output$resultValues <- renderText({
  #   inputFile <- input$inputFile
  #   if (is.null(inputFile))
  #     return(NULL)
  # 
  #   readFunction <<- server.properties$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$readDataFunction
  #   predictFunction <<- server.properties$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$predictFunction
  #   optimizeFunction <<- server.properties$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$optimizeFunction
  # 
  #   # Global assignment
  #   preparedData <- do.call(readFunction, list(inputFile$datapath, input$measurementsPerDay, input$testDatasetProportion))
  # 
  #   trainingMatrix <<- preparedData$trainingMatrix
  #   testingMatrix <<- preparedData$testingMatrix
  #   verificationData <<- preparedData$verificationData
  #   accuracyFunction <<- server.properties$fitnessFunctions[[as.numeric(input$fitnessFunction)]]$accuracyFunction
  # 
  #   reactiveComputation <<- reactive({ do.call(optimizeFunction, list(svrErrorWrapper, c(list(numberOfParticles = input$numberOfParticles,
  #                                                                    maxIterations = input$maxIterations,
  #                                                                    xmin = c(input$minC, input$minEpsilon),
  #                                                                    xmax = c(input$maxC, input$maxEpsilon)))))
  #   })
  # 
  #   result <- reactiveComputation()
  #   result$val
  # })


  output$resultPlot <- renderPlot({
    inputFile <- input$inputFile
    if (is.null(inputFile))
      return(NULL)

    result <- reactiveComputation()
    matplot(data.frame(verificationData, svrPredict(trainingMatrix, testingMatrix, verificationData, accuracyFunction, result$sol[1], result$sol[2])),
            type = c("l"),
            col = 1:length(verificationData),
            xlab = ui.properties$results$xlabel,
            ylab = ui.properties$results$ylabel)
  })
}
