selectedPredictionFn <- 3
selectedOptimizationFn <- 1
selectedErrorFn <- "mape"
count <- 5

params.optimization$maxIterations <- 20
params.optimization$numberOfParticles <- 20
params.optimization$limit <- 10
params.optimization$lows <- c(5, 40)
params.optimization$highs <- c(20, 150)

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
    rfModel <- tune.randomForest(value ~ .,
                                 data = as.data.frame(params.prediction$trainingDataFrame),
                                 ntree = c(params.optimization$lows[1]:params.optimization$highs[1]),
                                 nodesize = c(params.optimization$lows[2]:params.optimization$highs[2]))
    rfPrediction <- predict(rfModel$best.model, params.prediction$testingDataFrame)
    err <- do.call(params.prediction$errorFn, list(rfPrediction, params.prediction$data$testingData$value))

    end.time <- Sys.time()

    results <- rbind(results, list(day = as.Date(as.Date("2013-07-01") + i + 31), err = err, sol1 = rfModel$best.parameters$ntree, sol2 = rfModel$best.parameters$nodesize, stime = start.time, etime = end.time))
  }
  print(j)
  print(Sys.time())
}

count <- 20
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
  rfModel <- tune.randomForest(value ~ .,
                               data = as.data.frame(params.prediction$trainingDataFrame),
                               ntree = c(params.optimization$lows[1]:params.optimization$highs[1]),
                               nodesize = c(params.optimization$lows[2]:params.optimization$highs[2]))
  rfPrediction <- predict(rfModel$best.model, params.prediction$testingDataFrame)
  err <- do.call(params.prediction$errorFn, list(rfPrediction, params.prediction$data$testingData$value))

  end.time <- Sys.time()

  results1 <- rbind(results1, list(day = -1, err = err, sol1 = rfModel$best.parameters$ntree, sol2 = rfModel$best.parameters$nodesize, stime = start.time, etime = end.time))

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

    res <- rf.predictFn(c(rfModel$best.parameters$ntree, rfModel$best.parameters$nodesize))
    end.time <- Sys.time()
    results1 <- rbind(results1, list(day = i, err = res, sol1 = rfModel$best.parameters$ntree, sol2 = rfModel$best.parameters$nodesize, stime = start.time, etime = end.time))
  }
  print(j)
  print(Sys.time())
}
