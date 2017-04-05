## Shiny app server side

library(shiny)
library(config)

source("~/r/fiit-bp/scripts/global.R")

source("~/r/fiit-bp/scripts/00-svr-read-data.R")
source("~/r/fiit-bp/scripts/00-arima-read-data.R")
source("~/r/fiit-bp/scripts/00-svr-predict.R")
source("~/r/fiit-bp/scripts/00-arima-predict.R")

source("~/r/fiit-bp/scripts/01-measure-error.R")

source("~/r/fiit-bp/scripts/02-pso-optimize.R")

ui.properties <- config::get("ui", file = pathToShinyConfig)
server.properties <- config::get("server", file = pathToShinyConfig)

function(input, output) {

  output$optimizationParameters <- renderUI({
    numberOfParameters <- as.numeric(server.properties$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$numberOfOptimizationParameters)
    fluidRow(
      lapply(1:numberOfParameters, function(i) {
        column(5,
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
        column(5,
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
  
  output$resultValues <- renderText({

    inputFile <- input$inputFile
    if (is.null(inputFile))
      return(NULL)

    input$submitComputation

    isolate({
      selectedPredictionFn <- as.numeric(input$predictionAlgorithms)
      selectedOptimizationFn <- as.numeric(input$optimizationAlgorithms)
      selectedFitnessFn <- as.numeric(input$fitnessFunction)

      numberOfParameters <- server.properties$predictionAlgorithms[[selectedPredictionFn]]$numberOfPredictionParameters
      parameters <- server.properties$predictionAlgorithms[[selectedPredictionFn]]$predictionParameters
      lows <- c()
      highs <- c()
      for (i in 1:numberOfParameters) {
        value <- eval(parse(text = paste("input", "$", parameters[[i]]$id, sep = "")))

        if (grepl("^min", parameters[[i]]$id)) {
          lows <- c(lows, value)
        } else if (grepl("^max", parameters[[i]]$id)) {
          highs <- c(highs, value)
        } else {
          cat("Unexpected error", file = stderr())
        }
      }
      params.optimization <- as.list(setNames(list(lows), "lows"))
      params.optimization <- c(params.optimization, as.list(setNames(list(highs), "highs")))

      numberOfParameters <- server.properties$optimizationAlgorithms[[selectedOptimizationFn]]$numberOfOptimizationParameters
      parameters <- server.properties$optimizationAlgorithms[[selectedOptimizationFn]]$optimizationParameters
      names <- list()
      values <- list()
      for (i in 1:numberOfParameters) {
        names <- c(names, parameters[[i]]$id)

        value <- eval(parse(text = paste("input", "$", parameters[[i]]$id, sep = "")))
        values <- c(values, value)
      }
      params.optimization <<- c(params.optimization, as.list(setNames(values, names)))

      params.prediction <<- list(pathToFile = input$inputFile$datapath,
                                 measurementsPerDay = input$measurementsPerDay,
                                 trainingSetProportion = input$trainingDatasetProportion,
                                 readDataFn = server.properties$predictionAlgorithms[[selectedPredictionFn]]$readDataFn,
                                 predictFn = server.properties$predictionAlgorithms[[selectedPredictionFn]]$predictFn,
                                 predictDataFn = server.properties$predictionAlgorithms[[selectedPredictionFn]]$predictDataFn,
                                 errorFn = server.properties$fitnessFunctions[[selectedFitnessFn]]$errorFn)

      result <- do.call(server.properties$optimizationAlgorithms[[selectedOptimizationFn]]$optimizeFn, list())

      result$minError
    })
  })


  output$resultPlot <- renderPlot({

    inputFile <- input$inputFile
    if (is.null(inputFile))
      return(NULL)

    input$submitComputation
    matplot(data.frame(params.prediction$verificationData, do.call(eval(parse(text = params.prediction$predictDataFn)), list(result$bestSolution))),
            type = c("l"),
            col = 1:length(verificationData),
            xlab = ui.properties$results$xlabel,
            ylab = ui.properties$results$ylabel)
  })
}
