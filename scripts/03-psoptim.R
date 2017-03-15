## optimilize PSO 

library(psoptim)

n <- 10
m.l <- 20
xmin <- c(0.0, 0.0)
xmax <- c(1, 1)

startTime <- Sys.time()
result <- psoptim(FUN = svrOptimize, n = n, max.loop = m.l, xmin = xmin, xmax = xmax, anim = FALSE)
Sys.time() - startTime

predictedValues <- svrCompute(trainingMatrix, testingMatrix, verificationData, accuracyFunction, result$sol[1], result$sol[2])
