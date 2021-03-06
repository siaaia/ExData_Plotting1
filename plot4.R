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

# Set the graphical parameters
par(mfrow=c(2,2), mar=c(4,4,2,2))

with(data, {
  
  # Create top right plot
  plot(datetime, Global_active_power, type="l",
       xlab="", ylab="Global Active Power")
  
  # Create top left plot
  plot(datetime, Voltage, type="l")
  
  # Create bottom right plot
  plot(datetime, Sub_metering_1, type="l",
       xlab="", ylab="Energy sub metering")
  points(datetime, Sub_metering_2, type="l", col="red")
  points(datetime, Sub_metering_3, type="l", col="blue")
  legend("topright", pch="_", y.intersp=0.5, bty="n", col=c("black", "red", "blue"),
         legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  
  # Create bottom left plot
  plot(datetime, Global_reactive_power, type="l")
  
})

# Copy the plot to a PNG
dev.copy(png, file="plot4.png")
dev.off()
