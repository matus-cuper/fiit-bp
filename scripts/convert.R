#!/usr/bin/env Rscript
# CSV transformation

args <- commandArgs(TRUE)

if (length(args)!=2) {
  args <- c("--help")
}

if("--help" %in% args) {
  cat("Usage: convert.R SOURCE DEST
 
      Arguments:
      SOURCE    - source file to convert
      DEST      - output file 
      --help    - print this text
 
      Example:
      Rscript --vanilla convert.R old.csv new.csv\n")
  
  q(save="no")
}

setRightHour <- function(x) {
  if (x < 0)
    return(x + 24)
  return(x)
}

# read data from csv
fileContent <- read.csv(file = args[1], sep = ",", dec = ".", header = TRUE)

# set date to usable normal format
fileContent$DATUM <- as.Date(fileContent$DATUM, format = "%d/%m/%Y")

# set time to float hours
fileContent$CAS <- fileContent$CAS / 60

# move to previous day if hours are negative
for (i in 1:nrow(fileContent)) {
  if (fileContent$CAS[i] < 0) {
    fileContent$DATUM[i] <- fileContent$DATUM[i] - 1
  }
}

# set hours like -1.0 to 23.0
fileContent$CAS <- lapply(fileContent$CAS, setRightHour)

# set hours to normal time format 
fileContent$TIME <- paste(floor(as.numeric(fileContent$CAS)), ":", as.numeric(fileContent$CAS) %% 1 * 60, ":00", sep = "")

# create timestamp from DATUM and TIME
fileContent$timtestamp <- strptime(paste(fileContent$DATUM, fileContent$TIME), "%Y-%m-%d %H : %M :%S")

# remove fields
fileContent$value <- fileContent$Suma_odbery
fileContent$DATUM <- NULL
fileContent$CAS <- NULL
fileContent$Suma_odbery <- NULL
fileContent$TIME <- NULL

write.csv(file = args[2], fileContent, row.names = FALSE)
