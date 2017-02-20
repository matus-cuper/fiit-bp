# read data from csv
tmp <- read.csv(file = "/home/mcuper/r/fiit-bp/data/suma_do_maj2015/99_UPLNE_DATA.CSV", sep = ",", header = TRUE)
tmp <- read.csv(file = "/home/mcuper/r/fiit-bp/data/suma_do_maj2015/99_UPLNE_DATA.csv", sep = ",", dec = ".", header = TRUE)

# set date to usable normal format
tmp$DATUM <- as.Date(tmp$DATUM, format = "%d/%m/%Y")

# set time to hours
tmp$CAS <- tmp$CAS / 60

# return day in week for specific date
weekdays(tmp$DATUM)

# names(tmp) return header

# create plot from first 96 values in tmp variable - one day plot
plot(head(tmp$CAS, 96), head(tmp$Suma_odbery, 96))

# create time series from data
plot(ts(head(tmp$Suma_odbery, 96)))

# create one graph with several times series
ts.plot(ts(head(tmp$Suma_odbery, 960), ts(head(tmp3$Suma_odbery, 960))))

# the same thins as above
x <- 0:96
ts.plot(ts(tmp$Suma_odbery[x]), ts(tmp3$Suma_odbery[x]))

# create 20 graphs of 20 weeks, after every week wait for input
for (w in c(0:19)) {
  a <- w*672 + 1
  b <- (w+1) * 672
  ts.plot(ts(tmp$Suma_odbery[a:b]), ts(tmp3$Suma_odbery[a:b]))
  print(tmp$DATUM[a])
  line <- readline()
}

# creating plots into bp
install.packages("Cairo")
library(Cairo)

dset <- read.csv("~/r/fiit-bp/data/fake_set1.csv")
trend <- ts(dset$trend, frequency = 12, start = c(1990, 2))
seasonal <- ts(dset$seasonal, frequency = 12, start = c(1990, 2))
random <- ts(dset$random, frequency = 12, start = c(1990, 2))

CairoPDF("trend_component.pdf")
ts.plot(trend, main = "Trendová zložka", xlab = "Čas", ylab = "Nameraná hodnota")
dev.off()

CairoPDF("season_component.pdf")
ts.plot(seasonal, main = "Sezónna zložka", xlab = "Čas", ylab = "Nameraná hodnota")
dev.off()

CairoPDF("random_component.pdf")
ts.plot(random, main = "Reziduálna zložka", xlab = "Čas", ylab = "Nameraná hodnota")
dev.off()

CairoPDF("add_model.pdf")
ts.plot(trend + seasonal + random, main = "Adítívny model", xlab = "Čas", ylab = "Nameraná hodnota")
dev.off()

CairoPDF("multi_model.pdf")
ts.plot(trend * seasonal * random, main = "Multiplikatívny model", xlab = "Čas", ylab = "Nameraná hodnota")
dev.off()

