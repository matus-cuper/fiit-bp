## compute random forest and return erro

# Example call


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
