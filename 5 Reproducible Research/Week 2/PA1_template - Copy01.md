Assignment 1
============

This is an R Markdown document produced to answer the questions formulated by the **Peer Assesment 1**. 


## This is a secondary heading

*This text will appear italicized!*
**This text will appear bold!**
### This is a tertiary heading

- first item in list
- second item in list
- third item in list

1. first item in list
2. second item in list
3. third item in list

### Loading and preprocessing the data

```r
library(data.table)
library(lubridate)
dat1 <- data.table(read.table("activity.csv", skip = 1, quote = "\"", col.names = c("steps", 
    "date", "interval"), sep = ",", stringsAsFactors = FALSE, colClasses = c("integer", 
    "character", "integer")))
dat1$NewDate <- ymd(dat1$date)
dat2 <- dat1[!is.na(steps)]
dat2 <- dat2[, `:=`(TotalSteps, sum(steps)), by = NewDate]
```



### Question 1: What is mean total number of steps taken per day?

```r

dat3 <- dat2[, c("NewDate", "TotalSteps"), with = F]
setkey(dat3, "NewDate")
dat4 <- unique(dat3, by = "NewDate")

hist(dat4$TotalSteps, main = "Total steps by day", col = "red", xlab = "Total steps by day", 
    breaks = 30)
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2.png) 

```r

meanNotNA <- mean(dat4$TotalSteps)
medianNotNA <- median(dat4$TotalSteps)
```

#### The mean of the total number of steps taken by day is 10766 and the median is 10765.


### Question 2: What is the average daily activity pattern?

```r
dat2b <- dat2[, `:=`(AvgSteps, mean(steps)), by = interval]
dat2b <- dat2b[order(interval)]

with(dat2b, plot(AvgSteps, interval, pch = NA, ylab = "Average", xlab = "Interval"))

lines(dat2b$AvgSteps, dat2b$interval, type = "S")
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 

```r

maxNumSteps <- max(dat2b$AvgSteps)
rowMaxNumSteps <- which.max(dat2b$AvgSteps)
intervalMaxNumSteps <- dat2b[rowMaxNumSteps][[3]]
```


#### The average daily activate pattern.....
#### The maximum number of steps is 206.1698 and it belongs to interval 835.


### Question 3: Imputing missing values

1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)

2. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.

3. Create a new dataset that is equal to the original dataset but with the missing data filled in.

4. Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?



```r
NArows <- sum(dat1[, is.na(steps) | is.na(date) | is.na(interval)])

dat1 <- dat1[, `:=`(z, mean(steps, na.rm = TRUE)), by = interval]
dat1 <- dat1[is.na(steps), `:=`(steps2, z)]
dat1 <- dat1[!is.na(steps), `:=`(steps2, steps)]

dat <- dat1[, c("steps2", "NewDate", "interval"), with = FALSE]
setnames(dat, c("steps", "date", "interval"))
dat <- dat[, `:=`(TotalSteps, sum(steps)), by = date]

hist(dat$TotalSteps, main = "Total steps by day", col = "red", xlab = "Total steps by day", 
    breaks = 30)
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4.png) 

```r
meanNA <- mean(dat$TotalSteps)
medianNA <- median(dat$TotalSteps)
```


#### The mean of the total number of steps taken by day is 10766.
#### The median of the total number of steps taken by day is 10766.
#### The impact of imputing missing data on the estimates of the total daily number of steps....


### Question 4: Are there differences in activity patterns between weekdays and weekends?



```r
WeekDay <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")
WeekEndDay <- c("Saturday", "Sunday")

datA <- dat[weekdays(dat$date) %in% WeekDay]
datB <- dat[weekdays(dat$date) %in% WeekEndDay]

datA <- datA[, `:=`(z, mean(steps)), by = interval]
datB <- datB[, `:=`(z, mean(steps)), by = interval]

datA <- datA[, `:=`(DayType, "weekday")]
datB <- datB[, `:=`(DayType, "weekend")]

library(lattice)
datC <- merge(datA, datB, by = names(datA), all = TRUE)
datC <- datC[order(interval, DayType)]
with(datC, xyplot(z ~ interval | DayType, layout = c(1, 2), type = "l"))
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5.png) 


#### Differences ....
