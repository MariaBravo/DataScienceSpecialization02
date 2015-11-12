

library(data.table)
library(xtable)
library(ggplot2)
options(scipen=999)

##f <- tempfile()
##download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2", f)
##datZero <- data.table(read.csv(bzfile(f)))


datZero <- data.table(read.csv("repdata_data_StormData.csv", sep=",", header=TRUE))

# cutting years until 1996 and comments, adding formatted date
dat1 <- datZero[year(strptime( datZero[["BGN_DATE"]] , "%m/%d/%Y %H:%M:%S")) >= 1996]

dat1 <- dat1[, c("BGN_DATE", "STATE",
                 "EVTYPE", "FATALITIES", "INJURIES", "PROPDMG", 
                 "PROPDMGEXP", "CROPDMG", "CROPDMGEXP") , with = FALSE]

dat1 <- dat1[, bgn_date2:= as.Date(strptime( dat1$BGN_DATE, "%m/%d/%Y %H:%M:%S")) ]

dat1 <- dat1[, bgn_year:= year(bgn_date2) ]

dat1 <- dat1[ FATALITIES > 0 | INJURIES > 0 | PROPDMG > 0 | CROPDMG > 0, ]



## obtaining valid PROPDMGEXP
zz <- dat1["PROPDMG" > 0, list(PROPDMGEXP) ]
aa <- zz[order(PROPDMGEXP)]
aa <- unique(aa)

## obtaining valid CROPDMGEXP
zz <- dat1["CROPDMG" > 0, list(CROPDMGEXP) ]
aa <- zz[order(CROPDMGEXP) ]
aa <- unique(aa)


dat1[, propdmg0:= 0] 
dat1[, propdmgK:= 0] 
dat1[, propdmgM:= 0] 
dat1[, propdmgB:= 0] 

dat1[as.character(dat1$PROPDMGEXP) == "0" & "PROPDMG" > 0, propdmg0 := PROPDMG*1]
dat1[as.character(dat1$PROPDMGEXP) == "K" & "PROPDMG" > 0, propdmgK := PROPDMG*1000]
dat1[as.character(dat1$PROPDMGEXP) == "M" & "PROPDMG" > 0, propdmgM := PROPDMG*1000000]
dat1[as.character(dat1$PROPDMGEXP) == "B" & "PROPDMG" > 0, propdmgB := PROPDMG*1000000000]

dat1[is.na(dat1$propdmg0), propdmg0:=0]
dat1[is.na(dat1$propdmgK), propdmgK:=0]
dat1[is.na(dat1$propdmgM), propdmgM:=0]
dat1[is.na(dat1$propdmgB), propdmgB:=0]



dat1[, cropdmg0:= 0] 
dat1[, cropdmgK:= 0] 
dat1[, cropdmgM:= 0] 
dat1[, cropdmgB:= 0] 

dat1[as.character(dat1$CROPDMGEXP) == "0" & "CROPDMG" > 0, cropdmg0 := CROPDMG*1]
dat1[as.character(dat1$CROPDMGEXP) == "K" & "CROPDMG" > 0, cropdmgK := CROPDMG*1000]
dat1[as.character(dat1$CROPDMGEXP) == "M" & "CROPDMG" > 0, cropdmgM := CROPDMG*1000000]
dat1[as.character(dat1$CROPDMGEXP) == "B" & "CROPDMG" > 0, cropdmgB := CROPDMG*1000000000]

dat1[is.na(dat1$cropdmg0), cropdmg0:=0]
dat1[is.na(dat1$cropdmgK), cropdmgK:=0]
dat1[is.na(dat1$cropdmgM), cropdmgM:=0]
dat1[is.na(dat1$cropdmgB), cropdmgB:=0]


aaaaaaaaaaaaaaaaaaaa

datTotEvent <- dat1[order(EVTYPE, bgn_year)]
datTotEvent <- datTotEvent[, by="EVTYPE", 
                           `:=` (totFATALITIES=sum(FATALITIES), totINJURIES=sum(INJURIES), 
                                 totPROPDMG = sum(propdmg0/1000) + 
                                     sum(propdmgK/1000) +
                                     sum(propdmgM/1000) + 
                                     sum(propdmgB/1000),
                                 totCROPDMG = sum(cropdmg0/1000) + 
                                     sum(cropdmgK/1000) +
                                     sum(cropdmgM/1000) + 
                                     sum(cropdmgB/1000))]                        
datTotEvent <- unique(datTotEvent, by = "EVTYPE")


datQ1 <- datTotEvent[order(totFATALITIES, totINJURIES, decreasing = TRUE)]
datQ1 <- datQ1[totFATALITIES > 0,]
datQ1 <- datQ1[order(totFATALITIES, decreasing = TRUE)]

levelsQ1 <- datQ1[,c("EVTYPE", "totFATALITIES"), with=FALSE]
levelsQ1 <- levelsQ1[order(totFATALITIES, decreasing=TRUE)]
levelsQ1 <- levelsQ1[["EVTYPE"]]

datQ1 <- transform(datQ1, EVTYPE = factor(EVTYPE, levels = levelsQ1))
datQ1 <- head(datQ1,10)



datQ2 <- datTotEvent[, totECONDMG := totPROPDMG + totCROPDMG]
datQ2 <- datTotEvent[totECONDMG > 0,]
datQ2 <- datTotEvent[order(totECONDMG, decreasing = TRUE)]

