## utility function to read labels for UI selectInput components

library(config)
server.properties <- config::get(file = path.server.conf)

# create named vector, where name of column is displayed in UI, value represent position in selectInput
labels.read <- function(property) {
  title <- c()
  values <- c()
  numberOfProperties <- length(property)

  for (l in 1:numberOfProperties) {
    title <- c(title, property[[l]]$label)
    values <- c(values, l)
  }
  
  result <- data.frame(title, values)
  result <- setNames(as.numeric(values), title)
  return(result)
}

labels.prediction <- labels.read(server.properties$predictionAlgorithms)
labels.optimization <- labels.read(server.properties$optimizationAlgorithms)
labels.fitness <- labels.read(server.properties$fitnessFunctions)
