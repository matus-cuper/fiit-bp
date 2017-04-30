## compute ARIMA and return error

# Example call
# preparedData <- data.prepare(pathToFile = "~/r/fiit-bp/data/cleaned/99_UPLNE_CONVERTED_11D.csv", measurementsPerDay = 96,
#                              trainingSetRange = c("2013-07-01", "2013-07-10"), testingSetRange = c("2013-07-11", "2013-07-11"))
# params.prediction <- list(data = preparedData, errorFn = "mape")
# params.prediction <- c(params.prediction, arima.prepareFn(preparedData))
# errorSize <- arima.predictFn(c(1, 1, 1))
# predictedData <- arima.predictDataFn(c(1, 1, 1))
# where params are p, d, q

library(forecast)
library(config)
arima.properties <- config::get("03-arima-predict", file = path.app.conf)

# Set ARIMA parameters, compute and return predicted values
arima.predictDataFn <- function(params) {
  arimaModel <- Arima(y = params.prediction$trainingTimeSeries,
                      order = c(p = round(params[1]),
                                d = round(params[2]),
                                q = round(params[3])),
                      xreg = fourier(params.prediction$trainingTimeSeries, K = arima.properties$maximumOrder))
  arimaForecast <- forecast(object = arimaModel,
                            h = nrow(params.prediction$testingTimeSeries),
                            xreg = fourier(params.prediction$testingTimeSeries, K = arima.properties$maximumOrder))
  return(data.frame(arimaForecast$mean))
}

# Used by optimization function
arima.predictFn <- function(params) {
  arimaModel <- arima(x = params.prediction$trainingTimeSeries,
                      order = c(p = round(params[1]),
                                d = round(params[2]),
                                q = round(params[3])),
                      xreg = fourier(params.prediction$trainingTimeSeries, K = arima.properties$maximumOrder))
  arimaForecast <- forecast(object = arimaModel,
                            h = nrow(params.prediction$testingTimeSeries),
                            xreg = fourier(params.prediction$testingTimeSeries, K = arima.properties$maximumOrder))
  return(do.call(params.prediction$errorFn, list(arimaForecast$mean, params.prediction$data$testingData$value)))
}
