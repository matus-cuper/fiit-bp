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
svr.readDataFn <- function(pathToFile, measurementsPerDay, trainingSetProportion) {
  dataRaw <- read.csv(file = pathToFile, header = TRUE, sep = ",")
  
  # Compute matrices sizes
  daysPerWeek <- 7
  trainingSetRecords <- round(nrow(dataRaw) * trainingSetProportion)
  testingSetRecords <- nrow(dataRaw) - trainingSetRecords

  # Create training matrix and rename its columns
  trainingM <- matrix(0, nrow = trainingSetRecords, ncol = measurementsPerDay + daysPerWeek)
  trainingM <- svr.setOnesForTimestamp(trainingM, dataRaw$timestamp[1:trainingSetRecords], trainingSetRecords, measurementsPerDay)
  trainingM <- svr.setOnesForDayOfWeek(trainingM, dataRaw$timestamp[1:trainingSetRecords], trainingSetRecords, measurementsPerDay)
  colnames(trainingM) <- c(paste("V", 1:(measurementsPerDay + daysPerWeek), sep = ""))
  trainingM <- cbind(value=c(dataRaw$value[1:trainingSetRecords]), trainingM)

  # Create testing matrix
  testingM <- matrix(0, nrow = testingSetRecords, ncol = measurementsPerDay + daysPerWeek)
  testingM <- svr.setOnesForTimestamp(testingM, dataRaw$timestamp[(trainingSetRecords + 1):nrow(dataRaw)], testingSetRecords, measurementsPerDay)
  testingM <- svr.setOnesForDayOfWeek(testingM, dataRaw$timestamp[(trainingSetRecords + 1):nrow(dataRaw)], testingSetRecords, measurementsPerDay)
  colnames(testingM) <- c(paste("V", 1:(measurementsPerDay + daysPerWeek), sep = ""))

  return(list(trainingMatrix = trainingM, testingMatrix = testingM, verificationData = dataRaw$value[(trainingSetRecords + 1):nrow(dataRaw)]))
}
