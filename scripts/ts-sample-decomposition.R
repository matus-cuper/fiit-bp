# Draw plot of sample data and do time series decomposition

source("~/r/fiit-bp/cuper-bp/src/00-read-data.R")
preparedData <- data.prepare(pathToFile = "~/r/fiit-bp/data/cleaned/94_UPLNE_CONVERTED.csv", measurementsPerDay = 96,
                             trainingSetRange = c("2013-09-01", "2013-09-30"), testingSetRange = c("2013-07-09", "2013-07-11"))

ts <- as.data.frame(stl(ts(preparedData$trainingData$value, frequency = 96), t.window = 7, s.window = "periodic", robust = TRUE)$time.series)

matplot(ts, type = c("l"), col = 1:length(ts), ylab = "Hodnota", xlab = "Poradie meraní")
matplot(preparedData$trainingData$value, type = c("l"), col = 1:length(ts$seasonal), ylab = "Hodnota", xlab = "Poradie meraní")

matplot(ts$seasonal, type = c("l"), col = 1:length(ts$seasonal), ylab = "Hodnota", xlab = "Poradie meraní")
matplot(ts$trend, type = c("l"), col = 1:length(ts$trend), ylab = "Hodnota", xlab = "Poradie meraní")
matplot(ts$remainder, type = c("l"), col = 1:length(ts$remainder), ylab = "Hodnota", xlab = "Poradie meraní")
