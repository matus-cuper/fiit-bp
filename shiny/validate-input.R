## utlity function for input data validation

library(config)
ui.properties <- config::get(file = path.ui.conf)

validate.file <- function(fileName) {
  try({
    read.csv(file = fileName, header = TRUE, sep = ",", nrows = 1)
    return(TRUE)
  }, silent = TRUE)
  return(FALSE)
}

validate.csv <- function(fileName) {
  try({
    dataRaw <- read.csv(file = fileName, header = TRUE, sep = ",", nrows = 1)
    if ("timestamp" %in% colnames(dataRaw) & "value" %in% colnames(dataRaw))
      return(TRUE)
  }, silent = TRUE)
  return(FALSE)
}

validate.period <- function(fileName, measurementsPerDay) {
  try({
    dataRaw <- read.csv(file = fileName, header = TRUE, sep = ",")
    dataTable <- table(as.Date(dataRaw$timestamp))
    if (length(dataTable[dataTable != as.numeric(measurementsPerDay)]) == 0)
      return(TRUE)
  }, silent = TRUE)
  return(FALSE)
}

validate.dates <- function(trainingRange, testingRange) {
  try({
    if (trainingRange[1] <= trainingRange[2]) {
      if (testingRange[1] <= testingRange[2]) {
        if (trainingRange[2] < testingRange[1])
          return(NULL)
      }  
    }
  }, silent = TRUE)
  return(ui.properties$validation$dates)
}

validate.params <- function(lows, highs) {
  for (i in 1:length(lows)) {
    if (lows[i] > highs[i])
      return(FALSE)
  }
  return(TRUE)
}
