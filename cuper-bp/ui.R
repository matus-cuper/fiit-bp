## shiny web app ui

library(shiny)
library(config)

source(paste(path.shiny, "set-labels.R", sep = ""))
ui.properties <- config::get(file = path.ui.conf)

fluidPage(

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

  # input data settings
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

  uiOutput("predictionParameters"),

  # submit button setup
  shinyjs::useShinyjs(),
  actionButton("submitComputation",
               ui.properties$submitButtonLabel,
               style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),

  # application output
  htmlOutput("resultLabel"),
  uiOutput("resultValues"),

  htmlOutput("solutionLabel"),
  tableOutput("resultSolutions"),

  plotOutput("resultPlot")
)
