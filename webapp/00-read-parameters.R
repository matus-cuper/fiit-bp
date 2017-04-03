## utility function to read component values from UI

library(config)
server.properties <- config::get("server", file = "~/r/fiit-bp/webapp/config.yml")

readPredictionParameters <- function(selectedAlgorithm) {
  numberOfParameters <- server.properties$predictionAlgorithms[[selectedAlgorithm]]$numberOfPredictionParameters
  parameters <- server.properties$predictionAlgorithms[[selectedAlgorithm]]$predictionParameters
  
  names <- list()
  values <- list()
  for (i in 1:numberOfParameters) {
    names <- c(names, parameters[[i]]$id)
    
    value <- eval(parse(text = paste("input", "$", parameters[[i]]$id, sep = "")))
    values <- c(values, value)
  }
  
  result <- as.list(setNames(values, names))
  return(result)
}

readOptimizationParameters <- function(selectedAlgorithm) {
  numberOfParameters <- server.properties$optimizationAlgorithms[[selectedAlgorithm]]$numberOfOptimizationParameters
  parameters <- server.properties$optimizationAlgorithms[[selectedAlgorithm]]$optimizationParameters
  
  names <- list()
  values <- list()
  for (i in 1:numberOfParameters) {
    names <- c(names, parameters[[i]]$id)
    
    value <- eval(parse(text = paste("input", "$", parameters[[i]]$id, sep = "")))
    values <- c(values, value)
  }
  
  result <- as.list(setNames(values, names))
  return(result)
}
