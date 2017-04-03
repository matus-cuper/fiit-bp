## optimalize PSO and return solution and result

# example function call
# result <- psoptimWraper(svrErrorWrapper, c(list(numberOfParticles = 10, maxIterations = 10, xmin = c(0.01, 0), xmax = c(2, 2))))
# result <- do.call("psoptimWrapper", list(svrErrorWrapper, c(list(numberOfParticles = 10, maxIterations = 10, xmin = c(0.01, 0), xmax = c(2, 2)))))

library(psoptim)
library(config)
pso.properties <- config::get("02-pso-optimize", file = pathToConfig)
server.properties <- config::get("server", file = pathToShinyConfig)

pso.optimizeFn <- function(params) {
  
  selectedPredictionFn <- 1
  selectedFitnessFn <- 1

  params <- list(pathToFile = "~/r/fiit-bp/data/cleaned/99_UPLNE_CONVERTED_11D.csv",
                 measurementsPerDay = 96,
                 trainingSetProportion = 0.9,
                 readDataFn = server.properties$predictionAlgorithms[[as.numeric(selectedPredictionFn)]]$readDataFn,
                 predictFn = server.properties$predictionAlgorithms[[as.numeric(selectedPredictionFn)]]$predictFn,
                 errorFn = server.properties$fitnessFunctions[[as.numeric(selectedFitnessFn)]]$errorFn)

  params.optimization <- list(numberOfParticles = 10,
                              maxIterations = 20,
                              minC = 0.5,
                              maxC = 1.5,
                              minEpsilon = 0.05,
                              maxEpsilon = 0.2)

  preparedData <- do.call(readDataFn, list(pathToFile = params$pathToFile,
                                           measurementsPerDay = params$measurementsPerDay,
                                           trainingSetProportion = params$trainingSetProportion))

  params.prediction <<- c(preparedData, "errorFn" = params$errorFn)

  result <- psoptim::psoptim(FUN = eval(parse(text = predictFn)),
                             n = params.optimization$numberOfParticles,
                             max.loop = params.optimization$maxIterations,
                             xmin = c(params.optimization$minC, params.optimization$minEpsilon),
                             xmax = c(params.optimization$maxC, params.optimization$maxEpsilon),
                             anim = pso.properties$animation)

  return(list(minError = result$val, bestSolution = result$sol))
}
