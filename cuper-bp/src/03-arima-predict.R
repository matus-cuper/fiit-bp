## compute ARIMA and return error

# tmp <- arima.readDataFn("~/r/fiit-bp/data/cleaned/99_UPLNE_CONVERTED_11D.csv", 96, 0.9)
# params.prediction <<- c(tmp, errorFn = "mape")
# arima.predictFn(c(1, 2, 3))
# do.call("arima.predictFn", list(c(1, 2, 3)))
# where 1 is p, 2 is d and 3 is q

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
                            xreg = fourier(params.prediction$trainingTimeSeries,
                                           K = arima.properties$maximumOrder,
                                           h = nrow(params.prediction$testingTimeSeries)))
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
                            xreg = fourier(params.prediction$trainingTimeSeries,
                                           K = arima.properties$maximumOrder,
                                           h = nrow(params.prediction$testingTimeSeries)))
  return(do.call(params.prediction$errorFn, list(arimaForecast$mean, params.prediction$data$testingData$value)))
}
