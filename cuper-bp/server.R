## Shiny app server side

library(shiny)
library(shinyjs)
library(config)

source(paste(path.src, "00-svr-read-data.R", sep = ""))
source(paste(path.src, "00-arima-read-data.R", sep = ""))
source(paste(path.src, "00-svr-predict.R", sep = ""))
source(paste(path.src, "00-arima-predict.R", sep = ""))
source(paste(path.src, "01-measure-error.R", sep = ""))
source(paste(path.src, "02-psoptim-optimize.R", sep = ""))
source(paste(path.src, "02-pso-optimize.R", sep = ""))

ui.properties <- config::get(file = path.ui.conf)
server.properties <- config::get(file = path.server.conf)

function(input, output) {

  shinyjs::disable("submitComputation")

  observeEvent(input$inputFile, shinyjs::enable("submitComputation"))

  output$optimizationParameters <- renderUI({
    numberOfParameters <- as.numeric(server.properties$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$numberOfOptimizationParameters)
    fluidRow(
      lapply(1:numberOfParameters, function(i) {
        column(3,
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
  
  
  setOptimizationParameters <- function() {
    
    selectedPredictionFn <- as.numeric(input$predictionAlgorithms)
    selectedOptimizationFn <- as.numeric(input$optimizationAlgorithms)
    
    predictParamsCount <- server.properties$predictionAlgorithms[[selectedPredictionFn]]$numberOfPredictionParameters
    optimParamsCount <- server.properties$optimizationAlgorithms[[selectedOptimizationFn]]$numberOfOptimizationParameters
    predictParams <- server.properties$predictionAlgorithms[[selectedPredictionFn]]$predictionParameters
    optimParams <- server.properties$optimizationAlgorithms[[selectedOptimizationFn]]$optimizationParameters
    
    optimizationParams <- list()
    lows <- c()
    highs <- c()
    names <- list()
    values <- list()
    
    for (i in 1:predictParamsCount) {
      value <- eval(parse(text = paste("input", "$", predictParams[[i]]$id, sep = "")))
      
      if (grepl("^min", predictParams[[i]]$id)) {
        lows <- c(lows, value)
      } 
      else if (grepl("^max", predictParams[[i]]$id)) {
        highs <- c(highs, value)
      }
    }
    
    for (i in 1:optimParamsCount) {
      value <- eval(parse(text = paste("input", "$", optimParams[[i]]$id, sep = "")))
      
      names <- c(names, optimParams[[i]]$id)
      values <- c(values, value)
    }
    
    optimParams <- c(optimParams, as.list(setNames(list(lows), "lows")))
    optimParams <- c(optimParams, as.list(setNames(list(highs), "highs")))
    optimParams <- c(optimParams, as.list(setNames(values, names)))
    
    return(optimParams)
  }
  
  
  output$resultValues <- renderText({

    inputFile <- input$inputFile
    if (is.null(inputFile))
      return(NULL)

    input$submitComputation

    isolate({
      selectedPredictionFn <- as.numeric(input$predictionAlgorithms)
      selectedOptimizationFn <- as.numeric(input$optimizationAlgorithms)
      selectedFitnessFn <- as.numeric(input$fitnessFunction)
      
      params.optimization <<- setOptimizationParameters()
      params.prediction <<- list(pathToFile = input$inputFile$datapath,
                                 measurementsPerDay = input$measurementsPerDay,
                                 trainingSetProportion = input$trainingDatasetProportion,
                                 readDataFn = server.properties$predictionAlgorithms[[selectedPredictionFn]]$readDataFn,
                                 predictFn = server.properties$predictionAlgorithms[[selectedPredictionFn]]$predictFn,
                                 predictDataFn = server.properties$predictionAlgorithms[[selectedPredictionFn]]$predictDataFn,
                                 errorFn = server.properties$fitnessFunctions[[selectedFitnessFn]]$errorFn)
    })
    
    if (input$submitComputation > 0) {
      result <<- do.call(server.properties$optimizationAlgorithms[[selectedOptimizationFn]]$optimizeFn, list())
      result$minError
    }
  })
  
  
  output$resultSolutions <- renderDataTable({
    
    inputFile <- input$inputFile
    if (is.null(inputFile))
      return(NULL)
    
    input$submitComputation
    
    if (input$submitComputation > 0) {
      isolate({
        dataTable <- result$bestSolution
        colnames(dataTable) <- server.properties$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$parameterLabels
        dataTable
      })
    }
  })


  output$resultPlot <- renderPlot({

    inputFile <- input$inputFile
    if (is.null(inputFile))
      return(NULL)

    input$submitComputation

    if (input$submitComputation > 0) {
      matplot(data.frame(params.prediction$verificationData, do.call(eval(parse(text = params.prediction$predictDataFn)), list(result$bestSolution))),
              type = c("l"),
              col = 1:length(params.prediction$verificationData),
              xlab = ui.properties$results$xlabel,
              ylab = ui.properties$results$ylabel)
    }
  })

  output$resultLabel <- renderUI({
    inputFile <- input$inputFile
    if (is.null(inputFile))
      return(NULL)

    input$submitComputation

    if (input$submitComputation > 0)
      HTML(paste("<h2>", ui.properties$results$label, "</h2>", "<h3>", ui.properties$results$valueLabel, "</h3>"))
  })

  output$solutionLabel <- renderUI({
    inputFile <- input$inputFile
    if (is.null(inputFile))
      return(NULL)

    input$submitComputation

    if (input$submitComputation > 0)
      HTML(paste("<h3>", ui.properties$results$solutionLabel, "<h/3>"))
  })
}
