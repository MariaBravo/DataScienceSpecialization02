Exploratory analysis of the effects for major weather events in the United States across the period 1996-2011
===================================================================================================
 

## Synopsis  
This report aims to present the analysis of the NOAA Storm Database and offer answers to the questions proposed in the assignment instructions. After a preliminary analysis of the data structure and NCDC documentation, we established a valid time period for the weather events and limited the fields to be used. Other additional tasks related to cleaning data were performed, but our focus in this work has been the exploration and analysis of the provided dataset.
We have found that extreme hot temperatures and tornados lead the negative effect on human lifes and economic damage; the period 2005-2006 presents the largest figures for economic damage while California seems to be the most affected region. We are including **three Figures** and one Table to support our analysis.


## Data Processing
The dataset analysed in this report was obtained from the link made available at the instructions provided for this assignment.According to the National Climatic Data Center (NCDC), this dataset records 48 event types from 1996 to present; before that period a reduced number of events has been incorporated.  The assignment instructions stablished that the events in the database start in the year 1950 and end in November 2011. Given those constraints, this report analyses the data corresponding to the 1996-2011 period.


### Downloading and reading the NCDC file
We first download the raw file and read the data including the header.


```r
library(data.table)
library(ggplot2)
library(xtable)

# The palette
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", 
    "#D55E00", "#CC79A7", "gold", "green3")
# To use for fills
v <- scale_fill_manual(values = cbPalette)
# To use for line and point colors
v <- scale_colour_manual(values = cbPalette)

setInternet2(TRUE)
f <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2", 
    f)
datZero <- data.table(read.csv(bzfile(f)))
```


In order to process only the 1996-2011 period, we filter the data produced in other years. 


```r
# cutting years until 1996 and comments, adding formatted date
dat1 <- datZero[year(strptime(datZero[["BGN_DATE"]], "%m/%d/%Y %H:%M:%S")) >= 
    1996]
```


The number of fields ignored by our analysis increases the size of the dataset to be manipulated; with the purpose of work with a smaller data object,we are using only the columns with values significative to our analysis.


```r
dat1 <- dat1[, c("BGN_DATE", "STATE", "EVTYPE", "FATALITIES", "INJURIES", "PROPDMG", 
    "PROPDMGEXP", "CROPDMG", "CROPDMGEXP"), with = FALSE]
```

The number of records with zero value for all the analysis-significative columns is very important.


```r
nrow(dat1[FATALITIES == 0 & INJURIES == 0 & PROPDMG == 0 & CROPDMG == 0])
```

```
## [1] 452212
```


Therefore, we cut off the rows without values different from zero.

```r
dat1 <- dat1[FATALITIES > 0 | INJURIES > 0 | PROPDMG > 0 | CROPDMG > 0, ]
```


Finally, a valid Datetime-formatted column is incorporated in order to facilitate further manipulation of data.

```r
dat1 <- dat1[, `:=`(bgn_date2, as.Date(strptime(dat1$BGN_DATE, "%m/%d/%Y %H:%M:%S")))]
dat1 <- dat1[, `:=`(bgn_year, year(bgn_date2))]
```




### Obtaining totals
According to the NCDC, the column PROPDMGEXP is related to the value of PROPDMG and it stores alphabetical characters used to represent magnitude ("K" for thousands, "M" for millions, and "B" for billions). We use this characteristic in order to obtain a homogeneous representation for the value of damage to properties.


```r
dat1 <- dat1[, `:=`(propdmg0, 0)]
dat1 <- dat1[, `:=`(propdmgK, 0)]
dat1 <- dat1[, `:=`(propdmgM, 0)]
dat1 <- dat1[, `:=`(propdmgB, 0)]

dat1 <- dat1[as.character(dat1$PROPDMGEXP) == "0" & "PROPDMG" > 0, `:=`(propdmg0, 
    PROPDMG * 1)]
dat1 <- dat1[as.character(dat1$PROPDMGEXP) == "K" & "PROPDMG" > 0, `:=`(propdmgK, 
    PROPDMG * 1000)]
dat1 <- dat1[as.character(dat1$PROPDMGEXP) == "M" & "PROPDMG" > 0, `:=`(propdmgM, 
    PROPDMG * 1e+06)]
dat1 <- dat1[as.character(dat1$PROPDMGEXP) == "B" & "PROPDMG" > 0, `:=`(propdmgB, 
    PROPDMG * 1e+09)]

dat1 <- dat1[is.na(dat1$propdmg0), `:=`(propdmg0, 0)]
dat1 <- dat1[is.na(dat1$propdmgK), `:=`(propdmgK, 0)]
dat1 <- dat1[is.na(dat1$propdmgM), `:=`(propdmgM, 0)]
dat1 <- dat1[is.na(dat1$propdmgB), `:=`(propdmgB, 0)]
```


