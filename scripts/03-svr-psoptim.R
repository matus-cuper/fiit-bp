## optimilize PSO 

library(psoptim)
library(config)
pathToConfig <- "~/r/fiit-bp/scripts/config.yml"
conf03 <- config::get("03-svr-psoptim", file = pathToConfig)

# startTime <- Sys.time()
result <- psoptim(FUN = svrOptimize, 
                  n = conf03$numberOfParticles, 
                  max.loop = conf03$maxIterations, 
                  xmin = c(conf03$minValues$C, conf03$minValues$epsilon), 
                  xmax = c(conf03$maxValues$C, conf03$maxValues$epsilon), 
                  anim = conf03$animation)
# Sys.time() - startTime

predictedValues <- svrCompute(trainingMatrix, testingMatrix, verificationData, accuracyFunction, result$sol[1], result$sol[2])
