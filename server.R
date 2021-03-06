## shiny web app server

library(shiny)
library(shinyjs)
library(config)
library(dygraphs)
library(xts)

source(paste(path.src, "00-read-data.R", sep = ""))

source(paste(path.src, "01-svr-prepare.R", sep = ""))
source(paste(path.src, "01-arima-prepare.R", sep = ""))
source(paste(path.src, "01-rf-prepare.R", sep = ""))

source(paste(path.src, "02-measure-error.R", sep = ""))

source(paste(path.src, "03-svr-predict.R", sep = ""))
source(paste(path.src, "03-arima-predict.R", sep = ""))
source(paste(path.src, "03-rf-predict.R", sep = ""))

source(paste(path.src, "04-psoptim-optimize.R", sep = ""))
source(paste(path.src, "04-pso-optimize.R", sep = ""))
source(paste(path.src, "04-abc-optimize.R", sep = ""))

source(paste(path.shiny, "bound-dates.R", sep = ""))
source(paste(path.shiny, "validate-input.R", sep = ""))

ui.properties <- config::get(file = path.ui.conf)
server.properties <- config::get(file = path.server.conf)

function(input, output) {
  
  # return parameters selected by user
  setOptimizationParameters <- function() {
    # load selected algorithms
    selectedPredictionFn <- as.numeric(input$predictionAlgorithms)
    selectedOptimizationFn <- as.numeric(input$optimizationAlgorithms)
    
    # load proper parameters
    predictParams <- server.properties$predictionAlgorithms[[selectedPredictionFn]]$predictionParameters
    optimParams <- server.properties$optimizationAlgorithms[[selectedOptimizationFn]]$optimizationParameters
    predictParamsCount <- length(predictParams)
    optimParamsCount <- length(optimParams)
    
    # create containter for output values
    optimizationParams <- list()
    lows <- c()
    highs <- c()
    names <- list()
    values <- list()
    
    # fill containter with min and max values selected by user, there is no validation check
    for (i in 1:predictParamsCount) {
      value <- eval(parse(text = paste("input", "$", predictParams[[i]]$id, sep = "")))
      
      if (grepl("^min", predictParams[[i]]$id)) {
        lows <- c(lows, value)
      }
      else if (grepl("^max", predictParams[[i]]$id)) {
        highs <- c(highs, value)
      }
    }
    
    # evaluate parameter names and create variables with that names
    for (i in 1:optimParamsCount) {
      value <- eval(parse(text = paste("input", "$", optimParams[[i]]$id, sep = "")))
      
      names <- c(names, optimParams[[i]]$id)
      values <- c(values, value)
    }
    
    # crate output variable
    optimParams <- c(optimParams, as.list(setNames(list(lows), "lows")))
    optimParams <- c(optimParams, as.list(setNames(list(highs), "highs")))
    optimParams <- c(optimParams, as.list(setNames(values, names)))
    
    return(optimParams)
  }
  
  # hide elements when computation is running
  hideElements <- function() {
    shinyjs::disable("submitComputation")
    shinyjs::hideElement("resultLabel")
    shinyjs::hideElement("solutionLabel")
    shinyjs::hideElement("resultValues")
    shinyjs::hideElement("solutionValues")
    shinyjs::hideElement("resultDygraph")
    shinyjs::hideElement("plotLabel")
    shinyjs::showElement("loading-spinner")
  }
  
  # show elements when app is ready for starting computation
  showElements <- function() {
    shinyjs::enable("submitComputation")
    shinyjs::showElement("resultLabel")
    shinyjs::showElement("solutionLabel")
    shinyjs::showElement("resultValues")
    shinyjs::showElement("solutionValues")
    shinyjs::showElement("resultDygraph")
    shinyjs::showElement("plotLabel")
    shinyjs::hideElement("loading-spinner")
  }
  
  # initial elements showup after application startup
  shinyjs::disable("submitComputation")
  shinyjs::hideElement("validationMessage")
  shinyjs::hideElement("loading-spinner")
  
  # on measurementsPerDay change, disable button if period length consistency is broken
  observeEvent(input$measurementsPerDay, {
    shinyjs::disable("submitComputation")
    output$validationMessage <- renderText({
      validate(
        need(validate.period(input$inputFile$datapath, input$measurementsPerDay), ui.properties$validation$period)
      )
      shinyjs::enable("submitComputation")
    })
  })
  
  # on file select, disable button if data are not valid, otherwise render date ranges
  observeEvent({
    input$inputFile
    input$measurementsPerDay
  }, {
    
    shinyjs::disable("submitComputation")
    if (!is.null(input$inputFile))
      shinyjs::showElement("validationMessage")
    output$validationMessage <- renderText({
      validate(
        need(validate.period(input$inputFile$datapath, input$measurementsPerDay), ui.properties$validation$period),
        need(validate.csv(input$inputFile$datapath), ui.properties$validation$csv),
        need(validate.file(input$inputFile$datapath), ui.properties$validation$file)
      )
      shinyjs::enable("submitComputation")
    })
    
    validate(
      need(validate.period(input$inputFile$datapath, input$measurementsPerDay), ui.properties$validation$period),
      need(validate.csv(input$inputFile$datapath), ui.properties$validation$csv),
      need(validate.file(input$inputFile$datapath), ui.properties$validation$file)
    )
    shinyjs::enable("submitComputation")
    
    dataRaw <- read.csv(file = input$inputFile$datapath, header = TRUE, sep = ",")
    dates <- unique(as.Date(dataRaw$timestamp))
    
    output$trainingSetRange <- renderUI({
      column(3,
        dateRangeInput(
          "trainingSetRange",
          label = ui.properties$trainingSetRange$label,
          separator = ui.properties$trainingSetRange$separator,
          format = ui.properties$trainingSetRange$format,
          min = dates.read(dates, 1),
          max = dates.read(dates, 4),
          start = dates.read(dates, 1),
          end = dates.read(dates, 2)
        )
      )
    })
    
    output$testingSetRange <- renderUI({
      column(3,
        dateRangeInput(
          "testingSetRange",
          label = ui.properties$testingSetRange$label,
          separator = ui.properties$testingSetRange$separator,
          format = ui.properties$testingSetRange$format,
          min = dates.read(dates, 1),
          max = dates.read(dates, 4),
          start = dates.read(dates, 3),
          end = dates.read(dates, 4)
        )
      )
    })
  })
  
  # on date ranges change, disable button if logical error is detected
  observeEvent({
    input$trainingSetRange
    input$testingSetRange}, {
      shinyjs::disable("submitComputation")
      output$validationMessage <- renderText({
        validate(
          validate.dates(input$trainingSetRange, input$testingSetRange)
        )
        shinyjs::enable("submitComputation")
      })
    })
  
  # on optimization algoritm change render specific components for specific parameters
  output$optimizationParameters <- renderUI({
    numberOfParameters <- length(server.properties$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$optimizationParameters)
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
  
  # on prediction algoritm change render specific components
  output$predictionParameters <- renderUI({
    numberOfParameters <- length(server.properties$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$predictionParameters)
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
  
  # on submit button click, start computation and render output components
  observeEvent(input$submitComputation, {
    if (is.null(input$inputFile) || input$submitComputation <= 0)
      return(NULL)
    
    hideElements()
    
    # show elements specific for result
    output$resultLabel <- renderUI({
      HTML(paste("<h3>", ui.properties$results$valueLabel, "</h3>"))
    })
    output$solutionLabel <- renderUI({
      HTML(paste("<h3>", ui.properties$results$solutionLabel, "<h/3>"))
    })
    output$plotLabel <- renderUI({
      HTML(paste("<h2>", ui.properties$results$label, "</h2>"))
    })
    
    # load algorithms selected by a user
    selectedPredictionFn <- as.numeric(input$predictionAlgorithms)
    selectedOptimizationFn <- as.numeric(input$optimizationAlgorithms)
    selectedFitnessFn <- as.numeric(input$fitnessFunction)
    params.optimization <<- setOptimizationParameters()
    
    # validate min and max values
    if (!validate.params(params.optimization$lows, params.optimization$highs)) {
      shinyjs::enable("submitComputation")
      shinyjs::showElement("validationMessage")
      shinyjs::hideElement("loading-spinner")
    }
    
    output$validationMessage <- renderText({
      validate(
        need(validate.params(params.optimization$lows, params.optimization$highs), ui.properties$validation$params)
      )
    })
    
    # if everything is OK, compute result
    if (validate.params(params.optimization$lows, params.optimization$highs)) {
      shinyjs::hideElement("validationMessage")
      isolate({
        preparedData <- data.prepare(pathToFile = input$inputFile$datapath,
                                     measurementsPerDay = input$measurementsPerDay,
                                     trainingSetRange = input$trainingSetRange,
                                     testingSetRange = input$testingSetRange)
        
        params.prediction <<- list(data = preparedData,
                                   prepareFn = server.properties$predictionAlgorithms[[selectedPredictionFn]]$prepareFn,
                                   predictFn = server.properties$predictionAlgorithms[[selectedPredictionFn]]$predictFn,
                                   predictDataFn = server.properties$predictionAlgorithms[[selectedPredictionFn]]$predictDataFn,
                                   errorFn = server.properties$fitnessFunctions[[selectedFitnessFn]]$errorFn)
        result <<- do.call(server.properties$optimizationAlgorithms[[selectedOptimizationFn]]$optimizeFn, list())
      })
      
      # render computed result in table with measured errors
      output$resultValues <- renderTable({
        dataTable <- data.frame()
        columnNames <- c()
        for(i in 1:length(server.properties$fitnessFunctions)) {
          params.prediction$errorFn <<- server.properties$fitnessFunctions[[i]]$errorFn
          dataTable <- rbind(dataTable, round(do.call(eval(parse(text = params.prediction$predictFn)), list(result$bestSolution)), 2))
          columnNames <- c(columnNames, server.properties$fitnessFunctions[[i]]$label)
        }
        dataTable <- t(dataTable)
        dataTable <- rbind(columnNames, dataTable)
        dataTable <- t(dataTable)
        colnames(dataTable) <- ui.properties$results$fitnessColumns
        dataTable
      }, width = "auto", striped = TRUE, hover = TRUE)
      
      # render computed result in table with best solution
      output$solutionValues <- renderTable({
        dataTable <- round(result$bestSolution, 2)
        if (server.properties$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$predictionParameters[[1]]$step %% 1 == 0)
          dataTable <- round(result$bestSolution)
        
        if (length(dataTable) == length(server.properties$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$parameterLabels)) {
          dataTable <- rbind(server.properties$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$parameterLabels, dataTable)
          dataTable <- t(dataTable)
          colnames(dataTable) <- ui.properties$results$solutionColumns
          dataTable
        }
      }, width = "auto", striped = TRUE, hover = TRUE)
      
      # render graphs with real and predicted values
      output$resultDygraph <- renderDygraph({
        realValues <- xts(x = params.prediction$data$testingData$value,
                          order.by = as.POSIXct(params.prediction$data$testingData$timestamp),
                          frequency = params.prediction$data$measurementsPerDay)
        
        predictedValues <- xts(x = unlist(do.call(eval(parse(text = params.prediction$predictDataFn)), list(result$bestSolution)), use.names = FALSE),
                               order.by = as.POSIXct(params.prediction$data$testingData$timestamp),
                               frequency = params.prediction$data$measurementsPerDay)
        
        dataToGraph <- cbind(realValues = realValues, predictedValues = predictedValues)
        dateForAnnotation <- params.prediction$data$testingData$timestamp
        
        dygraph(dataToGraph, main = "") %>%
          dySeries("realValues", label = ui.properties$results$dygraph$realValuesLabel, color = "black") %>%
          dySeries("predictedValues", label = ui.properties$results$dygraph$predictedValuesLabel, color = "red") %>%
          dyAnnotation(params.prediction$data$testingData$timestamp, text = ui.properties$results$dygraph$annotationLabel)
      })
      
      showElements()
    }
  })
  
  # show description for each group of elements
  output$descriptionFitness <- renderUI(HTML(server.properties$fitnessFunctions[[as.numeric(input$fitnessFunction)]]$description))
  output$descriptionOptimization <- renderUI(HTML(server.properties$optimizationAlgorithms[[as.numeric(input$optimizationAlgorithms)]]$description))
  output$descriptionPrediction <- renderUI(HTML(server.properties$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$description))
}
