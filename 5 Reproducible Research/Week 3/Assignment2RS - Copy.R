

library(data.table)

f <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2", f)
datZero <- data.table(read.csv(bzfile(f)))

# cutting years until 1996 and comments, adding formatted date
dat1 <- datZero[year(strptime( datZero[["BGN_DATE"]] , "%m/%d/%Y %H:%M:%S")) >= 1996]


dat1 <- dat1[, c("STATE__", "BGN_DATE", "COUNTY", "COUNTYNAME", "STATE",
                 "EVTYPE", "END_DATE", "FATALITIES", "INJURIES", "PROPDMG", 
                 "PROPDMGEXP", "CROPDMG", "CROPDMGEXP") , with = FALSE]

dat1 <- dat1[, bgn_date2:= as.Date(strptime( dat1$BGN_DATE, "%m/%d/%Y %H:%M:%S")) ]

dat1 <- dat1[, bgn_year:= year(bgn_date2) ]



## obtaining valid PROPDMGEXP
zz <- dat1["PROPDMG" > 0, list(PROPDMGEXP) ]
aa <- zz[order(PROPDMGEXP)]
aa <- unique(aa)

## obtaining valid CROPDMGEXP
zz <- dat1["CROPDMG" > 0, list(CROPDMGEXP) ]
aa <- zz[order(CROPDMGEXP) ]
aa <- unique(aa)

dat1[as.character(dat1$PROPDMGEXP) == "0" & "PROPDMG" > 0, propdmg2 := PROPDMG*1]
dat1[as.character(dat1$PROPDMGEXP) == "K" & "PROPDMG" > 0, propdmg2 := PROPDMG*1000]
dat1[as.character(dat1$PROPDMGEXP) == "M" & "PROPDMG" > 0, propdmg2 := PROPDMG*1000000]
dat1[as.character(dat1$PROPDMGEXP) == "B" & "PROPDMG" > 0, propdmg2 := PROPDMG*1000000000]


dat1[as.character(dat1$CROPDMGEXP) == "0" & "CROPDMG" > 0, cropdmg2 := CROPDMG*1]
dat1[as.character(dat1$CROPDMGEXP) == "K" & "CROPDMG" > 0, cropdmg2 := CROPDMG*1000]
dat1[as.character(dat1$CROPDMGEXP) == "M" & "CROPDMG" > 0, cropdmg2 := CROPDMG*1000000]
dat1[as.character(dat1$CROPDMGEXP) == "B" & "CROPDMG" > 0, cropdmg2 := CROPDMG*1000000000]


datTotEvent <- dat1[order(EVTYPE, bgn_year)]
datTotEvent <- datTotEvent[, by="EVTYPE", 
                  `:=` (totFATALITIES=sum(FATALITIES), totINJURIES=sum(INJURIES), 
                        totPROPDMG=sum(propdmg2), totCROPDMG=sum(cropdmg2))]
datTotEvent <- unique(datTotEvent, by = "EVTYPE")



datTotYear <- dat1[order(bgn_year, EVTYPE)]
datTotYear <- datTotYear[, by=year(dat1$bgn_date2), 
                   `:=` (totFATALITIES=sum(FATALITIES), totINJURIES=sum(INJURIES), 
                         totPROPDMG=sum(propdmg2), totCROPDMG=sum(cropdmg2))]
datTotYear <- unique(datTotYear, by = "bgn_year")



datQ1 <- datTotEvent[order(totFATALITIES, totINJURIES, decreasing = TRUE)]
datQ1 <- datQ1[totFATALITIES > 0,]
datQ1 <- datQ1[order(totFATALITIES, decreasing = TRUE)]

levelsQ1 <- datQ1[,c("EVTYPE", "totFATALITIES"), with=FALSE]
levelsQ1 <- levelsQ1[order(totFATALITIES, decreasing=TRUE)]
levelsQ1 <- levelsQ1[["EVTYPE"]]

datQ1 <- transform(datQ1, EVTYPE = factor(EVTYPE, levels = levelsQ1))
datQ1 <- head(datQ1,10)



datQ2 <- datTotEvent[order(totPROPDMG, totCROPDMG, decreasing = TRUE)]

# The palette with grey:
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", 
               "#F0E442", "#0072B2", "#D55E00", "#CC79A7", "gold", "green3")

# To use for fills, add
scale_fill_manual(values=cbPalette)

# To use for line and point colors, add
scale_colour_manual(values=cbPalette)


qplot(x=EVTYPE, y = totFATALITIES, data = datQ1, fill=EVTYPE, 
      geom="bar", stat="identity", xlab="Type of Event", ylab="Number of Fatalities") +
theme(axis.text.x = element_text(angle=90, hjust=1, vjust=0)) + 
scale_fill_manual(values=cbPalette)



g <- qplot(EVTYPE, totFATALITIES, data = datQ1, aes(x=EVTYPE, fill=EVTYPE))
g + geom_bar(stat = "identity", width=0.5) 
    






g <- qplot(factor(bgn_year), totFATALITIES, data = datQ1)
    
g + geom_bar(stat = "identity", width = 0.7) +
    labs(title = "Emissions from 1999-2008 for 
                motor vehicle sources in Baltimore City") + 
    labs(x = "Year", y = "Emission (Thousands Tons)") 


## The events in the database start in the year 1950 and end in November 2011. 
## 1.   The basic goal of this assignment is to explore the NOAA Storm Database and answer 
##      some basic questions about severe weather events. 
## 2.   You must use the database to answer the questions below and show the code for your entire analysis. 
## 3.   Your analysis can consist of tables, figures, or other summaries. 
## 4.   You may use any R package you want to support your analysis.



1. Is the document written in English?
2. Does the document have a title that briefly summarizes the data analysis? 
3. Does the document have a synopsis that describes and summarizes the data analysis 
in less than 10 sentences?
4. Is there a section titled "Data Processing" that describes how the data were loaded 
into R and processed for analysis?
5. Is there a section titled "Results" where the main results are presented?

6. Is there at least one figure in the document that contains a plot?
7. Are there at most 3 figures in this document?

8. Does the analysis start from the raw data file (i.e. the original .csv.bz2 file)?
9. Does the analysis address the question of which types of events are most harmful 
to population health?
10. Does the analysis address the question of which types of events have the greatest
economic consequences?
11. Do all the results of the analysis (i.e. figures, tables, numerical summaries) appear 
to be reproducible?
12. Do the figure(s) have descriptive captions (i.e. there is a description near the
figure of what is happening in the figure)?
13. Does the analysis include description and justification for any data transformations?




## Question 1
## Across the United States, which types of events (as indicated in the EVTYPE variable) 
## are most harmful with respect to population health?




## Question 2
## Across the United States, which types of events have the greatest economic consequences?




listEVT <- datZero[["EVTYPE"]]

listEVT <- unique(listEVT, by = "EVTYPE")
listEVT <- listEVT[sort.list(listEVT)]
