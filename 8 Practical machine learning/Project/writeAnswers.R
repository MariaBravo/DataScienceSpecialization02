require(caret)
require(randomForest)
require(corrplot)

rawData <- read.table("pml-training.csv", sep=',', header=TRUE, stringsAsFactors = FALSE,
                      na.strings=c('NA','','#DIV/0!'))

NAindex <- apply(rawData,2,function(x) {sum(is.na(x))})
data <- rawData[,which(NAindex == 0)]
data <- data[,-c(1:7)]
data$classe <- as.factor(data$classe)



rm(rawData)
set.seed(11230)
inTrain = createDataPartition(data$classe, p = 0.7, list=FALSE)
training = data[inTrain,]
testing = data[-inTrain,]
rm(inTrain)


trn_nzv <- nearZeroVar(training, saveMetrics=TRUE)
training <- training[!trn_nzv$nzv]
testing <- testing[!trn_nzv$nzv]


rm(trn_nzv)
trn_numcol <- which(lapply(training,class) %in% c('numeric'))
training <- cbind(training["classe"], training[,trn_numcol])
testing <- cbind(testing["classe"], testing[,trn_numcol])


rm(trn_numcol)
correlation <- cor(training[2:28])
highCorr <- findCorrelation(correlation, cutoff = .95)

if (length(highCorr) >  0)
{
    training <- training[,-highCorr]
    testing <- testing[,-highCorr]
}


rfModel <- randomForest(classe ~ ., training)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
print(rfModel)

goalData <- read.csv("pml-testing.csv", header=TRUE)
answers <- predict(rfModel, goalData)

answers




pml_write_files = function(x){
    n = length(x)
    for(i in 1:n){
        filename = paste0("problem_id_",i,".txt")
        write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
    }
}


pml_write_files(answers)
