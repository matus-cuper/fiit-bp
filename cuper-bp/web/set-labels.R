## utility function to read labels for UI

library(config)
server.properties <- config::get(file = path.server.conf)

labels.read <- function(property, numberOfProperties) {
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

labels.prediction <- labels.read(server.properties$predictionAlgorithms, server.properties$numberOfPredictionAlgorithms)
labels.optimization <- labels.read(server.properties$optimizationAlgorithms, server.properties$numberOfOptimizationAlgorithms)
labels.fitness <- labels.read(server.properties$fitnessFunctions, server.properties$numberOfFitnessFunctions)
