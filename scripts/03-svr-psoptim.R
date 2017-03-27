## optimalize PSO

library(psoptim)
library(config)
pathToConfig <- "~/r/fiit-bp/scripts/config.yml"
conf03 <- config::get("03-svr-psoptim", file = pathToConfig)

psoptimWraper <- function(fn, params) {
  return(psoptim::psoptim(FUN = fn,
                          n = params$numberOfParticles,
                          max.loop = params$maxIterations,
                          xmin = params$xmin,
                          xmax = params$xmax,
                          anim = conf03$animation))
}

# Test func call
# result <- psoptimWraper(svrErrorWrapper, c(list(numberOfParticles = 10,
#                                                   maxIterations = 10,
#                                                   xmin = c(0, 0),
#                                                   xmax = c(2, 2))))

# startTime <- Sys.time()
# result <- psoptim(FUN = "svrErrorWrapper",
#                   n = conf03$numberOfParticles,
#                   max.loop = conf03$maxIterations,
#                   xmin = c(conf03$minValues$C, conf03$minValues$epsilon),
#                   xmax = c(conf03$maxValues$C, conf03$maxValues$epsilon),
#                   anim = conf03$animation)
# Sys.time() - startTime

# predictedValues <- svrCompute(trainingMatrix, testingMatrix, verificationData, accuracyFunction, result$sol[1], result$sol[2])
