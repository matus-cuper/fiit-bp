## optimalize PSO and return best solution and its error

library(psoptim)
library(config)
psoptim.properties <- config::get("04-psoptim-optimize", file = path.app.conf)
server.properties <- config::get(file = path.server.conf)

psoptim.optimizeFn <- function(params) {

  preparedData <- do.call(params.prediction$prepareFn, list(params.prediction$data))

  params.prediction <<- c(params.prediction, preparedData)

  result <- psoptim::psoptim(FUN = eval(parse(text = params.prediction$predictFn)),
                             n = params.optimization$numberOfParticles,
                             max.loop = params.optimization$maxIterations,
                             xmin = params.optimization$lows,
                             xmax = params.optimization$highs,
                             vmax = psoptim.properties$vmax,
                             anim = psoptim.properties$animation)

  return(list(minError = result$val, bestSolution = result$sol))
}
