## compute SVR and return error

library(kernlab)
library(config)
svr.properties <- config::get("00-svr-predict", file = pathToConfig)

# Set SVR parameters and return predicted data
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

# Used by optimization function, input is data.frame of two values representing epsilon and C
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
