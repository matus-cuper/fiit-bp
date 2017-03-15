# prepare global variables for optimizing

library(config)
pathToConfig <- "~/r/fiit-bp/scripts/config.yml"
conf01 <- config::get("01-initialize", file = pathToConfig)

source("~/r/fiit-bp/scripts/00-measure-accuracy.R")
source("~/r/fiit-bp/scripts/00-svr-prepare.R")

svrPrepared <- readDataForSVR(conf01$pathToData, measurementsPerDay = conf01$measurementsPerDay, trainingSetProportion = conf01$trainingSetProportion)

trainingMatrix <- svrPrepared$trainingMatrix
testingMatrix <- svrPrepared$testingMatrix
verificationData <- svrPrepared$verificationData
accuracyFunction <- conf01$accuracyFunction
