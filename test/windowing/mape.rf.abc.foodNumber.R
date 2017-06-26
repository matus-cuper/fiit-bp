selectedPredictionFn <- 3
selectedOptimizationFn <- 3
selectedErrorFn <- "mape"
count <- 10

params.optimization$foodNumber <- 20
params.optimization$limit <- 10
params.optimization$maxIterations <- 20
params.optimization$lows <- c(5, 40)
params.optimization$highs <- c(20, 150)

s <- seq(15, 200, 15)
results <- data.frame()

for (k in s) {
  params.optimization$foodNumber <- k
  for (j in 1:count) {
    for (i in 0:30) {
      start.time <- Sys.time()
      preparedData <- data.prepare(pathToFile = "~/94_nitra_sum.csv",
                                   measurementsPerDay = 96,
                                   trainingSetRange = c(as.Date("2013-07-01") + i, as.Date("2013-07-01") + i + 30),
                                   testingSetRange = c(as.Date("2013-07-01") + i + 31, as.Date("2013-07-01") + i + 31))

      params.prediction <<- list(data = preparedData,
                                 prepareFn = server.properties$predictionAlgorithms[[selectedPredictionFn]]$prepareFn,
                                 predictFn = server.properties$predictionAlgorithms[[selectedPredictionFn]]$predictFn,
                                 predictDataFn = server.properties$predictionAlgorithms[[selectedPredictionFn]]$predictDataFn,
                                 errorFn = selectedErrorFn)
      result <- do.call(server.properties$optimizationAlgorithms[[selectedOptimizationFn]]$optimizeFn, list())
      end.time <- Sys.time()
      results <- rbind(results, list(day = as.Date(as.Date("2013-07-01") + i + 31), err = result$minError, sol1 = result$bestSolution[1], sol2 = result$bestSolution[2], stime = start.time, etime = end.time))

    }
    print(j)
    print(Sys.time())
  }
}

results1 <- data.frame()


for (k in s) {
  params.optimization$foodNumber <- k
  for (j in 1:count) {
    start.time <- Sys.time()
    preparedData <- data.prepare(pathToFile = "~/94_nitra_sum.csv",
                                 measurementsPerDay = 96,
                                 trainingSetRange = c(as.Date("2013-07-01"), as.Date("2013-07-01") + 30),
                                 testingSetRange = c(as.Date("2013-07-01") + 31, as.Date("2013-07-01") + 31))

    params.prediction <<- list(data = preparedData,
                               prepareFn = server.properties$predictionAlgorithms[[selectedPredictionFn]]$prepareFn,
                               predictFn = server.properties$predictionAlgorithms[[selectedPredictionFn]]$predictFn,
                               predictDataFn = server.properties$predictionAlgorithms[[selectedPredictionFn]]$predictDataFn,
                               errorFn = selectedErrorFn)
    result <- do.call(server.properties$optimizationAlgorithms[[selectedOptimizationFn]]$optimizeFn, list())
    end.time <- Sys.time()
    results1 <- rbind(results1, list(day = -1, err = result$minError, sol1 = result$bestSolution[1], sol2 = result$bestSolution[2], stime = start.time, etime = end.time))

    for (i in 0:30) {
      start.time <- Sys.time()
      preparedData <- data.prepare(pathToFile = "~/94_nitra_sum.csv",
                                   measurementsPerDay = 96,
                                   trainingSetRange = c(as.Date("2013-07-01") + i, as.Date("2013-07-01") + i + 30),
                                   testingSetRange = c(as.Date("2013-07-01") + i + 31, as.Date("2013-07-01") + i + 31))
      params.prediction <<- list(data = preparedData,
                                 prepareFn = server.properties$predictionAlgorithms[[selectedPredictionFn]]$prepareFn,
                                 predictFn = server.properties$predictionAlgorithms[[selectedPredictionFn]]$predictFn,
                                 predictDataFn = server.properties$predictionAlgorithms[[selectedPredictionFn]]$predictDataFn,
                                 errorFn = selectedErrorFn)
      preparedData <- do.call(params.prediction$prepareFn, list(params.prediction$data))
      params.prediction <<- c(params.prediction, preparedData)

      res <- rf.predictFn(c(result$bestSolution[1], result$bestSolution[2]))
      end.time <- Sys.time()
      results1 <- rbind(results1, list(day = i, err = res, sol1 = result$bestSolution[1], sol2 = result$bestSolution[2], stime = start.time, etime = end.time))
    }
    print(j)
    print(Sys.time())
  }
}
