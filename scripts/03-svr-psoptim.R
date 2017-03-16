## optimilize PSO 

library(psoptim)
library(config)
pathToConfig <- "~/r/fiit-bp/scripts/config.yml"
conf03 <- config::get("03-svr-psoptim", file = pathToConfig)

psoptimWraper <- function(fn, params) {
  return(psoptim::psoptim(FUN = fn,
                 xmin = c(as.numeric(params[1]), as.numeric(params[2])),
                 xmax = c(as.numeric(params[3]), as.numeric(params[4])),
                 anim = conf03$animation))
}

# startTime <- Sys.time()
# result <- psoptim(FUN = "svrErrorWrapper",
#                   n = conf03$numberOfParticles,
#                   max.loop = conf03$maxIterations,
#                   xmin = c(conf03$minValues$C, conf03$minValues$epsilon),
#                   xmax = c(conf03$maxValues$C, conf03$maxValues$epsilon),
#                   anim = conf03$animation)
# Sys.time() - startTime

# predictedValues <- svrCompute(trainingMatrix, testingMatrix, verificationData, accuracyFunction, result$sol[1], result$sol[2])
