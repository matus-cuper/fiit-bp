## read data from CSV and prepare for prediction prepare fucntions

# Example call
# preparedData <- data.prepare(pathToFile = "~/r/fiit-bp/data/cleaned/99_UPLNE_CONVERTED_11D.csv", measurementsPerDay = 96,
#                              trainingSetRange = c("2013-07-01", "2013-07-10"), testingSetRange = c("2013-07-11", "2013-07-11"))
# return 2 data frames representing training and testing set with columns timestamp and value, also return measurements per day

# read data and determine size of training and testing set
data.prepare <- function(pathToFile, measurementsPerDay, trainingSetRange, testingSetRange) {
  rawFile <- read.csv(file = pathToFile, header = TRUE, sep = ",")
  dataRaw <- data.frame(timestamp = rawFile$timestamp, value = rawFile$value)

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
