## shiny web app ui

library(shiny)
library(shinyBS)
library(config)
library(dygraphs)

source(paste(path.shiny, "set-labels.R", sep = ""))
ui.properties <- config::get(file = path.ui.conf)

fluidPage(

  tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "plot.css")),
  
  titlePanel(ui.properties$titlePanelLabel),
  
  # application description
  fluidRow(
    column(12,
      p(ui.properties$descriptionPanelLabel)
    )
  ),
  
  # application settings, user can select prediction and optimization algoritmhs
  fluidRow(
    column(3,
      selectInput(
        "predictionAlgorithms",
        label = ui.properties$predictionAlgorithmsLabel,
        choices = labels.prediction
      )
    ),
    
    column(4,
      selectInput(
        "optimizationAlgorithms",
        label = ui.properties$optimizationAlgorithmsLabel,
        choices = labels.optimization
      )
    )
  ),
  
  # input data settings, date ranges will be shown only if selected file is validate
  fluidRow(
    column(3,
      fileInput(
        "inputFile",
        label = ui.properties$inputFileLabel,
        buttonLabel = ui.properties$inputFileButton,
        placeholder = ui.properties$inputFilePlaceholder,
        accept = c(
          "text/csv",
          "text/comma-separated-values,text/plain",
          ".csv")
      )
    ),
    
    column(3,
      numericInput(
        "measurementsPerDay",
        label = ui.properties$measurementsPerDay$label,
        min = ui.properties$measurementsPerDay$min,
        max = ui.properties$measurementsPerDay$max,
        value = ui.properties$measurementsPerDay$default
      )
    ),
    
    uiOutput("trainingSetRange"),
    
    uiOutput("testingSetRange")
  ),
  
  # optimization algorithm settings
  h2(ui.properties$optimizationParametersLabel),
  htmlOutput("descriptionOptimization"),
  htmlOutput("descriptionFitness"),
  
  column(2,
         selectInput(
           "fitnessFunction",
           label = ui.properties$fitnessFunctionsLabel,
           choices = labels.fitness
         )
  ),
  
  uiOutput("optimizationParameters"),
  
  # prediction algorithm settings
  h2(ui.properties$predictionParametersLabel),
  htmlOutput("descriptionPrediction"),
  
  uiOutput("predictionParameters"),
  
  # submit button setup
  shinyjs::useShinyjs(),
  fluidRow(
    column(1,
      actionButton("submitComputation",
                   ui.properties$submitButtonLabel,
                   style = "color: #fff; background-color: #337ab7; border-color: #2e6da4;")
    ),
    column(3,
      textOutput("validationMessage")
    )
  ),
  
  # spinner
  div(id = "plot-container",
      tags$img(src = "spinner.gif",
               id = "loading-spinner")
      ),
  
  # application output
  fluidRow(
    column(5,
      htmlOutput("solutionLabel")
    ),
    column(5,
      htmlOutput("resultLabel")
    )
  ),
  
  fluidRow(
    column(5,
      tableOutput("solutionValues")
    ),
    column(5,
      tableOutput("resultValues")
    )
  ),
  
  htmlOutput("plotLabel"),
  dygraphOutput("resultDygraph"),
  
  # tooltips for most of components
  bsTooltip(id = "predictionAlgorithms", title = ui.properties$tooltips$predictionAlgorithms, trigger = "hover", placement = "top"),
  bsTooltip(id = "optimizationAlgorithms", title = ui.properties$tooltips$optimizationAlgorithms, trigger = "hover", placement = "top"),
  bsTooltip(id = "inputFile", title = ui.properties$tooltips$inputFile, trigger = "hover", placement = "top"),
  bsTooltip(id = "measurementsPerDay", title = ui.properties$tooltips$measurementsPerDay, trigger = "hover", placement = "top"),
  bsTooltip(id = "trainingSetRange", title = ui.properties$tooltips$trainingSetRange, trigger = "hover", placement = "top"),
  bsTooltip(id = "testingSetRange", title = ui.properties$tooltips$testingSetRange, trigger = "hover", placement = "top"),
  bsTooltip(id = "fitnessFunction", title = ui.properties$tooltips$fitnessFunction, trigger = "hover", placement = "top")
)
