selectedPredictionFn <- 2
selectedOptimizationFn <- 3
selectedErrorFn <- "mape"
count <- 5

params.optimization$maxIterations <- 20
params.optimization$numberOfParticles <- 20
params.optimization$limit <- 10
params.optimization$lows <- c(0, 0, 0)
params.optimization$highs <- c(4, 4, 4)

results <- data.frame()
Sys.time()
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
    preparedData <- do.call(params.prediction$prepareFn, list(params.prediction$data))
    params.prediction <<- c(params.prediction, preparedData)

    result <- auto.arima(params.prediction$trainingTimeSeries,
                         max.p = params.optimization$highs[1],
                         max.d = params.optimization$highs[2],
                         max.q = params.optimization$highs[3],
                         xreg = fourier(params.prediction$trainingTimeSeries, K = arima.properties$maximumOrder))
    err <- do.call(params.prediction$errorFn, list(result$fitted, params.prediction$data$testingData$value))

    end.time <- Sys.time()
    print(Sys.time())
    results <- rbind(results, list(day = as.Date(as.Date("2013-07-01") + i + 31), err = err, sol1 = result$arma[1], sol2 = result$arma[6], sol3 = result$arma[2], stime = start.time, etime = end.time))
  }
  print(j)
  print(Sys.time())
}

results1 <- data.frame()


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
  preparedData <- do.call(params.prediction$prepareFn, list(params.prediction$data))
  params.prediction <<- c(params.prediction, preparedData)

  result <- auto.arima(params.prediction$trainingTimeSeries,
                       max.p = params.optimization$highs[1],
                       max.d = params.optimization$highs[2],
                       max.q = params.optimization$highs[3],
                       xreg = fourier(params.prediction$trainingTimeSeries, K = arima.properties$maximumOrder))
  err <- do.call(params.prediction$errorFn, list(result$fitted, params.prediction$data$testingData$value))
  end.time <- Sys.time()
  print(Sys.time())
  results1 <- rbind(results1, list(day = -1, err = err, sol1 = result$arma[1], sol2 = result$arma[6], sol3 = result$arma[2], stime = start.time, etime = end.time))

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

    res <- arima.predictFn(c(result$arma[1], result$arma[6], result$arma[2]))
    end.time <- Sys.time()
    results1 <- rbind(results1, list(day = i, err = res, sol1 = result$arma[1], sol2 = result$arma[6], sol3 = result$arma[2], stime = start.time, etime = end.time))
  }
  print(j)
  print(Sys.time())
}
