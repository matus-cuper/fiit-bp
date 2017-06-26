selectedPredictionFn <- 2
selectedOptimizationFn <- 3
selectedErrorFn <- "mape"
count <- 20

params.optimization$foodNumber <- 20
params.optimization$limit <- 10
params.optimization$maxIterations <- 20
params.optimization$lows <- c(0, 0, 0)
params.optimization$highs <- c(4, 4, 4)

results <- data.frame()



count <- 20
results1 <- data.frame()


for (j in 1:count) {
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

  actualTest <- data.frame()
  for (a in params.optimization$lows[1]:params.optimization$highs[1]) {
    for (b in params.optimization$lows[2]:params.optimization$highs[2]) {
      for (c in params.optimization$lows[3]:params.optimization$highs[3]) {
        result <- do.call(params.prediction$predictFn, list(c(a, b, c)))
        actualTest <- rbind(actualTest, list(err = result, sol1 = a, sol2 = b, sol3 = c))
      }
    }
  }

  tmp <- actualTest[which(actualTest$err == min(actualTest$err)), ]
  end.time <- Sys.time()
  results1 <- rbind(results1, list(day = as.Date(as.Date("2013-07-01") + i + 31), err = tmp$err, sol1 = tmp$sol1, sol2 = tmp$sol2, sol3 = tmp$sol3, stime = start.time, etime = end.time))

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

    res <- arima.predictFn(c(tmp$sol1, tmp$sol2, tmp$sol3))
    end.time <- Sys.time()
    results1 <- rbind(results1, list(day = i, err = res, sol1 = tmp$sol1, sol2 = tmp$sol2, sol3 = tmp$sol3, stime = start.time, etime = end.time))
  }
  print(j)
  print(Sys.time())
}
