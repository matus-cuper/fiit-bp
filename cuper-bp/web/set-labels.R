## utility function to read labels for UI

library(config)
server.properties <- config::get(file = path.server.conf)

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

predictionAlgorithmsLabels <- readLabels(server.properties$predictionAlgorithms, server.properties$numberOfPredictionAlgorithms)
optimizationAlgorithmsLabels <- readLabels(server.properties$optimizationAlgorithms, server.properties$numberOfOptimizationAlgorithms)
fitnessFunctionsLabels <- readLabels(server.properties$fitnessFunctions, server.properties$numberOfFitnessFunctions)
