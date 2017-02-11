dset <- read.csv("~/r/fiit-bp/data/fake_set1.csv")

test <- function(f) {
  random <- ts(dset$random, frequency = f, start = c(1990, 2))
  ts.plot(random, main = "Reziduálna zložka", xlab = "Čas", ylab = "Nameraná hodnota")
}
