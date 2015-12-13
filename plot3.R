# Author: Andre Morales
# File: plot3.R
# Purpose:  1. Creates a Data Directory if it does not exist
#           2. Downloads zip file from course website to the Data Directory
#               (Individual household electric power consumption Data Set)
#               which is data from the UC Irvine Machine Learning Repository
#           3. Prints date data downloaded
#           4. Unzips the file
#           5. Reads the Data into R
#           6. Cleans the Data (Date and Time)
#           7. Subset the Data to specified dates
#           7. Plots the Data
#           8. Saves Plot to plot2.png
#
# Websites visited to get this working:
#           ?plot
#           ?legend

if(!file.exists("data")){
    dir.create("data")
}
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
destFile <- "./data/power.zip"
download.file(fileURL, destFile)
dateDownloaded <- date()
cat("Date Data Downloaded: ", dateDownloaded)

unzippedFileName <- tempfile()
powerData = data.frame()

if(file.exists(destFile)){
    unzippedFile <- unzip(destFile, list = TRUE) # Get the files
    unzippedFileName <- unzippedFile$Name # Get the file Name
    unzip(destFile, exdir = "./data") # Extract the file to the ./data directory
    
    # Read in the Data
    # Determined separator from opening file manually, na value was listed in instructions
    powerData <- read.table(paste0("./data/", unzippedFileName), header = TRUE, sep = ";", na.strings = "?")

    
}else{
    print("Cannot find downloaded zip file")
}

# Clean the data converting the dates and times (Date format is in instructions #1)
powerData$Date <- as.Date (powerData$Date, '%d/%m/%Y' )
powerData$datetime <- strptime(paste(powerData$Date, powerData$Time), format = '%Y-%m-%d %H:%M:%S')

# Subset to the dates specified in instructions dates 2007-02-01 and 2007-02-02
powerData <- subset(powerData, Date == '2007-02-01' | Date == '2007-02-02')

# Plot the data
png('plot3.png', width=480, height=480, units = "px", pointsize = 12, bg = "transparent")
#pdf("plot1.pdf", width = 7, height = 7)
#png('plot1.png', width=480, height=480)
plot(powerData$datetime, powerData$Sub_metering_1, type = "l", xlab = "",
    ylab = "Energy sub metering")
lines(powerData$datetime, powerData$Sub_metering_2, type = "l", xlab = "",
    col="red")
lines(powerData$datetime, powerData$Sub_metering_3, type = "l", xlab = "",
      col="blue")

#Create the legend
legend("topright", lty = c(1,1,1), col = c("black", "blue", "red"), legend = 
           c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"))
dev.off() #close the device
writeLines("\nDone")