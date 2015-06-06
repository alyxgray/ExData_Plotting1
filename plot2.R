if (!file.exists("data")){
  dir.create("data")    
}

if (!file.exists("data/subset.txt")){
  
  if (!file.exists("./data/household_power_consumption.zip")){
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl, destfile = "./data/household_power_consumption.zip", method="curl")
    dateDownloaded <- date()
  }
  
  if (file.exists("./data/household_power_consumption.zip"))
  {
    unzip ("./data/household_power_consumption.zip", exdir = "./data")
  }
  
  data <- read.table("./data//household_power_consumption.txt", header = TRUE, sep=";" , na.strings="?")
  
  data$DateTime <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S", tz="")
  
  dataSubset <- subset (data, DateTime >= as.POSIXct("2007-02-01 00:00:00") & DateTime < as.POSIXct("2007-02-03 00:00:00") )
  
  dataSubset["Time"] <- dataSubset["Date"] <- NULL
  
  write.table (dataSubset, file = "data/subset.txt", sep=";")
  
}

if (file.exists("data/subset.txt")){
  dataTidy <- read.table("./data/subset.txt", header = TRUE, sep=";" ,stringsAsFactors = FALSE)
  dataTidy$DateTime <- strptime(dataTidy$DateTime, "%Y-%m-%d %H:%M:%S")
}

png(filename = "plot2.png", width = 480, height=480, units="px")

x <- dataTidy$DateTime
y <- dataTidy$Global_active_power

plot(x,y, type="l", xlab="", ylab="Global Active Power (kilowatts)")

dev.off()
