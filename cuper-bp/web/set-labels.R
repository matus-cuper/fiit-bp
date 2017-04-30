## utility function to read labels for UI selectInput components

library(config)
server.properties <- config::get(file = path.server.conf)

# create named vector, where name of column is displayed in UI, value represent position in selectInput
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
