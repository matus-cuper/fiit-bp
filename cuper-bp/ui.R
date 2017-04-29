## Shiny app client side

library(shiny)
library(config)

source(paste(path.web, "set-labels.R", sep = ""))
ui.properties <- config::get(file = path.ui.conf)

fluidPage(

  tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "plot.css")),

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
  actionButton("submitComputation", ui.properties$submitButtonLabel, style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),

  htmlOutput("resultLabel"),
  uiOutput("resultValues"),

  htmlOutput("solutionLabel"),
  dataTableOutput("resultSolutions"),
  div(id = "plot-container",
      tags$img(src = "spinner.gif",
               id = "loading-spinner"),
      plotOutput("resultPlot")
  )
)
