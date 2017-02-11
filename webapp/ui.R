library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Optimalizácia konfiguračných parametrov predikčných metód"),
  
  fluidRow(
    column(3,
      p("popis tejto aplikacie, co robi na co je a ako sa pouziva")
    )
  ),
  
  fluidRow(
    column(3,
      selectInput(
        "predictionAlgorithms",
        label = "Predikčné algoritmy",
        choices = list(
          "prvy" = 1,
          "druhy" = 2,
          "treti" = 3),
        selected = 1
      )
    ),
    
    column(3,
      selectInput(
        "optimizationAlgorithms",
        label = "Optimalizačné algoritmy",
        choices = list(
          "prvy" = 1,
          "druhy" = 2),
        selected = 1
      )
    ),
    
    column(3,
      selectInput(
        "fitnessFunction",
        label = "Fitness funkcia",
        choices = list(
          "prva" = 1,
          "druha" = 2),
        selected = 1
      )
    )
  ),
  
  fluidRow(
    column(3,
      fileInput(
        "inputFile",
        label = "Vstupné dáta"
      )
    ),
    
    column(3,
      radioButtons(
        "someOptions",
        label = "Nejake vstupy",
        choices = list(
        "prvy" = 1,
        "druhy" = 2
        )
      )
    )
  ),
  
  fluidRow(
    h3("Parametre predikčnej metódy"),
    column(3,
      sliderInput(
        "paramter1",
        label = "parameter1",
        min = 0,
        max = 100,
        value = 20
      )
    ),
    
    column(3,
      tags$div(
        title = "A tu je tooltip ajhla",
        sliderInput(
          "parameter2",
          label = "Parameter 2",
          min = 1,
          max = 15,
          value = 12
        )
      )
    ),
    
    column(3,
      tags$div(
        title = "Another tooltip",
        htmlOutput("selectUI")
      )
      
    )
  ),
  
  mainPanel(plotOutput("random"))
  
))


# maybe use grid layout
