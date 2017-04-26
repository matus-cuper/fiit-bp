## read data from CSV and prepare for prediction fucntions

data.prepare <- function(pathToFile, measurementsPerDay, trainingSetRange, testingSetRange) {
  dataRaw <- read.csv(file = pathToFile, header = TRUE, sep = ",")
  
  startTrainingRange <- as.POSIXct(trainingSetRange[1])
  endTrainingRange <- as.POSIXct(trainingSetRange[2])
  startTestingRange <- as.POSIXct(testingSetRange[1])
  endTestingRange <- as.POSIXct(testingSetRange[2])

  attributes(startTrainingRange)$tzone <- "UTC"
  attributes(endTrainingRange)$tzone <- "UTC"
  attributes(startTestingRange)$tzone <- "UTC"
  attributes(endTestingRange)$tzone <- "UTC"

  allTrainingDates <- seq.POSIXt(from = startTrainingRange, to = endTrainingRange, by = "day")
  allTestingDates <- seq.POSIXt(from = startTestingRange, to = endTestingRange, by = "day")

  dataRaw <- (dataRaw[order(as.POSIXct(dataRaw$timestamp)), ])
  rownames(dataRaw) <- NULL

  return(list(trainingData = subset(dataRaw, as.Date(dataRaw$timestamp) %in% as.Date(allTrainingDates)),
              testingData = subset(dataRaw, as.Date(dataRaw$timestamp) %in% as.Date(allTestingDates)),
              measurementsPerDay = measurementsPerDay))
}
