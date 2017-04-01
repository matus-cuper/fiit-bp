## optimalize PSO and return solution and result

# example function call
# result <- psoptimWraper(svrErrorWrapper, c(list(numberOfParticles = 10, maxIterations = 10, xmin = c(0.01, 0), xmax = c(2, 2))))
# result <- do.call("psoptimWrapper", list(svrErrorWrapper, c(list(numberOfParticles = 10, maxIterations = 10, xmin = c(0.01, 0), xmax = c(2, 2)))))

library(psoptim)
library(config)
pso.properties <- config::get("02-pso-optimize", file = pathToConfig)

pso.optimizeFn <- function(params) {
  
  return(psoptim::psoptim(FUN = fn,
                          n = params$numberOfParticles,
                          max.loop = params$maxIterations,
                          xmin = params$xmin,
                          xmax = params$xmax,
                          anim = conf03$animation))
}


# tmp <- svr.readDataFn("~/r/fiit-bp/data/cleaned/99_UPLNE_CONVERTED_11D.csv", 96, 0.9)
# svr.predictFn(c(tmp, CToOptimize = 1, epsilonToOptimize = 2, errorFn = "mape"))
# do.call("svr.predictFn", list( c(tmp, CToOptimize = 1, epsilonToOptimize = 2, errorFn = "mape") ))