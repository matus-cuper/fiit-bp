## SVR with PSO

# When measurement was performed, set matrix record to 1
setHoursOnes <- function(m, iMax, jMax) {
  for (i in 1:iMax) {
    for (j in 1:jMax) {
      m[(i - 1) * jMax + j, j] <- 1
    }
  }
  return(m)
}

# When measurement was performed, set matrix day column to 1
setDaysOnes <- function(d, m, iMax, jMax) {
  for (i in 1:iMax) {
    for (j in 1:jMax) {
      m[(i - 1) * jMax + j, jMax + as.POSIXlt(d[(i - 1) * jMax+ j])$wday] <- 1
    }
  }
  return(m)
}



dataRaw <- read.csv("~/r/fiit-bp/data/suma_do_maj2015/99_UPLNE_CONVERTED.csv", header = TRUE, sep = ",")

measurementsPerDay <- 96
daysPerWeek <- 7
trainingSetSize <- 10
testingSetSize <- 1
trainingSetRecords <- measurementsPerDay * trainingSetSize
testingSetRecords <- measurementsPerDay * testingSetSize

trainingMatrix <- matrix(0, nrow = trainingSetRecords, ncol = measurementsPerDay + daysPerWeek)
rownames(trainingMatrix) <- dataRaw$value[1:trainingSetRecords]
colnames(trainingMatrix) <- c(seq(1, measurementsPerDay), "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
trainingMatrix <- setHoursOnes(trainingMatrix, trainingSetSize, measurementsPerDay)
trainingMatrix <- setDaysOnes(dataRaw$timtestamp[1:trainingSetRecords], trainingMatrix, trainingSetSize, measurementsPerDay)

stopifnot(trainingMatrix[1,1] == 1)
stopifnot(trainingMatrix[96,96] == 1)
stopifnot(trainingMatrix[1,97] == 1)
stopifnot(trainingMatrix[96,97] == 1)
stopifnot(trainingMatrix[97,98] == 1)

testingMatrix <- matrix(0, nrow = testingSetRecords, ncol = measurementsPerDay + daysPerWeek)
colnames(testingMatrix) <- c(seq(1, measurementsPerDay), "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
testingMatrix <- setHoursOnes(testingMatrix, testingSetSize, measurementsPerDay)
testingMatrix <- setDaysOnes(dataRaw$timtestamp[(trainingSetRecords+1):(trainingSetRecords+1+testingSetRecords)], testingMatrix, testingSetSize, measurementsPerDay)

stopifnot(testingMatrix[1,1] == 1)
stopifnot(testingMatrix[96,96] == 1)
stopifnot(testingMatrix[1,100] == 1)
stopifnot(testingMatrix[96,100] == 1)

#install.packages("kernlab")
#library(kernlab)
require(kernlab)

trainingMatrixWithoutLabel <- matrix(0, nrow = trainingSetRecords, ncol = measurementsPerDay + daysPerWeek)
colnames(trainingMatrixWithoutLabel) <- c(seq(1, measurementsPerDay), "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
trainingMatrixWithoutLabel <- setHoursOnes(trainingMatrixWithoutLabel, trainingSetSize, measurementsPerDay)
trainingMatrixWithoutLabel <- setDaysOnes(dataRaw$timtestamp[1:trainingSetRecords], trainingMatrixWithoutLabel, trainingSetSize, measurementsPerDay)


## PSO will set epsilon and C parameters for correcting model error
svrModel <- ksvm(value ~ ., data = trainingMatrix, type = "eps-svr", kernel = "rbfdot", epsilon = 0.1, C = 1)
ksvm(trainingMatrixWithoutLabel, trainingMatrix, type = "eps-svr", kernel = "rbfdot", epsilon = 0.1, C = 1, scaled = FALSE )


predict(ksvm(trainingMatrix), testingMatrix)

