require(data.table)
require(lubridate)

# Download data if needed
if (!file.exists("./household_power_consumption.txt")) {
  download.file(
    paste0("https://d396qusza40orc.cloudfront.net/",
           "exdata%2Fdata%2Fhousehold_power_consumption.zip"),
    "data.zip")
  unzip("data.zip")
}

# Read only rows for dates 1/2/2007 - 2/2/2007
data <- fread("./household_power_consumption.txt",
              sep=";", skip=66637, nrows=(69517-66637))

# Assign names by reading one row from the top of the file
names(data) <- names(fread("./household_power_consumption.txt", 
                           sep=";", nrows=1))

# Derive POSIX times from the Date and Time columns
datetime <- dmy_hms(paste(data$Date, data$Time))

# Reset graphical parameters to defaults
if(dev.cur() > 1) dev.off()

# Create the plot
with(data, {
  plot(datetime, Sub_metering_1, type="l",
       xlab="", ylab="Energy sub metering")
  points(datetime, Sub_metering_2, type="l", col="red")
  points(datetime, Sub_metering_3, type="l", col="blue")
  legend("topright", pch="_", bty="n", col=c("black", "blue", "red"),
         legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
})

# Copy the plot to a PNG
dev.copy(png, file="plot3.png")
dev.off()
