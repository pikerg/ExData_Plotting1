################################################################################################
## Loading the data set
##  *The dataset has 2,075,259 rows and 9 columns. First calculate a rough estimate of how much
##    memory the dataset will require in memory before reading into R. Make sure your computer
##    has enough memory (most modern computers should be fine).
##  *We will only be using data from the dates 2007-02-01 and 2007-02-02. One alternative is to
##    read the data from just those dates rather than reading in the entire dataset and
##    subsetting to those dates.
##  *You may find it useful to convert the Date and Time variables to Date/Time classes in R
##    using the strptime() and as.Date() functions.
##  *Note that in this dataset missing values are coded as ?.
################################################################################################
##
## install required pakage - install.packages('sqldf')
## Load required package - library('sqldf')
##
################################################################################################

## Set file path
file <- "./household_power_consumption.txt"

## SQL statement for filtering on date. 
mySql <- "select * from file where Date in ('1/2/2007', '2/2/2007')"

## Read data set into environment. Filter using SQL statement setting the delimeter as ";"
##  and setting missing values to "na"
dt <- read.csv2.sql(file, mySql, header=T, sep=';',na.strings='?', dec='.', stringsAsFactors=F, quote='\"')

## Add datetime column to data for ISO standard dates and tiimes formating
dt$datetime <- strptime(paste(dt$Date, dt$Time, sep=" "), "%d/%m/%Y %T")

## Format strings to numbers columns for plotting
dt$globalActivePower <- as.numeric(dt$Global_active_power)
dt$globalReactivePower <- as.numeric(dt$Global_reactive_power)
dt$subMetering1 <- as.numeric(dt$Sub_metering_1)
dt$subMetering2 <- as.numeric(dt$Sub_metering_2)
dt$subMetering3 <- as.numeric(dt$Sub_metering_3)
dt$voltage <- as.numeric(dt$Voltage)

## Create vectors for legend groups and colors
legGroup <- c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3')
legColor <- c('black', 'red', 'blue')

## Save the file
png(filename="plot4.png", width=480, height=480)

## Set Graphical Layout Parameters
par(mfrow=c(2, 2))

## Plot "Global Active Power" graph for the upper-left position
plot(dt$datetime, dt$globalActivePower, type='l', xlab='', ylab='Global Active Power')

## Plot "Voltage" for the upper-right position
plot(dt$datetime, dt$voltage, type='l', xlab='datetime', ylab='Voltage')

## Plot "Energy sub metering" for the lower-left position
plot(dt$datetime, dt$subMetering1, type='l', xlab='', ylab='Energy sub metering')
lines(dt$datetime, dt$subMetering2, type='l', col='red')
lines(dt$datetime, dt$subMetering3, type='l', col='blue')
legend('topright', legend=legGroup, lty=1, lwd=2, bty='n', col=legColor)

## Plot "Global_reactive_power" for the lower-right position
plot(dt$datetime, dt$globalReactivePower, type='l', xlab='datetime', ylab='Global_reactive_power')

## required to close connection
dev.off()