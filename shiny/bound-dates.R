## utility function to read labels for UI

# return date to set for dateRangeInput components
dates.read <- function(dates, choice) {
  # minimum date for trainingSetRange and testingSetRange, first date in trainingSetRange
  if (choice == 1) {
    return(min(dates))
  }
  # second date in trainingSetRange
  else if (choice == 2) {
    return(max(dates) - 1)
  }
  # first date in testingSetRange
  else if (choice == 3) {
    return(max(dates))
  }
  # maximum date for trainingSetRange and testingSetRange, second date of testingSetRange
  else if (choice == 4) {
    return(max(dates))
  }
}