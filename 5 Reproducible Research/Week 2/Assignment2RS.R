

library(data.table)

datZero <- data.table(read.table("repdata_data_StormData.csv", header=TRUE, sep=","))

datTot <- datZero[, by="EVTYPE", 
            `:=` (totFATALITIES=sum(FATALITIES), totINJURIES=sum(INJURIES), 
            totPROPDMG=sum(PROPDMG), totCROPDMG=sum(CROPDMG))]
datTot <- datTot[,list(EVTYPE, totFATALITIES, totINJURIES, totPROPDMG, totCROPDMG)]
setkey(datTot, EVTYPE)
datTot <- unique(datTot, by = "EVTYPE")

datQ1 <- datTot[order(totFATALITIES, totINJURIES, decreasing = TRUE)]

datQ2 <- datTot[order(totPROPDMG, totCROPDMG, decreasing = TRUE)]


## The events in the database start in the year 1950 and end in November 2011. 
## 1.   The basic goal of this assignment is to explore the NOAA Storm Database and answer 
##      some basic questions about severe weather events. 
## 2.   You must use the database to answer the questions below and show the code for your entire analysis. 
## 3.   Your analysis can consist of tables, figures, or other summaries. 
## 4.   You may use any R package you want to support your analysis.




## Question 1
## Across the United States, which types of events (as indicated in the EVTYPE variable) 
## are most harmful with respect to population health?




## Question 2
## Across the United States, which types of events have the greatest economic consequences?



dat1 <- data.table(read.table("activity.csv", skip=1, quote="\"",
                              col.names = c("steps", "date", "interval"),
                              sep=",", stringsAsFactors = FALSE,
                              colClasses=c("integer", "character", "integer")))
