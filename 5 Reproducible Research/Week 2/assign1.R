

## Loading and preprocessing the data
library(data.table)
library(lubridate)
dat1 <- data.table(read.table("activity.csv", skip=1, quote="\"",
                   col.names = c("steps", "date", "interval"),
                   sep=",", stringsAsFactors = FALSE,
                   colClasses=c("integer", "character", "integer")))
dat1$NewDate <- ymd(dat1$date)
dat2 <- dat1[!is.na(steps)]

dat2[, TotalSteps:= sum(steps), by=NewDate]

dat2[, AvgSteps:= mean(steps), by=NewDate]

dat3 <- dat2[, c("NewDate", "TotalSteps"), with = F]
setkey(dat3, "NewDate")
dat4 <- unique(dat3, by="NewDate")


## What is mean total number of steps taken per day?
hist(dat4$TotalSteps, main="Total steps by day", col = "red", xlab="Total steps by day", breaks=30)

mean(dat4$TotalSteps)
median(dat4$TotalSteps)



## What is the average daily activity pattern?

with(dat2, plot(NewDate,AvgSteps, pch=NA, 
                ylab="",
                xlab = ""))

lines(dat2$NewDate, dat2$AvgSteps, type="S")

max(dat2$AvgSteps)
which.max(dat2$AvgSteps)
min(dat2$AvgSteps)
which.min(dat2$AvgSteps)


## Imputing missing values
sum(dat1[, is.na(steps) | is.na(date) | is.na(interval)])

dat1[, z:= mean(steps, na.rm=TRUE), by=interval]
dat1[is.na(steps), steps2:= z]
dat1[!is.na(steps), steps2:= steps]

dat <- dat1[, c("steps2", "NewDate", "interval" ), with = FALSE]
setnames(dat, c("steps", "date", "interval"))
dat[, TotalSteps:= sum(steps), by=date]

hist(dat$TotalSteps, main="Total steps by day", col = "red", xlab="Total steps by day", breaks=30)
mean(dat$TotalSteps)
median(dat$TotalSteps)


WeekDay <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")
WeekEndDay <- c("Saturday", "Sunday")

datA <- dat[weekdays(dat$date) %in% WeekDay]
datB <- dat[weekdays(dat$date) %in% WeekEndDay]

datA[, z:= mean(steps), by=interval]
datB[, z:= mean(steps), by=interval]

datA[, DayType:="weekday"]
datB[, DayType:="weekend"]
print("aaaaaa")
library(lattice)
datC <- merge(datA, datB, by=names(datA), all=TRUE)
datC <- datC[order(interval,DayType)]
with(datC, xyplot(z ~ interval | DayType, layout=c(1,2), type="l"))


print("bbbbbbbbbbbbbb")


##with(dat[DayType=="weekend"], plot(interval, z, 
##     xlab="Interval", type = "l", main ="weekend",
##     ylab="Number of steps") )
##lines(dat$interval, dat$z, type="S")

##with(dat[DayType=="weekday"], plot(interval, z ) )
##lines(dat$interval, dat$z, type="S")


##xyplot(z ~ interval | DayType, layout=c(1,2), type="l")


