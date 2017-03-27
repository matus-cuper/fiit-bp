## optimalize PSO

library(psoptim)
library(config)
pathToConfig <- "~/r/fiit-bp/scripts/config.yml"
config.svr.psoptim <- config::get("03-svr-psoptim", file = pathToConfig)

psoptimWraper <- function(fn, params) {
  return(psoptim::psoptim(FUN = fn,
                 xmin = c(as.numeric(params[1]), as.numeric(params[2])),
                 xmax = c(as.numeric(params[3]), as.numeric(params[4])),
                 anim = config.svr.psoptim$animation))
}

# startTime <- Sys.time()
# result <- psoptim(FUN = "svrErrorWrapper",
#                   n = config.svr.psoptim$numberOfParticles,
#                   max.loop = config.svr.psoptim$maxIterations,
#                   xmin = c(config.svr.psoptim$minValues$C, config.svr.psoptim$minValues$epsilon),
#                   xmax = c(config.svr.psoptim$maxValues$C, config.svr.psoptim$maxValues$epsilon),
#                   anim = config.svr.psoptim$animation)
# Sys.time() - startTime

# predictedValues <- svrCompute(trainingMatrix, testingMatrix, verificationData, accuracyFunction, result$sol[1], result$sol[2])
