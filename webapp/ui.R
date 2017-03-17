library(shiny)
library(config)
uiConfig <- config::get("ui", file = "~/r/fiit-bp/webapp/config.yml")

fluidPage(

  titlePanel(uiConfig$titlePanelLabel),

  
  fluidRow(
    column(3,
      p(uiConfig$descriptionPanelLabel)
    )
  ),

  
  fluidRow(
    column(3,
      selectInput(
        "predictionAlgorithms",
        label = uiConfig$predictionAlgorithmsLabel,
        choices = list(
          "Regresné stromy" = 1,
          "druhy" = 2,
          "treti" = 3),
        selected = 1
      )
    ),

    column(3,
      selectInput(
          "optimizationAlgorithms",
        label = uiConfig$optimizationAlgorithmsLabel,
        choices = list(
          "Umelá kolónia včiel" = 1,
          "druhy" = 2),
        selected = 1
      )
    ),

    column(3,
      selectInput(
        "fitnessFunction",
        label = uiConfig$fitnessFunctionsLabel,
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
        label = uiConfig$inputFileLabel
      )
    ),

    column(3,
      sliderInput(
        "testDatasetProportion",
        label = uiConfig$testDatasetProportion$label,
        min = uiConfig$testDatasetProportion$min,
        max = uiConfig$testDatasetProportion$max,
        value = uiConfig$testDatasetProportion$default
      )
    )
  ),
    
  
  h3(uiConfig$optimizationParametersLabel),
  uiOutput("optimizationParameters"),
  
  h3(uiConfig$predictionParametersLabel),
  uiOutput("predictionParameters"),
  
  h3(uiConfig$resultsLabel),
  uiOutput("resultValues"),
  uiOutput("resultPlot")
)