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

# create plot from first 96 values in tmp variable
plot(head(tmp$CAS, 96), head(tmp$Suma_odbery, 96))

# create time series from data
plot(ts(head(tmp$Suma_odbery, 96)))