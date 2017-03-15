## compute SVR and return accuracy

library(kernlab)
library(config)
pathToConfig <- "~/r/fiit-bp/scripts/config.yml"
conf02 <- config::get("02-svr-optimize", file = pathToConfig)

# Set SVR parameters and return predicted data
svrCompute <- function(trainingMatrix, testingMatrix, verificationData, accuracyFunction, CToOptimize, epsilonToOptimize) {
  svrModel <- ksvm(value ~ ., 
                   data = trainingMatrix, 
                   type = conf02$svmType, 
                   kernel = conf02$kernelFunction, 
                   C = CToOptimize,
                   epsilon = epsilonToOptimize, 
                   scaled = conf02$scaled)
  
  return(predict(svrModel, testingMatrix))
}

# Set SVR parameters and return degree of accuracy
svrComputeError <- function(trainingMatrix, testingMatrix, verificationData, accuracyFunction, CToOptimize, epsilonToOptimize) {
  svrModel <- ksvm(value ~ ., 
                   data = trainingMatrix, 
                   type = conf02$svmType, 
                   kernel = conf02$kernelFunction, 
                   C = CToOptimize,                    
                   epsilon = epsilonToOptimize, 
                   scaled = conf02$scaled)
  
  svrPredict <- predict(svrModel, testingMatrix)
  result <- do.call(accuracyFunction, list(svrPredict, verificationData))
  return(result)
}

# Used by optimization function, input is data.frame of two values representing epsilon and C
svrOptimize <- function(params) {
  return(svrComputeError(trainingMatrix, 
                    testingMatrix, 
                    verificationData, 
                    accuracyFunction,
                    CToOptimize = params[2],
                    epsilonToOptimize = params[1]))
}

