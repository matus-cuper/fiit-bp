## optimilize PSO 2007

library(pso)

psoDefaultParameters <- c(1, 0.1)
lowerBound <- 0
upperBound <- 3

result <- psoptim(par = psoDefaultParameters, 
                  fn = svrOptimize, 
                  lower = lowerBound, 
                  upper = upperBound, 
                  control = list(trace = 1, REPORT = TRUE, maxit = 20, maxit.stagnate = 5, d = 0.01, v.max = 0.1))

predictedValues <- svrCompute(trainingMatrix, testingMatrix, verificationData, accuracyFunction, result$par[1], result$par[2])
