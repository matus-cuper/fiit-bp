#!/usr/bin/env Rscript
# CSV transformation

args <- commandArgs(TRUE)

if (length(args)!=2) {
  stop("Invalid number of parameters", call.=FALSE)
}

# read data from csv
fileContent <- read.csv(file = args[1], sep = ",", dec = ".", header = TRUE)

# set date to usable normal format
fileContent$DATUM <- as.Date(fileContent$DATUM, format = "%d/%m/%Y")

# set time to float hours
fileContent$CAS <- (fileContent$CAS - fileContent$CAS[1])/ 60 

# set hours to normal time format 
fileContent$TIME <- paste(floor(fileContent$CAS), ":", fileContent$CAS %% 1 * 60, ":00", sep = "")

# create timestamp from DATUM and TIME
fileContent$timtestamp <- strptime(paste(fileContent$DATUM, fileContent$TIME), "%Y-%m-%d %H : %M :%S")

# remove fields
fileContent$value <- fileContent$Suma_odbery
fileContent$DATUM <- NULL
fileContent$CAS <- NULL
fileContent$Suma_odbery <- NULL
fileContent$TIME <- NULL

write.csv(file = args[2], fileContent, row.names = FALSE)