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

## convert globalActivePower to numbers
dt$globalActivePower <- as.numeric(dt$Global_active_power)

## Save the file
png(filename="plot2.png", width=480, height=480)

## Plot 2 day line graph
plot(dt$datetime, dt$globalActivePower, type='l', xlab='', ylab='Global Active Power (likowatts)')

## required to close connection
dev.off()