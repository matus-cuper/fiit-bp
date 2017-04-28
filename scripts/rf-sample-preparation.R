# Draw plot with legend of sample data preparation for randomForest

source("~/r/fiit-bp/cuper-bp/src/00-read-data.R")
source("~/r/fiit-bp/cuper-bp/src/01-rf-prepare.R")
path.app.conf <- "~/r/fiit-bp/cuper-bp/conf/app-config.yml"
preparedData <- data.prepare(pathToFile = "~/r/fiit-bp/data/cleaned/99_UPLNE_CONVERTED_11D.csv", measurementsPerDay = 96,
                             trainingSetRange = c("2013-07-01", "2013-07-10"), testingSetRange = c("2013-07-09", "2013-07-11"))

matplot(data.frame(rf.setSinForDay(preparedData$testingData$timestamp, preparedData$measurementsPerDay),
                   rf.setCosForDay(preparedData$testingData$timestamp, preparedData$measurementsPerDay),
                   rf.setSinForWeek(preparedData$testingData$timestamp, 7),
                   rf.setCosForWeek(preparedData$testingData$timestamp, 7)),
        type = c("l"), col = 1:length(preparedData$testingData$value), ylab = "Hodnota", xlab = "Pocet meraní")

legend("bottomleft", legend=c("sin(d)", "cos(d)", "sin(w)", "cos(w)"), pch=20, col=c(1, 2, 3, 4), horiz=TRUE)

