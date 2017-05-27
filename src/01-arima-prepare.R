## prepare timeseries for ARIMA

# Example call
# preparedData <- data.prepare(pathToFile = "data/99_UPLNE_CONVERTED_11D.csv", measurementsPerDay = 96,
#                              trainingSetRange = c("2013-07-01", "2013-07-10"), testingSetRange = c("2013-07-11", "2013-07-11"))
# values <- arima.prepareFn(preparedData)
# return 2 time series representing training and testing set
# time series frequency is set to measurements per day

# Function will create trainning and testing timeseries filled by values from preparedData
arima.prepareFn <- function(preparedData) {

  # Create training time series
  trainingTS <- ts(preparedData$trainingData$value, frequency = preparedData$measurementsPerDay)

  # Create testing time series
  testingTS <- ts(preparedData$testingData$value, frequency = preparedData$measurementsPerDay)

  return(list(trainingTimeSeries = trainingTS, testingTimeSeries = testingTS))
}
