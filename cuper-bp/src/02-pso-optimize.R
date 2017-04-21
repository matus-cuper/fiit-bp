## optimalize PSO and return solution and result

# example function call
# result <- psoptimWraper(svrErrorWrapper, c(list(numberOfParticles = 10, maxIterations = 10, xmin = c(0.01, 0), xmax = c(2, 2))))
# result <- do.call("psoptimWrapper", list(svrErrorWrapper, c(list(numberOfParticles = 10, maxIterations = 10, xmin = c(0.01, 0), xmax = c(2, 2)))))

library(pso)
library(config)
pso.properties <- config::get("02-pso-optimize", file = path.app.conf)
server.properties <- config::get(file = path.server.conf)

pso.optimizeFn <- function(params) {

  preparedData <- do.call(params.prediction$readDataFn, list(pathToFile = params.prediction$pathToFile,
                                                             measurementsPerDay = params.prediction$measurementsPerDay,
                                                             trainingSetProportion = params.prediction$trainingSetProportion))

  params.prediction <<- c(params.prediction, preparedData)

  result <- pso::psoptim(par = params.optimization$lows,
                         fn = eval(parse(text = params.prediction$predictFn)),
                         lower = params.optimization$lows,
                         upper = params.optimization$highs,
                         control = list(maxit = params.optimization$maxIterations,
                                        maxit.stagnate = floor(params.optimization$maxIterations/2),
                                        d = pso.properties$d,
                                        v.max = pso.properties$vmax,
                                        type = pso.properties$type))

  return(list(minError = result$value, bestSolution = t(as.matrix(result$par))))
}
