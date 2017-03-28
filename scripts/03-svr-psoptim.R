## optimalize PSO
# example function call
# result <- psoptimWraper(svrErrorWrapper, c(list(numberOfParticles = 10, maxIterations = 10, xmin = c(0.01, 0), xmax = c(2, 2))))
# result <- do.call("psoptimWrapper", list(svrErrorWrapper, c(list(numberOfParticles = 10, maxIterations = 10, xmin = c(0.01, 0), xmax = c(2, 2)))))

library(psoptim)
library(config)
pathToConfig <- "~/r/fiit-bp/scripts/config.yml"
conf03 <- config::get("03-svr-psoptim", file = pathToConfig)

psoptimWrapper <- function(fn, params) {
  return(psoptim::psoptim(FUN = fn,
                          n = params$numberOfParticles,
                          max.loop = params$maxIterations,
                          xmin = params$xmin,
                          xmax = params$xmax,
                          anim = conf03$animation))
}
