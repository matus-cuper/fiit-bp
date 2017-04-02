## compute SVR and return error

# tmp <- svr.readDataFn("~/r/fiit-bp/data/cleaned/99_UPLNE_CONVERTED_11D.csv", 96, 0.9)
# svr.predictFn(c(tmp, CToOptimize = 1, epsilonToOptimize = 2, errorFn = "mape"))
# do.call("svr.predictFn", list( c(tmp, CToOptimize = 1, epsilonToOptimize = 2, errorFn = "mape") ))

library(kernlab)
library(config)
svr.properties <- config::get("00-svr-predict", file = pathToConfig)

# Set SVR parameters, compute and return predicted values
svr.predict <- function(params) {
  svrModel <- ksvm(value ~ .,
                   data = params$trainingMatrix,
                   type = svr.properties$svmType,
                   kernel = svr.properties$kernelFunction,
                   C = params$CToOptimize,
                   epsilon = epsilonToOptimize,
                   scaled = svr.properties$scaled)
  return(predict(svrModel, params$testingMatrix))
}

# Used by optimization function
svr.predictFn <- function(params) {
  svrModel <- ksvm(value ~ .,
                   data = params$trainingMatrix,
                   type = svr.properties$svmType,
                   kernel = svr.properties$kernelFunction,
                   C = params$CToOptimize,
                   epsilon = params$epsilonToOptimize,
                   scaled = svr.properties$scaled)
  svrPrediction <- predict(svrModel, params$testingMatrix)
  return(do.call(params$errorFn, list(svrPrediction, params$verificationData)))
}
