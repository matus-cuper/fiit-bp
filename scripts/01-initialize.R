# prepare global variables for optimizing

source("~/r/fiit-bp/scripts/00-measure-accuracy.R")
source("~/r/fiit-bp/scripts/00-svr-prepare.R")

svrPrepared <- readDataForSVR("~/r/fiit-bp/data/cleaned/99_UPLNE_CONVERTED_10D.csv", measurementsPerDay = 96, trainingSetProportion = 0.9)

trainingMatrix <- svrPrepared$trainingMatrix
testingMatrix <- svrPrepared$testingMatrix
verificationData <- svrPrepared$verificationData
accuracyFunction <- "mape"
