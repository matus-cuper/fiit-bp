## test SVR

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

computeTune <- function() {
  for (i in 1:count) {
    start.time <- Sys.time()
    svrModel <- tune.svm(value ~ .,
                         data = as.data.frame(params.prediction$trainingMatrix),
                         type = "eps",
                         cost = c(params.optimization$lows[1]:params.optimization$highs[1]),
                         epsilon = c(params.optimization$lows[2], params.optimization$highs[2]))
    svrPrediction <- predict(svrModel$best.model, params.prediction$testingMatrix)
    err <- do.call(params.prediction$errorFn, list(svrPrediction, params.prediction$data$testingData$value))
    end.time <- Sys.time()
    print(Sys.time())
    results <- rbind(results, list(err = err, sol1 = svrModel$best.parameters$cost, sol2 = svrModel$best.parameters$epsilon, stime = start.time, etime = end.time))
  }
}


params.optimization$maxIterations <- 50
params.optimization$numberOfParticles <- 20
params.optimization$lows <- c(20, 5)
params.optimization$highs <- c(100, 25)

selectedOptimizationFn <- 1
count <- 10
results <- data.frame()
compute()
statistics()


params.optimization$maxIterations <- 20
params.optimization$numberOfParticles <- 50
params.optimization$lows <- c(50, 0)
params.optimization$highs <- c(200, 5)

selectedOptimizationFn <- 1
count <- 10
results <- data.frame()
compute()
statistics()


params.optimization$maxIterations <- 20
params.optimization$numberOfParticles <- 20
params.optimization$lows <- c(200, 10)
params.optimization$highs <- c(300, 15)

selectedOptimizationFn <- 1
count <- 10
results <- data.frame()
compute()
statistics()


params.optimization$maxIterations <- 20
params.optimization$numberOfParticles <- 20
params.optimization$lows <- c(400, 10)
params.optimization$highs <- c(500, 30)

selectedOptimizationFn <- 1
count <- 10
results <- data.frame()
compute()
statistics()



params.optimization$maxIterations <- 10
params.optimization$foodNumber  <- 20
params.optimization$limit <- 5
params.optimization$lows <- c(20, 0)
params.optimization$highs <- c(50, 10)

selectedOptimizationFn <- 3
count <- 10
results <- data.frame()
compute()
statistics()


params.optimization$maxIterations <- 20
params.optimization$foodNumber  <- 50
params.optimization$limit <- 10
params.optimization$lows <- c(50, 0)
params.optimization$highs <- c(200, 5)

selectedOptimizationFn <- 3
count <- 10
results <- data.frame()
compute()
statistics()


params.optimization$maxIterations <- 20
params.optimization$foodNumber  <- 20
params.optimization$limit <- 10
params.optimization$lows <- c(200, 10)
params.optimization$highs <- c(300, 15)

selectedOptimizationFn <- 3
count <- 10
results <- data.frame()
compute()
statistics()


params.optimization$maxIterations <- 20
params.optimization$foodNumber  <- 20
params.optimization$limit <- 10
params.optimization$lows <- c(400, 10)
params.optimization$highs <- c(500, 30)

selectedOptimizationFn <- 3
count <- 10
results <- data.frame()
compute()
statistics()



params.optimization$lows <- c(20, 0)
params.optimization$highs <- c(50, 10)

count <- 10
results <- data.frame()
computeTune()
statistics()


params.optimization$lows <- c(50, 0)
params.optimization$highs <- c(200, 5)

count <- 10
results <- data.frame()
computeTune()
statistics()


params.optimization$lows <- c(200, 10)
params.optimization$highs <- c(300, 15)

count <- 10
results <- data.frame()
computeTune()
statistics()


params.optimization$lows <- c(400, 10)
params.optimization$highs <- c(500, 30)

count <- 10
results <- data.frame()
computeTune()
statistics()
