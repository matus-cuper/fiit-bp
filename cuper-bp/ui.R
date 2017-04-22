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

    uiOutput("trainingSetRange"),

    uiOutput("testingSetRange")
  ),


  h2(ui.properties$optimizationParametersLabel),
  column(3,
         selectInput(
           "fitnessFunction",
           label = ui.properties$fitnessFunctionsLabel,
           choices = labels.fitness
         )
  ),
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
