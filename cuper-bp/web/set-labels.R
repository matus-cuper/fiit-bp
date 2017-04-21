## utility function to read labels for UI

library(config)
ui.properties <- config::get("ui", file = pathToShinyConfig)
server.properties <- config::get("server", file = pathToShinyConfig)

readLabels <- function(property, numberOfProperties) {
  title <- c()
  values <- c()
  
  for (l in 1:numberOfProperties) {
    title <- c(title, property[[l]]$label)
    values <- c(values, l)
  }
  
  result <- data.frame(title, values)
  result <- setNames(as.numeric(values), title)
  return(result)
}

predictionAlgorithmsLabels <- readLabels(server.properties$predictionAlgorithms, ui.properties$numberOfPredictionAlgorithms)
optimizationAlgorithmsLabels <- readLabels(server.properties$optimizationAlgorithms, ui.properties$numberOfOptimizationAlgorithms)
fitnessFunctionsLabels <- readLabels(server.properties$fitnessFunctions, ui.properties$numberOfFitnessFunctions)
