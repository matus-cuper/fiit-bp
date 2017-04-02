## optimalize PSO and return solution and result

# example function call
# result <- psoptimWraper(svrErrorWrapper, c(list(numberOfParticles = 10, maxIterations = 10, xmin = c(0.01, 0), xmax = c(2, 2))))
# result <- do.call("psoptimWrapper", list(svrErrorWrapper, c(list(numberOfParticles = 10, maxIterations = 10, xmin = c(0.01, 0), xmax = c(2, 2)))))

library(psoptim)
library(config)
pso.properties <- config::get("02-pso-optimize", file = pathToConfig)

pso.optimizeFn <- function(params) {
  
  return(psoptim::psoptim(FUN = params$fn,
                          n = params$numberOfParticles,
                          max.loop = params$maxIterations,
                          xmin = params$xmin,
                          xmax = params$xmax,
                          anim = conf03$animation))
}
