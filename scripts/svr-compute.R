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

svrOptimize <- function(vectorOfParameters) {
  return(svrCompute(trainingMatrix, 
                    testingMatrix, 
                    verificationData, 
                    deviationFunction,
                    epsilonToOptimize = vectorOfParameters[1], 
                    CToOptimize = vectorOfParameters[2]))
}
