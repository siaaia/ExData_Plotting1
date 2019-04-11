require(data.table)

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

# Reset graphical parameters to defaults
if(dev.cur() > 1) dev.off()

# Create the plot
hist(data$Global_active_power, col="red",
     xlab="Global Active Power (kilowatts)",
     main="Global Active Power")

# Copy the plot to a PNG
dev.copy(png, file="plot1.png")
dev.off()
