## optimilize PSO 2007

library(pso)
library(config)
pathToConfig <- "~/r/fiit-bp/scripts/config.yml"
conf03 <- config::get("03-svr-pso-2007", file = pathToConfig)

startTime <- Sys.time()
result <- psoptim(par = psoDefaultParameters, 
                  fn = svrOptimize, 
                  lower = conf03$lowerBound, 
                  upper = conf03$upperBound, 
                  control = list(
                    trace = conf03$trace, 
                    REPORT = conf03$REPORT, 
                    s = conf03$numberOfParticles,
                    maxit = conf03$maxIterations, 
                    maxit.stagnate = conf03$maxStagnateIterations, 
                    d = conf03$diameter, 
                    v.max = conf03$maxVelocity))
Sys.time() - startTime

predictedValues <- svrCompute(trainingMatrix, testingMatrix, verificationData, accuracyFunction, result$par[1], result$par[2])
