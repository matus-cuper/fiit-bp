## test ARIMA

path.app.conf <- "conf/app-config.yml"
source("src/00-read-data.R")
source("src/01-arima-prepare.R")
source("src/02-measure-error.R")
source("src/03-arima-predict.R")

preparedData <- data.prepare(pathToFile = "data/90_UPLNE_CONVERTED_1W.csv", measurementsPerDay = 96,
                             trainingSetRange = c("2014-02-03", "2014-02-09"), testingSetRange = c("2014-02-10", "2014-02-10"))
params.prediction <- list(data = preparedData, errorFn = "mape")
params.prediction <- c(params.prediction, arima.prepareFn(preparedData))

lows <- c(3, 3, 3)
highs <- c(4, 4, 4)
test1 <- data.frame()

for (i in lows[1]:highs[1]) {
  for (j in lows[2]:highs[2]) {
    for (k in lows[3]:highs[3]) {
      test1 <- rbind(test1, list(p = i, d = j, q = k, result = arima.predictFn(c(i, j, k))))
    }
  }
}

test1[which(test1$result == min(test1$result)), ]
arima.predictFn(c(4, 1, 5))

