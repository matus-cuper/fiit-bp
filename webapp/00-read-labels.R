# utility function to read labels for UI

library(config)

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

predictionAlgorithmsLabels <- readLabels(config::get("server", file = "~/r/fiit-bp/webapp/config.yml")$predictionAlgorithms, 2)
optimizationAlgorithmsLabels <- readLabels(config::get("server", file = "~/r/fiit-bp/webapp/config.yml")$optimizationAlgorithms, 1)
fitnessFunctionsLabels <- readLabels(config::get("server", file = "~/r/fiit-bp/webapp/config.yml")$fitnessFunctions, 1)
