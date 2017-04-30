## prepare matrices for SVR

# Example call
# preparedData <- data.prepare(pathToFile = "~/r/fiit-bp/data/cleaned/99_UPLNE_CONVERTED_11D.csv", measurementsPerDay = 96,
#                              trainingSetRange = c("2013-07-01", "2013-07-10"), testingSetRange = c("2013-07-11", "2013-07-11"))
# values <- svr.prepareFn(preparedData)
# return 2 matrices representing training and testing set with (measurements per day + day per week) columns
# matrices are filled by 0 values, 1 is set only on place of measurement of day and on place day of week

# Convert given time into nth measurement in day
svr.nthInDay <- function(date, frequencyF) {
  measurementsPerHour <- frequencyF / 24
  minutesPerHour <- 60

  return((as.numeric(format(as.POSIXct(date), "%H")) * measurementsPerHour) +
           round(as.numeric(format(as.POSIXct(date), "%M")) / minutesPerHour * measurementsPerHour) + 1)
}

# Convert given date into nth day in week
svr.nthInWeek <- function(date, frequency = 7) {
  result <- as.numeric(as.POSIXlt(date)$wday)
  for (i in 1:length(date)) {
    if (result[i] == 0)
      result[i] <- frequency
  }
  return(result)
}

# When measurement was performed, set 1 in matrix for that timestamp
svr.setOnesForTimestamp <- function(matrixM, dates, measurementsPerDay) {
  for (i in 1:length(dates)) {
    matrixM[i, svr.nthInDay(dates[i], measurementsPerDay) + 1] <- 1
  }
  return(matrixM)
}

# When measurement was performed, set 1 in matrix for that day
svr.setOnesForDayOfWeek <- function(matrixM, dates, measurementsPerDay) {
  for (i in 1:length(dates)) {
    matrixM[i, measurementsPerDay + svr.nthInWeek(dates[i])] <- 1
  }
  return(matrixM)
}

# Function will create trainning and testing matrices filled by one on position, 
# which represents when measurement was performed, matrices have for example 96 + 7 columns
# where 96 is number of measurements per day and 7 is count of days in the week,
# one row is full of zeros except of two columns which represents day of the week when
# was measured and n-th column, which represents n-th measurement in that day
svr.prepareFn <- function(preparedData) {

  daysPerWeek <- 7
  measurementsPerDay <- preparedData$measurementsPerDay

  # Create training matrix and rename its columns
  trainingM <- matrix(0, nrow = nrow(preparedData$trainingData), ncol = measurementsPerDay + daysPerWeek)
  trainingM <- svr.setOnesForTimestamp(trainingM, preparedData$trainingData$timestamp, measurementsPerDay)
  trainingM <- svr.setOnesForDayOfWeek(trainingM, preparedData$trainingData$timestamp, measurementsPerDay)
  colnames(trainingM) <- c(paste("V", 1:(measurementsPerDay + daysPerWeek), sep = ""))
  trainingM <- cbind(value=c(preparedData$trainingData$value), trainingM)

  # Create testing matrix and rename its columns
  testingM <- matrix(0, nrow = nrow(preparedData$testingData), ncol = measurementsPerDay + daysPerWeek)
  testingM <- svr.setOnesForTimestamp(testingM, preparedData$testingData$timestamp, measurementsPerDay)
  testingM <- svr.setOnesForDayOfWeek(testingM, preparedData$testingData$timestamp, measurementsPerDay)
  colnames(testingM) <- c(paste("V", 1:(measurementsPerDay + daysPerWeek), sep = ""))

  return(list(trainingMatrix = trainingM, testingMatrix = testingM))
}
