## Collection of functions, which will represent fitness function and compute accuracy

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