A similar criteria is applied to the value of damage to crops.


```r
dat1 <- dat1[, `:=`(cropdmg0, 0)]
dat1 <- dat1[, `:=`(cropdmgK, 0)]
dat1 <- dat1[, `:=`(cropdmgM, 0)]
dat1 <- dat1[, `:=`(cropdmgB, 0)]

dat1 <- dat1[as.character(dat1$CROPDMGEXP) == "0" & "CROPDMG" > 0, `:=`(cropdmg0, 
    CROPDMG * 1)]
dat1 <- dat1[as.character(dat1$CROPDMGEXP) == "K" & "CROPDMG" > 0, `:=`(cropdmgK, 
    CROPDMG * 1000)]
dat1 <- dat1[as.character(dat1$CROPDMGEXP) == "M" & "CROPDMG" > 0, `:=`(cropdmgM, 
    CROPDMG * 1e+06)]
dat1 <- dat1[as.character(dat1$CROPDMGEXP) == "B" & "CROPDMG" > 0, `:=`(cropdmgB, 
    CROPDMG * 1e+09)]

dat1 <- dat1[is.na(dat1$cropdmg0), `:=`(cropdmg0, 0)]
dat1 <- dat1[is.na(dat1$cropdmgK), `:=`(cropdmgK, 0)]
dat1 <- dat1[is.na(dat1$cropdmgM), `:=`(cropdmgM, 0)]
dat1 <- dat1[is.na(dat1$cropdmgB), `:=`(cropdmgB, 0)]
```



## Results
### The total effect of Weather events in the U.S.
In order to establish the importance of these events in terms of economic losses and human lifes, 
we have totalized by event both the economic damage and fatalities occurred. To avoid big-numbers display issues, we are converting those totals to million-dollars units. Finally, we obtain a unique representation for each event.


```r
datTotEvent <- dat1[order(EVTYPE, bgn_year)]
datTotEvent <- datTotEvent[, by = "EVTYPE", `:=`(totFATALITIES = sum(FATALITIES), 
    totINJURIES = sum(INJURIES), totPROPDMG = sum(propdmg0/1e+06) + sum(propdmgK/1e+06) + 
        sum(propdmgM/1e+06) + sum(propdmgB/1e+06), totCROPDMG = sum(cropdmg0/1e+06) + 
        sum(cropdmgK/1e+06) + sum(cropdmgM/1e+06) + sum(cropdmgB/1e+06))]
datTotEvent <- unique(datTotEvent, by = "EVTYPE")
```


### Answering Question 1: Across the United States, which types of events (as indicated in the EVTYPE variable) are most harmful with respect to population health?
As the question requests for information about damage inflicted to population health, we are using the number of fatalities caused by a event to find the most harmful meteorological phenomenon.

```r
datQ1 <- datTotEvent[order(totFATALITIES, totINJURIES, decreasing = TRUE)]
datQ1 <- datQ1[totFATALITIES > 0, ]
datQ1 <- datQ1[order(totFATALITIES, decreasing = TRUE)]

levelsQ1 <- datQ1[, c("EVTYPE", "totFATALITIES"), with = FALSE]
levelsQ1 <- levelsQ1[order(totFATALITIES, decreasing = TRUE)]
levelsQ1 <- levelsQ1[["EVTYPE"]]

datQ1 <- transform(datQ1, EVTYPE = factor(EVTYPE, levels = levelsQ1))
datQ1 <- head(datQ1, 10)

## Question 1

qplot(x = EVTYPE, y = totFATALITIES, data = datQ1, fill = EVTYPE, geom = "bar", 
    stat = "identity", xlab = "Type of Event", ylab = "Number of Fatalities") + 
    labs(title = "Figure 1: Fatalities caused by severe weather") + theme(axis.text.x = element_text(angle = 90, 
    hjust = 1, vjust = 0), legend.position = "none") + scale_fill_manual(values = cbPalette)
```

![plot of chunk chunkQ1](figure/chunkQ1.png) 


According to our results, Excessive Heat events have caused the largest number of fatalities in United States.

### Answering Question 2: Across the United States, which types of events have the greatest economic consequences?
The answer to this question relates to property and crop damage; therefore we are aggregating these values into a total for economic losses. After that, we order the data by the economic totals and obtain the 10 most significant events in terms of damage to properties and crops.

