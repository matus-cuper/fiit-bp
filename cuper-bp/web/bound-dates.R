## utility function to read labels for UI

dates.read <- function(dataRaw, choice) {
  dates <- unique(as.Date(dataRaw$timestamp))
  
  if (choice == 1) {
    return(min(dates))
  }
  else if (choice == 2) {
    return(max(dates) - 1)
  }
  else if (choice == 3) {
    return(max(dates))
  }
  else if (choice == 4) {
    return(max(dates))
  }
}