levelsQ2 <- datQ2[,c("EVTYPE", "totECONDMG"), with=FALSE]
levelsQ2 <- levelsQ2[order(totECONDMG, decreasing=TRUE)]
levelsQ2 <- levelsQ2[["EVTYPE"]]

datQ2 <- transform(datQ2, EVTYPE = factor(EVTYPE, levels = levelsQ2))
datQ2 <- head(datQ2,10)


library(ggplot2)

# The palette 
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", 
               "#F0E442", "#0072B2", "#D55E00", "#CC79A7", "gold", "green3")

# To use for fills, add
scale_fill_manual(values=cbPalette)

# To use for line and point colors, add
scale_colour_manual(values=cbPalette)

qplot(x=EVTYPE, y = totFATALITIES, data = datQ1, fill=EVTYPE, 
      geom="bar", stat="identity", xlab="Type of Event", ylab="Number of Fatalities") +
      labs(title = "Fatalities caused by severe weather") +
    opts(legend.position = "none") +    
theme(axis.text.x = element_text(angle=90, hjust=1, vjust=0)) + 
scale_fill_manual(values=cbPalette)



##************************************************


library(xtable)
d.table <- xtable(datQ2)
print(d.table,type="html")








## Analysis


datTotYear <- dat1[order(bgn_year, EVTYPE)]
datTotYear <- datTotYear[, by=year(datTotYear$bgn_date2), 
                         `:=` (totFATALITIES = sum(FATALITIES), 
                               totINJURIES = sum(INJURIES), 
                               totPROPDMG = sum(propdmg0/1000) + 
                                            sum(propdmgK/1000) +
                                            sum(propdmgM/1000) + 
                                            sum(propdmgB/1000),
                               totCROPDMG = sum(cropdmg0/1000) + 
                                   sum(cropdmgK/1000) +
                                   sum(cropdmgM/1000) + 
                                   sum(cropdmgB/1000))]
datTotYear <- unique(datTotYear, by = "bgn_year")
datTotYear <- datTotYear[,list(bgn_year,EVTYPE,totFATALITIES,
                            totINJURIES,totPROPDMG,totCROPDMG)]




with(datTotYear, plot(bgn_year, totPROPDMG, pch = NA, type="l", 
                 ylab="Average",
                 xlab = "Interval"))

lines(datTotYear$bgn_year, datTotYear$totCROPDMG, col = "blue", lwd = 2)


#-----------


datTotGeo <- dat1[order(STATE, EVTYPE)]
datTotGeo <- datTotGeo[, by=STATE, 
                         `:=` (totFATALITIES = sum(FATALITIES), 
                               totINJURIES = sum(INJURIES), 
                               totPROPDMG = sum(propdmg0/1000000) + 
                                   sum(propdmgK/1000000) +
                                   sum(propdmgM/1000000) + 
                                   sum(propdmgB/1000000),
                               totCROPDMG = sum(cropdmg0/1000000) + 
                                   sum(cropdmgK/1000000) +
                                   sum(cropdmgM/1000000) + 
                                   sum(cropdmgB/1000000))]

datTotGeo <- unique(datTotGeo, by = "STATE")
datTotGeo <- datTotGeo[,list(STATE,totFATALITIES,
                               totINJURIES,totPROPDMG,totCROPDMG)]

datTotGeo <- datTotGeo[order(totPROPDMG, decreasing=TRUE)]
datTotGeo <- head(datTotGeo,10)

datTotGeo$STATE <- as.character(datTotGeo$STATE)
datTotGeo$STATE <- as.factor(datTotGeo$STATE)






ggplot(datTotGeo, aes(STATE, totPROPDMG, fill=STATE) ) + 
    geom_bar(stat="identity", binwidth = 0.7) + 
    labs(title = "Property damage from 1996-2011 for USA") + 
    labs(x = "State", y = "Property damage (Thousand Millions)")+
scale_fill_manual(values=cbPalette)



############################################################################
############################################################################


g1 <- qplot(x=EVTYPE, y = totPROPDMG, data = datQ2, fill=EVTYPE, 
      geom="bar", stat="identity",ylab="Property damage", xlab="") +
    labs(title = "Damage caused by severe weather") + 
    scale_fill_manual(values=cbPalette)

g1 + theme(axis.line=element_blank(),
           axis.text.x=element_blank(),
           axis.ticks=element_blank(),
           axis.title.x=element_blank(),
           legend.position="none") 

g2 <- qplot(x=EVTYPE, y = totPROPDMG, data = datQ2, fill=EVTYPE, 
      geom="bar", stat="identity", xlab="Type of Event", ylab="Property damage") +
    theme(axis.text.x = element_text(angle=90, hjust=1, vjust=0)) + 
    scale_fill_manual(values=cbPalette)

g2


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

g + theme(axis.line=element_blank(),
          axis.text.x=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks=element_blank(),
          axis.title.x=element_blank(),
          axis.title.y=element_blank(),
          legend.position="none",
          panel.background=element_blank(),
          panel.border=element_blank(),
          panel.grid.major=element_blank(),
          panel.grid.minor=element_blank(),
          plot.background=element_blank())



listEVT <- datZero[["EVTYPE"]]

listEVT <- unique(listEVT, by = "EVTYPE")
listEVT <- listEVT[sort.list(listEVT)]


with(datTotGeo, plot(STATE, totPROPDMG/1000, pch = NA, type="l", 
                     ylab="Average",
                     xlab = "Interval"))

lines(datTotGeo$STATE, datTotGeo$totCROPDMG, col = "blue", lwd = 2)


