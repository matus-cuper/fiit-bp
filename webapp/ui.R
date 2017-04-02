## Shiny app client side

library(shiny)
library(config)
ui.properties <- config::get("ui", file = "~/r/fiit-bp/webapp/config.yml")

source("~/r/fiit-bp/webapp/00-read-labels.R")

fluidPage(

  titlePanel(ui.properties$titlePanelLabel),


  fluidRow(
    column(3,
      p(ui.properties$descriptionPanelLabel)
    )
  ),


  fluidRow(
    column(3,
      selectInput(
        "predictionAlgorithms",
        label = ui.properties$predictionAlgorithmsLabel,
        choices = predictionAlgorithmsLabels
      )
    ),

    column(3,
      selectInput(
        "optimizationAlgorithms",
        label = ui.properties$optimizationAlgorithmsLabel,
        choices = optimizationAlgorithmsLabels
      )
    ),

    column(3,
      selectInput(
        "fitnessFunction",
        label = ui.properties$fitnessFunctionsLabel,
        choices = fitnessFunctionsLabels
      )
    )
  ),


  fluidRow(
    column(3,
      fileInput(
        "inputFile",
        label = ui.properties$inputFileLabel
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

    column(3,
      sliderInput(
        "trainingDatasetProportion",
        label = ui.properties$trainingDatasetProportion$label,
        min = as.numeric(ui.properties$trainingDatasetProportion$min),
        max = as.numeric(ui.properties$trainingDatasetProportion$max),
        value = as.numeric(ui.properties$trainingDatasetProportion$default)
      )
    )
  ),


  h3(ui.properties$optimizationParametersLabel),
  uiOutput("optimizationParameters"),

  h3(ui.properties$predictionParametersLabel),
  uiOutput("predictionParameters"),

  actionButton("submitComputation", ui.properties$submitButtonLabel),

  h3(ui.properties$results$label),
  uiOutput("resultValues"),
  plotOutput("resultPlot")
)
