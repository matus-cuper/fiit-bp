## collection of functions, which will represent fitness function and compute accuracy

# In function yhat is predicted value and y is real value
mape <- function(yhat, y) {
  mean(abs((yhat - y)/y))*100
}
