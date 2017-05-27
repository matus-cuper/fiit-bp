## compute SVR and return error

# Example call
# preparedData <- data.prepare(pathToFile = "data/99_UPLNE_CONVERTED_11D.csv", measurementsPerDay = 96,
#                              trainingSetRange = c("2013-07-01", "2013-07-10"), testingSetRange = c("2013-07-11", "2013-07-11"))
# params.prediction <- list(data = preparedData, errorFn = "mape")
# params.prediction <- c(params.prediction, svr.prepareFn(preparedData))
# errorSize <- svr.predictFn(c(1, 0.1))
# predictedData <- svr.predictDataFn(c(1, 0.1))
# where params are C and epsilon

library(kernlab)
library(config)
svr.properties <- config::get("03-svr-predict", file = path.app.conf)

# Set SVR parameters, compute and return predicted values
svr.predictDataFn <- function(params) {
  svrModel <- ksvm(value ~ .,
                   data = params.prediction$trainingMatrix,
                   type = svr.properties$svmType,
                   kernel = svr.properties$kernelFunction,
                   C = params[1],
                   epsilon = params[2],
                   scaled = svr.properties$scaled)
  svrPrediction <- predict(svrModel, params.prediction$testingMatrix)
  return(data.frame(svrPrediction))
}

# Used by optimization function
svr.predictFn <- function(params) {
  svrModel <- ksvm(value ~ .,
                   data = params.prediction$trainingMatrix,
                   type = svr.properties$svmType,
                   kernel = svr.properties$kernelFunction,
                   C = params[1],
                   epsilon = params[2],
                   scaled = svr.properties$scaled)
  svrPrediction <- predict(svrModel, params.prediction$testingMatrix)
  return(do.call(params.prediction$errorFn, list(svrPrediction, params.prediction$data$testingData$value)))
}
