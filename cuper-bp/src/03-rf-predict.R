## compute random forest and return error

# Example call
# preparedData <- data.prepare(pathToFile = "~/r/fiit-bp/data/cleaned/99_UPLNE_CONVERTED_11D.csv", measurementsPerDay = 96,
#                              trainingSetRange = c("2013-07-01", "2013-07-10"), testingSetRange = c("2013-07-11", "2013-07-11"))
# params.prediction <- list(data = preparedData, errorFn = "mape")
# params.prediction <- c(params.prediction, rf.prepareFn(preparedData))
# errorSize <- rf.predictFn(c(20, 5))
# predictedData <- rfr.predictDataFn(c(20, 5))
# where params are number of trees to grow and minimum size of terminal nodes

library(randomForest)

# Set random forest parameters, compute and return predicted values
rf.predictDataFn <- function(params) {
  rfModel <- randomForest(value ~ .,
                          data = params.prediction$trainingDataFrame,
                          ntree = round(params[1]),
                          nodesize = round(params[2]))
  rfPrediction <- predict(rfModel, params.prediction$testingDataFrame)
  return(data.frame(rfPrediction))
}

# Used by optimization function
rf.predictFn <- function(params) {
  rfModel <- randomForest(value ~ .,
                          data = params.prediction$trainingDataFrame,
                          ntree = round(params[1]),
                          nodesize = round(params[2]))
  rfPrediction <- predict(rfModel, params.prediction$testingDataFrame)
  return(do.call(params.prediction$errorFn, list(rfPrediction, params.prediction$data$testingData$value)))
}
