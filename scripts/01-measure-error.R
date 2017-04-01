## Collection of functions, which will represent fitness function and compute accuracy

# In functions yhat is predicted value and y is real value

mfe <- function(yhat, y) {
  0
}

mae <- function(yhat, y) {
  0
}

mpe <- function(yhat, y) {
  0
}

mape <- function(yhat, y) {
  mean(abs((yhat - y)/y))*100
}

mse <- function(yhat, y) {
  0
}
