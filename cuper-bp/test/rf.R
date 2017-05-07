## test random Forest

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

computeCycle <- function() {
  for (i in 1:count) {
    start.time <- Sys.time()
    actualTest <- data.frame()
    for (j in params.optimization$lows[1]:params.optimization$highs[1]) {
      for (k in params.optimization$lows[2]:params.optimization$highs[2]) {
        result <- do.call(params.prediction$predictFn, list(c(j, k)))
        actualTest <- rbind(actualTest, list(err = result, sol1 = j, sol2 = k))
      }
    }
    end.time <- Sys.time()
    print(Sys.time())
    tmp <- actualTest[which(actualTest$err == min(actualTest$err)), ]
    results <- rbind(results, list(err = tmp$err, sol1 = tmp$sol1, sol2 = tmp$sol2, stime = start.time, etime = end.time))
  }
}


params.optimization$maxIterations <- 100
params.optimization$numberOfParticles <- 20
params.optimization$lows <- c(5, 40)
params.optimization$highs <- c(20, 80)

selectedOptimizationFn <- 1
count <- 10
results <- data.frame()
compute()
statistics()


params.optimization$maxIterations <- 100
params.optimization$numberOfParticles <- 20
params.optimization$lows <- c(5, 40)
params.optimization$highs <- c(80, 200)

selectedOptimizationFn <- 1
count <- 10
results <- data.frame()
compute()
statistics()


params.optimization$maxIterations <- 100
params.optimization$numberOfParticles <- 20
params.optimization$lows <- c(1, 1)
params.optimization$highs <- c(40, 250)

selectedOptimizationFn <- 1
count <- 10
results <- data.frame()
compute()
statistics()


params.optimization$maxIterations <- 100
params.optimization$numberOfParticles <- 50
params.optimization$lows <- c(7, 1)
params.optimization$highs <- c(15, 400)

selectedOptimizationFn <- 1
count <- 10
results <- data.frame()
compute()
statistics()



params.optimization$maxIterations <- 100
params.optimization$foodNumber  <- 20
params.optimization$limit <- 20
params.optimization$lows <- c(5, 40)
params.optimization$highs <- c(20, 80)

selectedOptimizationFn <- 3
count <- 10
results <- data.frame()
compute()
statistics()


params.optimization$maxIterations <- 100
params.optimization$foodNumber  <- 20
params.optimization$limit <- 10
params.optimization$lows <- c(5, 80)
params.optimization$highs <- c(20, 200)

selectedOptimizationFn <- 3
count <- 10
results <- data.frame()
compute()
statistics()


params.optimization$maxIterations <- 100
params.optimization$foodNumber  <- 20
params.optimization$limit <- 10
params.optimization$lows <- c(1, 1)
params.optimization$highs <- c(40, 250)

selectedOptimizationFn <- 3
count <- 10
results <- data.frame()
compute()
statistics()


params.optimization$maxIterations <- 100
params.optimization$foodNumber  <- 50
params.optimization$limit <- 20
params.optimization$lows <- c(7, 1)
params.optimization$highs <- c(15, 400)

selectedOptimizationFn <- 3
count <- 10
results <- data.frame()
compute()
statistics()



params.optimization$lows <- c(5, 40)
params.optimization$highs <- c(20, 80)

count <- 10
results <- data.frame()
computeCycle()
statistics()


params.optimization$lows <- c(5, 80)
params.optimization$highs <- c(20, 200)

count <- 10
results <- data.frame()
computeCycle()
statistics()


params.optimization$lows <- c(1, 1)
params.optimization$highs <- c(40, 250)

count <- 10
results <- data.frame()
computeCycle()
statistics()


params.optimization$lows <- c(7, 1)
params.optimization$highs <- c(15, 400)

count <- 10
results <- data.frame()
computeCycle()
statistics()
