## compute SVR and return accuracy

library(kernlab)
library(config)
pathToConfig <- "~/r/fiit-bp/scripts/config.yml"
config.svr.optimize <- config::get("02-svr-optimize", file = pathToConfig)

# Set SVR parameters and return predicted data
svrPredict <- function(trainingMatrix, testingMatrix, verificationData, accuracyFunction, CToOptimize, epsilonToOptimize) {
  svrModel <- ksvm(value ~ .,
                   data = trainingMatrix,
                   type = config.svr.optimize$svmType,
                   kernel = config.svr.optimize$kernelFunction,
                   C = CToOptimize,
                   epsilon = epsilonToOptimize,
                   scaled = config.svr.optimize$scaled)

  return(predict(svrModel, testingMatrix))
}

# Set SVR parameters and return degree of accuracy
svrError <- function(trainingMatrix, testingMatrix, verificationData, accuracyFunction, CToOptimize, epsilonToOptimize) {
  svrModel <- ksvm(value ~ .,
                   data = trainingMatrix,
                   type = config.svr.optimize$svmType,
                   kernel = config.svr.optimize$kernelFunction,
                   C = CToOptimize,
                   epsilon = epsilonToOptimize,
                   scaled = config.svr.optimize$scaled)

  svrPredict <- predict(svrModel, testingMatrix)
  result <- do.call(accuracyFunction, list(svrPredict, verificationData))
  return(result)
}

# Used by optimization function, input is data.frame of two values representing epsilon and C
svrErrorWrapper <- function(params) {
  return(svrError(trainingMatrix,
                    testingMatrix,
                    verificationData,
                    accuracyFunction,
                    epsilonToOptimize = params[1],
                    CToOptimize = params[2]))
}
