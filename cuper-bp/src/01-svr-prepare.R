## read data from CSV and prepare matrices for SVR

# Example call
# values <- svr.readDataFn("~/r/fiit-bp/data/cleaned/99_UPLNE_CONVERTED_10D.csv", measurementsPerDay = 96, trainingSetProportion = 0.8)
# where values variable will contain 2 matrices matrices$trainingMatrix and matrices$testingMatrix and
# third one will be data.frame of values from origin dataset needed for verification process

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
    m[i, measurementsPerDay + as.POSIXlt(d[i])$wday + 1] <- 1
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

  return(list(trainingMatrix = trainingM, testingMatrix = testingM, verificationData = testingSetRecords$value))
}