```r
datQ2 <- datTotEvent[, `:=`(totECONDMG, totPROPDMG + totCROPDMG)]
datQ2 <- datTotEvent[totECONDMG > 0, ]
datQ2 <- datTotEvent[order(totECONDMG, decreasing = TRUE)]

levelsQ2 <- datQ2[, c("EVTYPE", "totECONDMG"), with = FALSE]
levelsQ2 <- levelsQ2[order(totECONDMG, decreasing = TRUE)]
levelsQ2 <- levelsQ2[["EVTYPE"]]

datQ2 <- transform(datQ2, EVTYPE = factor(EVTYPE, levels = levelsQ2))

datQ2 <- datQ2[, list(EVTYPE, totFATALITIES, totINJURIES, totPROPDMG, totCROPDMG, 
    totECONDMG)]
setnames(datQ2, c("Event", "Fatalities", "Injuries", "PropertyDamage", "CropsDamage", 
    "EconomicDamage"))
datQ2 <- head(datQ2, 10)

## Question 2

options(scipen = 999)

qplot(x = Event, y = EconomicDamage, data = datQ2, fill = Event, geom = "bar", 
    stat = "identity", xlab = "Type of Event", ylab = "Million Dollars") + labs(title = "Figure 2: Economic damage occassioned by weather events") + 
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0), legend.position = "none") + 
    scale_fill_manual(values = cbPalette)
```

![plot of chunk chunkQ2](figure/chunkQ2.png) 


According to our results, the economic damage inflicted by Flood events is the most significant in United States.



### Additional analysis

#### Along the period
We have accumulated the weather events' effects by year in order to obtain a view of the damage pattern through the time.
It is notorious the increase in economic damage at the period 2005-2006.

```r

datTotTime <- dat1[order(bgn_year)]
datTotTime <- datTotTime[, by = "bgn_year", `:=`(totFATALITIES = sum(FATALITIES), 
    totINJURIES = sum(INJURIES), totPROPDMG = sum(propdmg0/1000000) + sum(propdmgK/1000000) + 
        sum(propdmgM/1000000) + sum(propdmgB/1000000), totCROPDMG = sum(cropdmg0/1000000) + 
        sum(cropdmgK/1000000) + sum(cropdmgM/1000000) + sum(cropdmgB/1000000))]

datTotTime <- datTotTime[, `:=`(totECONDMG, totPROPDMG + totCROPDMG)]
datTotTime <- unique(datTotTime, by = "bgn_year")
datTotTime <- datTotTime[, list(bgn_year, totFATALITIES, totINJURIES, totECONDMG)]
setnames(datTotTime, c("Year", "Fatalities", "Injuries", "TotalEconomicDamage"))


with(datTotTime, plot(Year, TotalEconomicDamage, pch = NA, type = "l", ylab = "Million dollars", 
    main = "Figure 3: Economic Damage by Weather events in U.S.A.(1996-2011)", 
    xlab = "Year"))
lines(datTotTime$Year, datTotTime$TotalEconomicDamage, col = "blue", lwd = 2)
```

![plot of chunk chunkA1](figure/chunkA1.png) 


#### Across the U.S.A.
The geographic distribution of the weather events has been obtained by state.

```r
datTotGeo <- dat1[order(STATE, EVTYPE)]
datTotGeo <- datTotGeo[, by = STATE, `:=`(totFATALITIES = sum(FATALITIES), totINJURIES = sum(INJURIES), 
    totPROPDMG = sum(propdmg0/1000000) + sum(propdmgK/1000000) + sum(propdmgM/1000000) + 
        sum(propdmgB/1000000), totCROPDMG = sum(cropdmg0/1000000) + sum(cropdmgK/1000000) + 
        sum(cropdmgM/1000000) + sum(cropdmgB/1000000))]

datTotGeo <- datTotGeo[, `:=`(totECONDMG, totPROPDMG + totCROPDMG)]
datTotGeo <- unique(datTotGeo, by = "STATE")
datTotGeo <- datTotGeo[, list(STATE, totFATALITIES, totINJURIES, totECONDMG)]
datTotGeo <- datTotGeo[order(totECONDMG, decreasing = TRUE)]
datTotGeo <- head(datTotGeo, 10)

setnames(datTotGeo, c("Year", "Fatalities", "Injuries", "EconomicDamage_Million$"))
print(datTotGeo)
```

```
##     Year Fatalities Injuries EconomicDamage_Million$
##  1:   CA        498     2769                  125064
##  2:   LA        144      812                   57600
##  3:   FL        544     2884                   39040
##  4:   MS        160     1217                   30299
##  5:   TX        756     9222                   28108
##  6:   AL        449     3707                   10720
##  7:   NC        263     1378                    9134
##  8:   IA         61      984                    6850
##  9:   MO        533     5960                    6424
## 10:   TN        327     2385                    6046
```


