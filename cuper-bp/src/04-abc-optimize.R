## optimalize ABC and return solution and result

# example function call

library(ABCoptim)
library(config)
abc.properties <- config::get("04-abc-optimize", file = path.app.conf)
server.properties <- config::get(file = path.server.conf)

abc.optimizeFn <- function(params) {
  
  preparedData <- do.call(params.prediction$prepareFn, list(params.prediction$data))
  
  params.prediction <<- c(params.prediction, preparedData)
  
  result <- ABCoptim::abc_optim(par = params.optimization$lows,
                                fn = eval(parse(text = params.prediction$predictFn)),
                                lb = params.optimization$lows,
                                ub = params.optimization$highs,
                                FoodNumber = params.optimization$foodNumber,
                                limit = params.optimization$limit,
                                maxCycle = params.optimization$maxIterations,
                                criter = floor(params.optimization$maxIterations/2))

  return(list(minError = result$value, bestSolution = t(as.matrix(result$par))))
}
