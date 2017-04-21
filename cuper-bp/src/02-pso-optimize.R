## optimalize PSO and return solution and result

# example function call
# result <- psoptimWraper(svrErrorWrapper, c(list(numberOfParticles = 10, maxIterations = 10, xmin = c(0.01, 0), xmax = c(2, 2))))
# result <- do.call("psoptimWrapper", list(svrErrorWrapper, c(list(numberOfParticles = 10, maxIterations = 10, xmin = c(0.01, 0), xmax = c(2, 2)))))

library(psoptim)
library(config)
pso.properties <- config::get("02-pso-optimize", file = pathToAppConfig)
server.properties <- config::get("server", file = pathToShinyConfig)

pso.optimizeFn <- function(params) {

  preparedData <- do.call(params.prediction$readDataFn, list(pathToFile = params.prediction$pathToFile,
                                                             measurementsPerDay = params.prediction$measurementsPerDay,
                                                             trainingSetProportion = params.prediction$trainingSetProportion))

  params.prediction <<- c(params.prediction, preparedData)

  result <- psoptim::psoptim(FUN = eval(parse(text = params.prediction$predictFn)),
                             n = params.optimization$numberOfParticles,
                             max.loop = params.optimization$maxIterations,
                             xmin = params.optimization$lows,
                             xmax = params.optimization$highs,
                             vmax = pso.properties$vmax,
                             anim = pso.properties$animation)

  return(list(minError = result$val, bestSolution = result$sol))
}
