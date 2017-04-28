## prepare matrices for SVR

# Example call
# preparedData <- data.prepare(pathToFile = "~/r/fiit-bp/data/cleaned/99_UPLNE_CONVERTED_11D.csv", measurementsPerDay = 96,
#                              trainingSetRange = c("2013-07-01", "2013-07-10"), testingSetRange = c("2013-07-11", "2013-07-11"))
# values <- svr.prepareFn(preparedData)
# return 2 matrices representing training and testing set with (measurements per day + day per week) columns
# matrices are filled by 0 values, 1 is set only on place of measurement of day and on place day of week

# Convert given date into nth day in week
svr.nthInWeek <- function(date, frequency = 7) {
  result <- as.numeric(as.POSIXlt(date)$wday)
  for (i in 1:length(date)) {
    if (result[i] == 0)
      result[i] <- frequency
  }
  return(result)
}

# Convert time of the day to n-th measurement of the day
svr.orderOfTimestamp <- function(t1, measurementsPerDay) {
  t2 <- strptime(t1, "%Y-%m-%d %H:%M:%S")
  t3 <- as.numeric(format(t2, "%H")) + as.numeric(format(t2, "%M"))/60
  return(t3/24*measurementsPerDay)
}

# When measurement was performed, set 1 in matrix for that timestamp
svr.setOnesForTimestamp <- function(m, d, recordsCount, measurementsPerDay) {
  for (i in 1:recordsCount) {
    m[i, svr.orderOfTimestamp(d[i], measurementsPerDay) + 1] <- 1
  }
  return(m)
}

# When measurement was performed, set 1 in matrix for that day
svr.setOnesForDayOfWeek <- function(m, d, recordsCount, measurementsPerDay) {
  for (i in 1:recordsCount) {
    m[i, measurementsPerDay + svr.nthInWeek(d[i])] <- 1
  }
  return(m)
}

# Function will create trainning and testing matrices filled by one on position, 
# which represents when measurement was performed, matrices have for example 96 + 7 columns
# where 96 is number of measurements per day and 7 is count of days in the week,
# one row is full of zeros except of columns which represents day of the week when was measured 
# and n-th column, which represents n-th measurement in that day
# training matrix wil have size = records * trainingSetProportion 
# and testing matrix size = records - trainingRecords
svr.prepareFn <- function(preparedData) {
  # Compute matrices sizes
  daysPerWeek <- 7
  measurementsPerDay <- preparedData$measurementsPerDay
  trainingSetSize <- nrow(preparedData$trainingData)
  testingSetSize <- nrow(preparedData$testingData)
  trainingSetRecords <- preparedData$trainingData
  testingSetRecords <- preparedData$testingData

  # Create training matrix and rename its columns
  trainingM <- matrix(0, nrow = trainingSetSize, ncol = measurementsPerDay + daysPerWeek)
  trainingM <- svr.setOnesForTimestamp(trainingM, trainingSetRecords$timestamp, trainingSetSize, measurementsPerDay)
  trainingM <- svr.setOnesForDayOfWeek(trainingM, trainingSetRecords$timestamp, trainingSetSize, measurementsPerDay)
  colnames(trainingM) <- c(paste("V", 1:(measurementsPerDay + daysPerWeek), sep = ""))
  trainingM <- cbind(value=c(trainingSetRecords$value), trainingM)

  # Create testing matrix
  testingM <- matrix(0, nrow = testingSetSize, ncol = measurementsPerDay + daysPerWeek)
  testingM <- svr.setOnesForTimestamp(testingM, testingSetRecords$timestamp, testingSetSize, measurementsPerDay)
  testingM <- svr.setOnesForDayOfWeek(testingM, testingSetRecords$timestamp, testingSetSize, measurementsPerDay)
  colnames(testingM) <- c(paste("V", 1:(measurementsPerDay + daysPerWeek), sep = ""))

  return(list(trainingMatrix = trainingM, testingMatrix = testingM))
}
