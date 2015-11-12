

rawData <- read.table("pml-training.csv", sep=',', header=TRUE, stringsAsFactors = FALSE,
                      na.strings=c('NA','','#DIV/0!'))

NAindex <- apply(rawData,2,function(x) {sum(is.na(x))})
cleanData <- rawData[,which(NAindex == 0)]
#Further remove qualitative features, trial numbers and summary statistics of individual observations from training data
cleanData <- cleanData[,-c(1:7)]
cleanData$classe <- as.factor(cleanData$classe)


## Cross validation set
library(caret)
set.seed(12031987)

inTrain = createDataPartition(cleanData$classe, p = 0.7, list=FALSE)
training = cleanData[inTrain,]
crossValidation = cleanData[-inTrain,]

modFit <- train(classe ~., method="rf", data=training, 
                trControl=trainControl(method='cv'), 
                number=5, allowParallel=TRUE )




testData <- read.table("pml-testing.csv", sep=',', header=TRUE, stringsAsFactors = FALSE,
                      na.strings=c('NA','','#DIV/0!'))

NAindex <- apply(testData,2,function(x) {sum(is.na(x))})
cleanTestData <- testData[,which(NAindex == 0)]

cleanTestData <- cleanTestData[,-c(1:7)]
##cleanTestData$classe <- as.factor(cleanTestData$classe)

predict(modFit, testData)