## functions measuring errors, also represent fitness functions for optimization algorithms

# Example call
# preparedData <- data.prepare(pathToFile = "data/99_UPLNE_CONVERTED_11D.csv", measurementsPerDay = 96,
#                              trainingSetRange = c("2013-07-01", "2013-07-10"), testingSetRange = c("2013-07-11", "2013-07-11"))
# params.prediction <- list(data = preparedData, errorFn = "mape")
# params.prediction <- c(params.prediction, svr.prepareFn(preparedData))
# predictedData <- svr.predictDataFn(c(1, 0.1))
# errorSize <- mape(predictedData, params.prediction$data$testingData$value)
# In functions yhat is predicted value and y is real value

mfe <- function(yhat, y) {
  mean(yhat - y)
}

mae <- function(yhat, y) {
  mean(abs(yhat - y))
}

mpe <- function(yhat, y) {
  mean((yhat - y)/y)*100
}

mape <- function(yhat, y) {
  mean(abs((yhat - y)/y))*100
}

mse <- function(yhat, y) {
  mean((yhat - y)^2)
}
