## test ARIMA

compute <- function() {
  for (i in 1:count) {
    start.time <- Sys.time()
    result <- do.call(server.properties$optimizationAlgorithms[[selectedOptimizationFn]]$optimizeFn, list())
    end.time <- Sys.time()
    print(Sys.time())
    results <- rbind(results, list(err = result$minError, sol1 = result$bestSolution[1], sol2 = result$bestSolution[2], sol3 = result$bestSolution[3], stime = start.time, etime = end.time))
  }
}

statistics <- function() {
  round(mean(results$etime - results$stime), 2)
  round(mean(results$err), 2)
  round(sd(results$err), 2)
  round(mean(round(results$sol1)), 2)
  round(sd(round(results$sol1)), 2)
  round(mean(round(results$sol2)), 2)
  round(sd(round(results$sol2)), 2)
  round(mean(round(results$sol3)), 2)
  round(sd(round(results$sol3)), 2)
}

computeCycle <- function() {
  for (i in 1:count) {
    start.time <- Sys.time()
    actualTest <- data.frame()
    for (j in params.optimization$lows[1]:params.optimization$highs[1]) {
      for (k in params.optimization$lows[2]:params.optimization$highs[2]) {
        for (l in params.optimization$lows[3]:params.optimization$highs[3]) {
          result <- do.call(params.prediction$predictFn, list(c(j, k, l)))
          actualTest <- rbind(actualTest, list(err = result, sol1 = j, sol2 = k, sol3 = l))
        }
      }
    }
    end.time <- Sys.time()
    print(Sys.time())
    tmp <- actualTest[which(actualTest$err == min(actualTest$err)), ]
    results <- rbind(results, list(err = tmp$err, sol1 = tmp$sol1, sol2 = tmp$sol2, sol3 = tmp$sol3, stime = start.time, etime = end.time))
  }
}

computeAuto <- function() {
  for (i in 1:count) {
    start.time <- Sys.time()
    result <- auto.arima(params.prediction$trainingTimeSeries,
                         max.p = params.optimization$highs[1],
                         max.d = params.optimization$highs[2],
                         max.q = params.optimization$highs[3],
                         xreg = fourier(params.prediction$trainingTimeSeries, K = arima.properties$maximumOrder))
    err <- do.call(params.prediction$errorFn, list(result$fitted, params.prediction$data$testingData$value))
    end.time <- Sys.time()
    print(Sys.time())
    results <- rbind(results, list(err = err, sol1 = result$arma[1], sol2 = result$arma[6], sol3 = result$arma[2], stime = start.time, etime = end.time))
  }
}


params.optimization$maxIterations <- 20
params.optimization$numberOfParticles <- 10
params.optimization$lows <- c(1, 1, 1)
params.optimization$highs <- c(4, 4, 4)

selectedOptimizationFn <- 1
count <- 10
results <- data.frame()
compute()
statistics()


params.optimization$maxIterations <- 10
params.optimization$numberOfParticles <- 20
params.optimization$lows <- c(0, 0, 0)
params.optimization$highs <- c(3, 3, 3)

selectedOptimizationFn <- 1
count <- 10
results <- data.frame()
compute()
statistics()


params.optimization$maxIterations <- 20
params.optimization$numberOfParticles <- 20
params.optimization$lows <- c(0, 1, 0)
params.optimization$highs <- c(3, 5, 3)

selectedOptimizationFn <- 1
count <- 10
results <- data.frame()
compute()
statistics()



params.optimization$maxIterations <- 20
params.optimization$foodNumber  <- 10
params.optimization$limit <- 10
params.optimization$lows <- c(1, 1, 1)
params.optimization$highs <- c(4, 4, 4)

selectedOptimizationFn <- 3
count <- 10
results <- data.frame()
compute()
statistics()


params.optimization$maxIterations <- 10
params.optimization$foodNumber  <- 20
params.optimization$limit <- 5
params.optimization$lows <- c(0, 0, 0)
params.optimization$highs <- c(3, 3, 3)

selectedOptimizationFn <- 3
count <- 10
results <- data.frame()
compute()
statistics()



params.optimization$lows <- c(1, 1, 1)
params.optimization$highs <- c(4, 4, 4)

count <- 10
results <- data.frame()
computeCycle()
statistics()


params.optimization$lows <- c(0, 0, 0)
params.optimization$highs <- c(3, 3, 3)

count <- 10
results <- data.frame()
computeCycle()
statistics()



params.optimization$lows <- c(1, 1, 1)
params.optimization$highs <- c(4, 4, 4)

count <- 10
results <- data.frame()
computeAuto()
statistics()


params.optimization$lows <- c(0, 0, 0)
params.optimization$highs <- c(3, 3, 3)

count <- 10
results <- data.frame()
computeAuto()
statistics()