# Draw plot with legend of sample data preparation for randomForest

source("src/00-read-data.R")
source("src/01-rf-prepare.R")
path.app.conf <- "conf/app-config.yml"
preparedData <- data.prepare(pathToFile = "data/99_UPLNE_CONVERTED_11D.csv", measurementsPerDay = 96,
                             trainingSetRange = c("2013-07-01", "2013-07-10"), testingSetRange = c("2013-07-09", "2013-07-11"))

matplot(data.frame(rf.setSinForDay(preparedData$testingData$timestamp, preparedData$measurementsPerDay),
                   rf.setCosForDay(preparedData$testingData$timestamp, preparedData$measurementsPerDay),
                   rf.setSinForWeek(preparedData$testingData$timestamp, 7),
                   rf.setCosForWeek(preparedData$testingData$timestamp, 7)),
        type = c("l"), col = 1:length(preparedData$testingData$value), ylab = "Hodnota", xlab = "Pocet meraní")

legend("bottomleft", legend=c("sin(d)", "cos(d)", "sin(w)", "cos(w)"), pch=20, col=c(1, 2, 3, 4), horiz=TRUE)


matplot(data.frame(log(rf.nthInDay(preparedData$testingData$timestamp, preparedData$measurementsPerDay), base = preparedData$measurementsPerDay),
                   log(rf.nthInWeek(preparedData$testingData$timestamp, 7), base = 7)),
        type = c("l"), col = 1:length(preparedData$testingData$value), ylab = "Hodnota", xlab = "Pocet meraní")

legend("bottomright", legend=c("d - meranie v dni", "w - den  v tyzdni"), pch=20, col=c(1, 2, 3, 4), horiz=TRUE)
