library(shiny)

fluidPage(

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
          "Regresné stromy" = 1,
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
          "Umelá kolónia včiel" = 1,
          "druhy" = 2),
        selected = 1
      )
    ),

    column(3,
      selectInput(
        "fitnessFunction",
        label = "Fitness funkcia",
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
        label = "Vstupné dáta"
      )
    ),

    column(3,
      sliderInput(
        "testDatasetSize",
        label = "Pomer testovacích dát",
        min = 0,
        max = 100,
        value = 60
      )
    )
  ),
    
  
  h3("Parametre predikčnej metódy"),
  
  textOutput("filename")
  
  # uiOutput("numberOfParameters")

)