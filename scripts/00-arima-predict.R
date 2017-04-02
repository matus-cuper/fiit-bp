## compute ARIMA and return error

# tmp <- svr.readDataFn("~/r/fiit-bp/data/cleaned/99_UPLNE_CONVERTED_11D.csv", 96, 0.9)
# svr.predictFn(c(tmp, CToOptimize = 1, epsilonToOptimize = 2, errorFn = "mape"))
# do.call("svr.predictFn", list( c(tmp, CToOptimize = 1, epsilonToOptimize = 2, errorFn = "mape") ))

library(forecast)

# Set ARIMA parameters, compute and return predicted values
arima.predict <- function(params) {
  arimaModel <- arima(x = params$trainingTimeSeries,
                      order = c(p = params$pToOptimize,
                                d = params$dToOptimize,
                                q = params$qToOptimize))
  return(forecast.Arima(arimaModel, h = 192))
}

# Used by optimization function
arima.predictFn <- function(params) {
  arimaModel <- arima(x = params$trainingTimeSeries,
                      order = c(p = params$pToOptimize,
                                d = params$dToOptimize,
                                q = params$qToOptimize))
  arimaForecast <- forecast.Arima(arimaModel, h = 192) 
  # add testing TS ?
  # add parameter h as testingTS size
  return(do.call(params$errorFn, list(c(arimaForecast$mean), params$verificationData)))  
}
