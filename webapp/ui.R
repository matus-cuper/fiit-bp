library(shiny)
library(config)
config.ui <- config::get("ui", file = "~/r/fiit-bp/webapp/config.yml")
config.server <- config::get("server", file = "~/r/fiit-bp/webapp/config.yml")

fluidPage(

  titlePanel(config.ui$titlePanelLabel),


  fluidRow(
    column(3,
      p(config.ui$descriptionPanelLabel)
    )
  ),


  fluidRow(
    column(3,
      selectInput(
        "predictionAlgorithms",
        label = config.ui$predictionAlgorithmsLabel,
        choices = predictionAlgorithmsLabels
      )
    ),

    column(3,
      selectInput(
          "optimizationAlgorithms",
        label = config.ui$optimizationAlgorithmsLabel,
        choices = list(
          "Umelá kolónia včiel" = 1,
          "druhy" = 2),
        selected = 1
      )
    ),

    column(3,
      selectInput(
        "fitnessFunction",
        label = config.ui$fitnessFunctionsLabel,
        choices = list(
          "MAPE" = 1,
          "druha" = 2),
        selected = 1
      )
    )
  ),


  fluidRow(
    column(3,
      fileInput(
        "inputFile",
        label = config.ui$inputFileLabel
      )
    ),

    column(3,
      numericInput(
        "measurementsPerDay",
        label = config.ui$measurementsPerDay$label,
        min = config.ui$measurementsPerDay$min,
        max = config.ui$measurementsPerDay$max,
        value = config.ui$measurementsPerDay$default
      )
    ),

    column(3,
      sliderInput(
        "testDatasetProportion",
        label = config.ui$testDatasetProportion$label,
        min = config.ui$testDatasetProportion$min,
        max = config.ui$testDatasetProportion$max,
        value = config.ui$testDatasetProportion$default
      )
    )
  ),


  h3(config.ui$optimizationParametersLabel),
  uiOutput("optimizationParameters"),

  h3(config.ui$predictionParametersLabel),
  uiOutput("predictionParameters"),

  h3(config.ui$results$label),
  uiOutput("resultValues"),
  plotOutput("resultPlot")
)
