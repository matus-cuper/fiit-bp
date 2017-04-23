## prepare dataframes for random forest

# Example call

# Convert given time into nth measurement in day
rf.nthInDay <- function(date, frequency) {
  measurementsPerHour <- frequency / 24
  minutesPerHour <- 60
  
  return((as.numeric(format(as.POSIXct(date), "%H")) * measurementsPerHour) + 
           round(as.numeric(format(as.POSIXct(date), "%M")) / minutesPerHour * measurementsPerHour) + 1)
}

# Convert given date into nth day in week
rf.nthInWeek <- function(date, frequency = 7) {
  return((as.numeric(as.POSIXlt(date)$wday) + frequency - 1) %% frequency + 1)
}

# Represent measurements per day as sinus function
rf.setSinForDay <- function(dates, frequency) {
  return((sin(2 * pi * rf.nthInDay(dates, frequency) / frequency) + 1) / 2)
}

# Represent measurements per day as cosinus function
rf.setCosForDay <- function(dates, frequency) {
  return((cos(2 * pi * rf.nthInDay(dates, frequency) / frequency) + 1) / 2)
}

# Represent day per week as sinus function
rf.setSinForWeek <- function(dates, frequency) {
  return((sin(2 * pi * rf.nthInWeek(dates, frequency) / frequency) + 1) / 2)
}

# Represent day per week as cosinus function
rf.setCosForWeek <- function(dates, frequency) {
  return((cos(2 * pi * rf.nthInWeek(dates, frequency) / frequency) + 1) / 2)
}

# Function will create training and testing data frames with 6 columns,
# each data frame is filled by data from different ranges selected by user,
# the first column represents value of measurement, in testing data frame
# is not present, random forest has to computes it, the second column is 
# transformation of sequence of measurements into sinus function, if the
# sequence is 1,2..96,1,2..96, result will be continuos sinus function 
# with range between 0 and 1 inclusively, next column is almost same, but 
# input is transformed into cosinus, the other two columns is also same, 
# but sequence represents order of the day of the week, last column is 
# seasonal component of given time series object
rf.prepareFn <- function(preparedData) {
  # Compute matrices sizes
  daysPerWeek <- 7
  measurementsPerDay <- preparedData$measurementsPerDay
  trainingSetSize <- nrow(preparedData$trainingData)
  testingSetSize <- nrow(preparedData$testingData)
  trainingSetRecords <- preparedData$trainingData
  testingSetRecords <- preparedData$testingData
  
  # Compute seasonal component for given data
  trainingSeasonalComponent <- as.data.frame(stl(ts(trainingSetRecords$value, frequency = measurementsPerDay), s.window = 7, robust = TRUE)$time.series)$seasonal
  testingSeasonalComponent <- as.data.frame(stl(ts(testingSetRecords$value, frequency = measurementsPerDay), s.window = 1, robust = TRUE)$time.series)$seasonal
  
  # Create training data frame with named columns
  trainingDF <- cbind(value=c(trainingSetRecords$value),
                      day_sin=c(rf.setSinForDay(trainingSetRecords$timestamp, measurementsPerDay)),
                      day_cos=c(rf.setCosForDay(trainingSetRecords$timestamp, measurementsPerDay)),
                      week_sin=c(rf.setSinForWeek(trainingSetRecords$timestamp, measurementsPerDay)),
                      week_cos=c(rf.setCosForWeek(trainingSetRecords$timestamp, measurementsPerDay)),
                      week_seas=c(trainingSeasonalComponent))
  
  # Create testing data frame with same format as training data frame with empty values
  testingDF <- cbind(value=c(NA),
                     day_sin=c(rf.setSinForDay(testingSetRecords$timestamp, measurementsPerDay)),
                     day_cos=c(rf.setCosForDay(testingSetRecords$timestamp, measurementsPerDay)),
                     week_sin=c(rf.setSinForWeek(testingSetRecords$timestamp, measurementsPerDay)),
                     week_cos=c(rf.setCosForWeek(testingSetRecords$timestamp, measurementsPerDay)),
                     week_seas=c(testingSeasonalComponent))
  
  return(list(trainingDataFrame = trainingDF, testingDataFrame = testingDF))
}
