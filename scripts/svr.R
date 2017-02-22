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

# In function yhat is predicted value and y is real value
mape <- function(yhat, y) {
  mean(abs((yhat - y)/y))*100
}



dataRaw <- read.csv("~/r/fiit-bp/data/suma_do_maj2015/99_UPLNE_CONVERTED.csv", header = TRUE, sep = ",")

daysPerWeek <- 7
measurementsPerDay <- 96      # adept for paramater
trainingSetSize <- 10         # adept for paramater
testingSetSize <- 1           # adept for paramater

trainingSetRecords <- measurementsPerDay * trainingSetSize
testingSetRecords <- measurementsPerDay * testingSetSize

trainingMatrix <- matrix(0, nrow = trainingSetRecords, ncol = measurementsPerDay + daysPerWeek)
# rownames(trainingMatrix) <- dataRaw$value[1:trainingSetRecords]
# trainingMatrix[,1] <- dataRaw$value[1:trainingSetRecords] 
# colnames(trainingMatrix) <- c(seq(1, measurementsPerDay), "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
trainingMatrix <- setHoursOnes(trainingMatrix, trainingSetSize, measurementsPerDay)
trainingMatrix <- setDaysOnes(dataRaw$timtestamp[1:trainingSetRecords], trainingMatrix, trainingSetSize, measurementsPerDay)
colnames(trainingMatrix) <- c(paste("V", 1:(measurementsPerDay + daysPerWeek), sep = ""))

# stopifnot(trainingMatrix[1,1] == 1)
# stopifnot(trainingMatrix[96,96] == 1)
# stopifnot(trainingMatrix[1,97] == 1)
# stopifnot(trainingMatrix[96,97] == 1)
# stopifnot(trainingMatrix[97,98] == 1)

testingMatrix <- matrix(0, nrow = testingSetRecords, ncol = measurementsPerDay + daysPerWeek)
# colnames(testingMatrix) <- c(seq(1, measurementsPerDay), "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
testingMatrix <- setHoursOnes(testingMatrix, testingSetSize, measurementsPerDay)
testingMatrix <- setDaysOnes(dataRaw$timtestamp[(trainingSetRecords+1):(trainingSetRecords+1+testingSetRecords)], testingMatrix, testingSetSize, measurementsPerDay)
colnames(testingMatrix) <- c(paste("V", 1:(measurementsPerDay + daysPerWeek), sep = ""))

# stopifnot(testingMatrix[1,1] == 1)
# stopifnot(testingMatrix[96,96] == 1)
# stopifnot(testingMatrix[1,100] == 1)
# stopifnot(testingMatrix[96,100] == 1)

trainingMatrix <- cbind(value=c(dataRaw$value[1:trainingSetRecords]), trainingMatrix)
trainingMatrix <- data.frame(trainingMatrix)
# names(trainingMatrix)[-1] <- c("value") 

testingMatrix <- data.frame(testingMatrix)

# install.packages("kernlab")
# library(kernlab)
require(kernlab)

## PSO will set epsilon and C parameters for correcting model error
svrModel <- ksvm(value ~ ., data = trainingMatrix, type = "eps-svr", kernel = "rbfdot", epsilon = 0.1, C = 1, scaled = FALSE )
svrPredict <- predict(svrModel, testingMatrix)
mape(svrPredict, dataRaw$value[(trainingSetRecords+1):(trainingSetRecords+testingSetRecords)])
