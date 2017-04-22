## compute SVR and return error

# tmp <- svr.readDataFn("~/r/fiit-bp/data/cleaned/99_UPLNE_CONVERTED_11D.csv", 96, 0.9)
# params.prediction <<- c(tmp, errorFn = "mape")
# svr.predictFn(c(1, 2))
# do.call("svr.predictFn", list(c(1, 2)))
# where 1 is C and 2 is epsilon

library(kernlab)
library(config)
svr.properties <- config::get("00-svr-predict", file = path.app.conf)

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
