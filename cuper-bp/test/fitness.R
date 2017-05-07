## test fitness

compute <- function() {
  for (i in 1:count) {
    start.time <- Sys.time()
    result <- do.call(server.properties$optimizationAlgorithms[[selectedOptimizationFn]]$optimizeFn, list())
    end.time <- Sys.time()
    print(Sys.time())
    results <- rbind(results, list(err = result$minError, sol1 = result$bestSolution[1], sol2 = result$bestSolution[2], stime = start.time, etime = end.time))
  }
}

statistics <- function() {
  round(mean(results$etime - results$stime), 2)
  round(mean(results$err), 2)
  round(sd(results$err), 2)
  round(mean(results$sol1), 2)
  round(sd(results$sol1), 2)
  round(mean(results$sol2), 2)
  round(sd(results$sol2), 2)
}


params.optimization$maxIterations <- 100
params.optimization$numberOfParticles <- 20
params.optimization$lows <- c(5, 40)
params.optimization$highs <- c(20, 80)

selectedOptimizationFn <- 1
params.prediction$errorFn <- "mae"
count <- 10
results <- data.frame()
compute()
statistics()


params.optimization$maxIterations <- 100
params.optimization$numberOfParticles <- 20
params.optimization$lows <- c(5, 40)
params.optimization$highs <- c(20, 80)

selectedOptimizationFn <- 1
params.prediction$errorFn <- "mape"
count <- 10
results <- data.frame()
compute()
statistics()


params.optimization$maxIterations <- 100
params.optimization$numberOfParticles <- 20
params.optimization$lows <- c(5, 40)
params.optimization$highs <- c(20, 80)

selectedOptimizationFn <- 1
params.prediction$errorFn <- "mse"
count <- 10
results <- data.frame()
compute()
statistics()



params.optimization$maxIterations <- 100
params.optimization$numberOfParticles <- 20
params.optimization$lows <- c(5, 80)
params.optimization$highs <- c(20, 200)

selectedOptimizationFn <- 1
params.prediction$errorFn <- "mae"
count <- 10
results <- data.frame()
compute()
statistics()


params.optimization$maxIterations <- 100
params.optimization$numberOfParticles <- 20
params.optimization$lows <- c(5, 80)
params.optimization$highs <- c(20, 200)

selectedOptimizationFn <- 1
params.prediction$errorFn <- "mape"
count <- 10
results <- data.frame()
compute()
statistics()


params.optimization$maxIterations <- 100
params.optimization$numberOfParticles <- 20
params.optimization$lows <- c(5, 80)
params.optimization$highs <- c(20, 200)

selectedOptimizationFn <- 1
params.prediction$errorFn <- "mse"
count <- 10
results <- data.frame()
compute()
statistics()
