## prepare dataframes for random forest

# Example call
# preparedData <- data.prepare(pathToFile = "~/r/fiit-bp/data/cleaned/99_UPLNE_CONVERTED_11D.csv", measurementsPerDay = 96,
#                              trainingSetRange = c("2013-07-01", "2013-07-10"), testingSetRange = c("2013-07-11", "2013-07-11"))
# values <- rf.prepareFn(preparedData)
# return 2 data frames representing training and testing set
# each data frame has 5 columns, first one is respose variable,
# in testing data frame need to be computed, other columns represent
# timestamp of measurement as sinus and cosinus functions

# Convert given time into nth measurement in day
rf.nthInDay <- function(date, frequencyF) {
  measurementsPerHour <- frequencyF / 24
  minutesPerHour <- 60
  
  return((as.numeric(format(as.POSIXct(date), "%H")) * measurementsPerHour) + 
           round(as.numeric(format(as.POSIXct(date), "%M")) / minutesPerHour * measurementsPerHour) + 1)
}

# Convert given date into nth day in week
rf.nthInWeek <- function(date, frequencyF = 7) {
  result <- as.numeric(as.POSIXlt(date)$wday)
  for (i in 1:length(date)) {
    if (result[i] == 0)
      result[i] <- frequencyF
  }
  return(result)
}

# Represent measurements per day as sinus function
rf.setSinForDay <- function(dates, frequencyF) {
  return((sin(2 * pi * rf.nthInDay(dates, frequencyF) / frequencyF) + 1) / 2)
}

# Represent measurements per day as cosinus function
rf.setCosForDay <- function(dates, frequencyF) {
  return((cos(2 * pi * rf.nthInDay(dates, frequencyF) / frequencyF) + 1) / 2)
}

# Represent day per week as sinus function
rf.setSinForWeek <- function(dates, frequencyF) {
  return((sin(2 * pi * rf.nthInWeek(dates, frequencyF) / frequencyF) + 1) / 2)
}

# Represent day per week as cosinus function
rf.setCosForWeek <- function(dates, frequencyF) {
  return((cos(2 * pi * rf.nthInWeek(dates, frequencyF) / frequencyF) + 1) / 2)
}

# Function will create training and testing data frames with 5 columns,
# each data frame is filled by data from different ranges selected by user,
# the first column represents value of measurement, in testing data frame
# is present empty, random forest has to computes it, the second column is
# transformation of sequence of measurements into sinus function, if the
# sequence is 1,2..96,1,2..96, result will be continuos sinus function 
# with range between 0 and 1 inclusively, next column is almost same, but 
# input is transformed into cosinus, the other two columns is also same, 
# but sequence represents order of the day of the week
rf.prepareFn <- function(preparedData) {

  daysPerWeek <- 7
  measurementsPerDay <- preparedData$measurementsPerDay
  
  # Create training data frame with named columns
  trainingDF <- cbind(value=c(preparedData$trainingData$value),
                      day_sin=c(rf.setSinForDay(preparedData$trainingData$timestamp, measurementsPerDay)),
                      day_cos=c(rf.setCosForDay(preparedData$trainingData$timestamp, measurementsPerDay)),
                      week_sin=c(rf.setSinForWeek(preparedData$trainingData$timestamp, 7)),
                      week_cos=c(rf.setCosForWeek(preparedData$trainingData$timestamp, 7)))
  
  # Create testing data frame with same format as training data frame with empty values
  testingDF <- cbind(value=c(NA),
                     day_sin=c(rf.setSinForDay(preparedData$testingData$timestamp, measurementsPerDay)),
                     day_cos=c(rf.setCosForDay(preparedData$testingData$timestamp, measurementsPerDay)),
                     week_sin=c(rf.setSinForWeek(preparedData$testingData$timestamp, 7)),
                     week_cos=c(rf.setCosForWeek(preparedData$testingData$timestamp, 7)))
  
  return(list(trainingDataFrame = trainingDF, testingDataFrame = testingDF))
}
