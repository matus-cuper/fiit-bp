## read data from CSV and prepare for ARIMA

# Example call
# values <- arima.readDataFn("~/r/fiit-bp/data/cleaned/99_UPLNE_CONVERTED_10D.csv", measurementsPerDay = 96, trainingSetProportion = 0.8)
# where values variable will contain 2 time series ts$trainingTimeSeries and ts$testingTimeSeries and
# third one will be data.frame of values from origin dataset needed for verification process

# Function will create trainning and testing timeseries filled by data from original CSV
# training time series size is (in days) floor(records * trainingSetProportion / measurementsPerDay)
# and testing time series is (in days) floor(records / measurementsPerDay) - trainingDays
arima.readDataFn <- function(pathToFile, measurementsPerDay, trainingSetProportion) {
  dataRaw <- read.csv(file = pathToFile, header = TRUE, sep = ",")

  # Compute timeseries sizes
  trainingSetDays <- floor((nrow(dataRaw) * trainingSetProportion) / measurementsPerDay)
  testingSetDays <- floor(nrow(dataRaw) / measurementsPerDay) - trainingSetDays
  
  # Create training time series
  trainingTS <- ts(dataRaw$value[1:(trainingSetDays*measurementsPerDay)], frequency = measurementsPerDay)

  # Create testing time series
  testingTS <- ts(dataRaw$value[(trainingSetDays * measurementsPerDay + 1):((trainingSetDays + testingSetDays)*measurementsPerDay)], frequency = measurementsPerDay)
  
  return(list(trainingTimeSeries = trainingTS, testingTimeSeries = testingTS, verificationData = dataRaw$value[(trainingSetDays * measurementsPerDay + 1):((trainingSetDays + testingSetDays)*measurementsPerDay)]))
}
