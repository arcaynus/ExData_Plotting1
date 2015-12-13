# Author: Andre Morales
# File: plot1.R
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
#           8. Saves Plot to plot1.png
#
# Websites visited to get this working:
#           https://stat.ethz.ch/R-manual/R-devel/library/utils/html/unzip.html
#           http://www.r-bloggers.com/extracting-datasets-from-excel-files-in-a-zipped-folder/
#           http://www.inside-r.org/r-doc/base/strftime
#           https://www.stat.auckland.ac.nz/~paul/Talks/gridSVG/slide4.html
#           http://stackoverflow.com/questions/17476769/how-do-i-save-plot-images-in-r

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
png('plot1.png', width=480, height=480, units = "px", pointsize = 12, bg = "transparent")
#pdf("plot1.pdf", width = 7, height = 7)
#png('plot1.png', width=480, height=480)
hist(powerData$Global_active_power, xlab = "Global Active Power (kilowatts)", 
     main = "Global Active Power", col = "red")
dev.off() #close the device
writeLines("\nDone")