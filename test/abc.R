params.optimization$foodNumber  <- 20
params.optimization$limit <- 100
params.optimization$lows <- c(5, 80)
params.optimization$highs <- c(20, 200)

params.prediction$errorFn <- "mape"
selectedOptimizationFn <- 3
count <- 5
results <- data.frame()

for (i in seq(2, 100, 2)) {
  params.optimization$maxIterations <- i
  for (j in 1:count) {
    start.time <- Sys.time()
    result <- do.call(server.properties$optimizationAlgorithms[[selectedOptimizationFn]]$optimizeFn, list())
    end.time <- Sys.time()
    print(Sys.time())
    results <- rbind(results, list(err = result$minError, sol1 = result$bestSolution[1], sol2 = result$bestSolution[2], stime = start.time, etime = end.time))
  }
}


params.optimization$foodNumber  <- 50
params.optimization$limit <- 100
params.optimization$lows <- c(5, 80)
params.optimization$highs <- c(20, 200)

params.prediction$errorFn <- "mape"
selectedOptimizationFn <- 3
count <- 5
results <- data.frame()

for (i in seq(2, 100, 2)) {
  params.optimization$maxIterations <- i
  for (j in 1:count) {
    start.time <- Sys.time()
    result <- do.call(server.properties$optimizationAlgorithms[[selectedOptimizationFn]]$optimizeFn, list())
    end.time <- Sys.time()
    print(Sys.time())
    results <- rbind(results, list(err = result$minError, sol1 = result$bestSolution[1], sol2 = result$bestSolution[2], stime = start.time, etime = end.time))
  }
}


stats <- data.frame()
for (i in seq(1, 500, 5)) {
  stats <- rbind(stats, list(time = round(mean(results$etime[i:(i+4)] - results$stime[i:(i+4)]), 2),
                             errmean = round(mean(results$err[i:(i+4)]), 2),
                             errsd = round(sd(results$err[i:(i+4)]), 2),
                             sol1mean = round(mean(results$sol1[i:(i+4)]), 2),
                             sol1sd = round(sd(results$sol1[i:(i+4)]), 2),
                             sol2mean = round(mean(results$sol2[i:(i+4)]), 2),
                             sol2sd = round(sd(results$sol2[i:(i+4)]), 2)))
}



params.prediction$errorFn <- "mape"
params.optimization$maxIterations <- 20
params.optimization$limit <- 100
params.optimization$lows <- c(5, 80)
params.optimization$highs <- c(20, 200)

selectedOptimizationFn <- 3
count <- 5
results <- data.frame()

for (i in seq(2, 100, 2)) {
  params.optimization$foodNumber <- i
  for (j in 1:count) {
    start.time <- Sys.time()
    result <- do.call(server.properties$optimizationAlgorithms[[selectedOptimizationFn]]$optimizeFn, list())
    end.time <- Sys.time()
    print(Sys.time())
    print(i)
    results <- rbind(results, list(err = result$minError, sol1 = result$bestSolution[1], sol2 = result$bestSolution[2], stime = start.time, etime = end.time))
  }
}


params.optimization$maxIterations <- 50
params.optimization$limit <- 100
params.optimization$lows <- c(5, 80)
params.optimization$highs <- c(20, 200)

selectedOptimizationFn <- 3
count <- 5

for (i in seq(2, 100, 2)) {
  params.optimization$foodNumber <- i
  for (j in 1:count) {
    start.time <- Sys.time()
    result <- do.call(server.properties$optimizationAlgorithms[[selectedOptimizationFn]]$optimizeFn, list())
    end.time <- Sys.time()
    print(Sys.time())
    print(i)
    results <- rbind(results, list(err = result$minError, sol1 = result$bestSolution[1], sol2 = result$bestSolution[2], stime = start.time, etime = end.time))
  }
}


stats <- data.frame()
for (i in seq(1, 500, 5)) {
  stats <- rbind(stats, list(time = round(mean(results$etime[i:(i+4)] - results$stime[i:(i+4)]), 2),
                             errmean = round(mean(results$err[i:(i+4)]), 2),
                             errsd = round(sd(results$err[i:(i+4)]), 2),
                             sol1mean = round(mean(results$sol1[i:(i+4)]), 2),
                             sol1sd = round(sd(results$sol1[i:(i+4)]), 2),
                             sol2mean = round(mean(results$sol2[i:(i+4)]), 2),
                             sol2sd = round(sd(results$sol2[i:(i+4)]), 2)))
}
