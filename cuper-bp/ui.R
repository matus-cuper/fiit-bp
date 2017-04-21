## Shiny app client side

library(shiny)
library(config)

source(paste(path.web, "set-labels.R", sep = ""))
ui.properties <- config::get(file = path.ui.conf)

fluidPage(

  titlePanel(ui.properties$titlePanelLabel),


  fluidRow(
    column(12,
      p(ui.properties$descriptionPanelLabel)
    )
  ),


  fluidRow(
    column(4,
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
    ),

    column(4,
      selectInput(
        "fitnessFunction",
        label = ui.properties$fitnessFunctionsLabel,
        choices = labels.fitness
      )
    )
  ),


  fluidRow(
    column(4,
      fileInput(
        "inputFile",
        label = ui.properties$inputFileLabel
      )
    ),

    column(4,
      numericInput(
        "measurementsPerDay",
        label = ui.properties$measurementsPerDay$label,
        min = ui.properties$measurementsPerDay$min,
        max = ui.properties$measurementsPerDay$max,
        value = ui.properties$measurementsPerDay$default
      )
    ),

    column(4,
      sliderInput(
        "trainingDatasetProportion",
        label = ui.properties$trainingDatasetProportion$label,
        min = as.numeric(ui.properties$trainingDatasetProportion$min),
        max = as.numeric(ui.properties$trainingDatasetProportion$max),
        value = as.numeric(ui.properties$trainingDatasetProportion$default)
      )
    )
  ),


  h2(ui.properties$optimizationParametersLabel),
  uiOutput("optimizationParameters"),

  h2(ui.properties$predictionParametersLabel),
  uiOutput("predictionParameters"),

  shinyjs::useShinyjs(),
  actionButton("submitComputation", ui.properties$submitButtonLabel),

  htmlOutput("resultLabel"),
  uiOutput("resultValues"),

  htmlOutput("solutionLabel"),
  dataTableOutput("resultSolutions"),
  plotOutput("resultPlot")
)
