## shiny web app server

library(shiny)
library(shinyjs)
library(config)

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
ui.properties <- config::get(file = path.ui.conf)
server.properties <- config::get(file = path.server.conf)

function(input, output) {

  # return parameters selected by user
  setOptimizationParameters <- function() {
    selectedPredictionFn <- as.numeric(input$predictionAlgorithms)
    selectedOptimizationFn <- as.numeric(input$optimizationAlgorithms)

    predictParams <- server.properties$predictionAlgorithms[[selectedPredictionFn]]$predictionParameters
    optimParams <- server.properties$optimizationAlgorithms[[selectedOptimizationFn]]$optimizationParameters
    predictParamsCount <- length(predictParams)
    optimParamsCount <- length(optimParams)

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

  hideElements <- function() {
    shinyjs::disable("submitComputation")
    shinyjs::hideElement("resultLabel")
    shinyjs::hideElement("solutionLabel")
    shinyjs::hideElement("resultValues")
    shinyjs::hideElement("solutionValues")
    shinyjs::hideElement("resultPlot")
    shinyjs::hideElement("plotLabel")
    shinyjs::showElement("loading-spinner")
  }

  showElements <- function() {
    shinyjs::enable("submitComputation")
    shinyjs::showElement("resultLabel")
    shinyjs::showElement("solutionLabel")
    shinyjs::showElement("resultValues")
    shinyjs::showElement("solutionValues")
    shinyjs::showElement("resultPlot")
    shinyjs::showElement("plotLabel")
    shinyjs::hideElement("loading-spinner")
  }

  shinyjs::disable("submitComputation")
  shinyjs::hideElement("loading-spinner")


  # on measurementsPerDay change, disable button if period length consistency is broken
  observeEvent(input$measurementsPerDay, {
    shinyjs::disable("submitComputation")
    validate(
      need({
        try({
          dataRaw <- read.csv(file = input$inputFile$datapath, header = TRUE, sep = ",")
          dataTable <- table(as.Date(dataRaw$timestamp))
          length(dataTable[dataTable != as.numeric(input$measurementsPerDay)]) == 0
        }, silent = TRUE)
      }, "Value of measurementsPerDay differs from computed period size or timestamp is not parseable")
    )

    shinyjs::enable("submitComputation")
  })

  # on file select, disable button if data are not valid, otherwise render date ranges
  observeEvent(input$inputFile, {
    shinyjs::disable("submitComputation")
    validate(
      need({
        dataRaw <- read.csv(file = input$inputFile$datapath, header = TRUE, sep = ",", nrows = 1)
        "timestamp" %in% colnames(dataRaw) & "value" %in% colnames(dataRaw)
      }, "Missing column timestamp or value"),
      need({
        dataRaw <- read.csv(file = input$inputFile$datapath, header = TRUE, sep = ",")
        try({
          dataTable <- table(as.Date(dataRaw$timestamp))
          length(dataTable[dataTable != as.numeric(input$measurementsPerDay)]) == 0
        }, silent = TRUE)
      }, "Value of measurementsPerDay differs from computed period size or timestamp is not parseable")
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
      validate(
        need({input$trainingSetRange[1] <= input$trainingSetRange[2]}, "Date from must be earlier than date to"),
        need({input$testingSetRange[1] <= input$testingSetRange[2]}, "Date from must be earlier than date to"),
        need({input$trainingSetRange[2] < input$testingSetRange[1]}, "Date from must be earlier than date to")
      )
      shinyjs::enable("submitComputation")
    })

  # on optimization algoritm change render specific components
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

    output$resultLabel <- renderUI({
      HTML(paste("<h3>", ui.properties$results$valueLabel, "</h3>"))
    })
    output$solutionLabel <- renderUI({
      HTML(paste("<h3>", ui.properties$results$solutionLabel, "<h/3>"))
    })
    output$plotLabel <- renderUI({
      HTML(paste("<h2>", ui.properties$results$label, "</h2>"))
    })

    isolate({
      selectedPredictionFn <- as.numeric(input$predictionAlgorithms)
      selectedOptimizationFn <- as.numeric(input$optimizationAlgorithms)
      selectedFitnessFn <- as.numeric(input$fitnessFunction)

      preparedData <- data.prepare(pathToFile = input$inputFile$datapath,
                                   measurementsPerDay = input$measurementsPerDay,
                                   trainingSetRange = input$trainingSetRange,
                                   testingSetRange = input$testingSetRange)

      params.optimization <<- setOptimizationParameters()
      params.prediction <<- list(data = preparedData,
                                 prepareFn = server.properties$predictionAlgorithms[[selectedPredictionFn]]$prepareFn,
                                 predictFn = server.properties$predictionAlgorithms[[selectedPredictionFn]]$predictFn,
                                 predictDataFn = server.properties$predictionAlgorithms[[selectedPredictionFn]]$predictDataFn,
                                 errorFn = server.properties$fitnessFunctions[[selectedFitnessFn]]$errorFn)
      result <<- do.call(server.properties$optimizationAlgorithms[[selectedOptimizationFn]]$optimizeFn, list())
    })

    output$resultValues <- renderTable({
      dataTable <- data.frame()
      columnNames <- c()
      for(i in 1:length(server.properties$fitnessFunctions)) {
        params.prediction$errorFn <<- server.properties$fitnessFunctions[[i]]$errorFn
        dataTable <- rbind(dataTable, do.call(eval(parse(text = params.prediction$predictFn)), list(result$bestSolution)))
        columnNames <- c(columnNames, server.properties$fitnessFunctions[[i]]$label)
      }
      dataTable <- t(dataTable)
      dataTable <- rbind(columnNames, dataTable)
      dataTable <- t(dataTable)
      colnames(dataTable) <- ui.properties$results$fitnessColumns
      dataTable
    }, width = "auto", striped = TRUE, hover = TRUE)

    output$solutionValues <- renderTable({
      dataTable <- result$bestSolution
      if (server.properties$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$predictionParameters[[1]]$step %% 1 == 0)
        dataTable <- round(result$bestSolution)

      if (length(dataTable) == length(server.properties$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$parameterLabels)) {
        dataTable <- rbind(server.properties$predictionAlgorithms[[as.numeric(input$predictionAlgorithms)]]$parameterLabels, dataTable)
        dataTable <- t(dataTable)
        colnames(dataTable) <- ui.properties$results$solutionColumns
        dataTable
      }
    }, width = "auto", striped = TRUE, hover = TRUE)

    output$resultPlot <- renderPlot({
      matplot(data.frame(params.prediction$data$testingData$value, do.call(eval(parse(text = params.prediction$predictDataFn)), list(result$bestSolution))),
              type = c("l"),
              col = 1:length(params.prediction$data$testingData$value),
              xlab = ui.properties$results$xlabel,
              ylab = ui.properties$results$ylabel)
    })

    showElements()
  })
}
