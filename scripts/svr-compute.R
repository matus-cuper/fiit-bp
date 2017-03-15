## compute SVR and return deviation

library(kernlab)

svrCompute <- function(trainingMatrix, testingMatrix, verificationData, deviationFunction, epsilonToOptimize, CToOptimize) {
  svrModel <- ksvm(value ~ ., 
                   data = trainingMatrix, 
                   type = "eps-svr", 
                   kernel = "rbfdot", 
                   epsilon = epsilonToOptimize, 
                   C = CToOptimize, 
                   scaled = FALSE)
  
  svrPredict <- predict(svrModel, testingMatrix)
  result <- do.call(deviationFunction, list(svrPredict, verificationData))
  return(result)
}

trainingMatrix <- values$trainingMatrix
testingMatrix <- values$testingMatrix
verificationData <- values$verificationData
source("~/r/fiit-bp/scripts/compute-deviation.R")
deviationFunction <- "mape"

svrOptimize <- function(params) {
  return(svrCompute(trainingMatrix, 
                    testingMatrix, 
                    verificationData, 
                    deviationFunction,
                    epsilonToOptimize = params[1], 
                    CToOptimize = params[2]))
}

