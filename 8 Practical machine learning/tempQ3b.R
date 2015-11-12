## Question 1

library(AppliedPredictiveModeling)
data(segmentationOriginal)
library(caret)

inTrain <- createDataPartition(y=segmentationOriginal$Case,
                               p=0.75, list = FALSE)
training <- segmentationOriginal[inTrain,]
training <- segmentationOriginal[-inTrain,]

set.seed(125)

test_set = subset(segmentationOriginal, Case == "Test");
train_set = subset(segmentationOriginal, Case == "Train");


modFit<-train(Class~.,method="rpart", train_set)
print(modFit$finalModel)


plot(modFit$finalModel,uniform=TRUE,main="Classification Tree")
text(modFit$finalModel,use.n=TRUE,all=TRUE,CEX=0.8)
library(rattle)
fancyRpartPlot(modFit$finalModel)



## Question 3

library(pgmm)
data(olive)
olive = olive[,-1]

inTrain <- createDataPartition(y=olive$Area,
                               p=0.7, list=FALSE)
training <- olive[inTrain,]
testing <- olive[-inTrain,]


modFit <- tree(Area ~ ., method = 'class', data=training)
print(modFit$finalModel)
newdata <- as.data.frame(t(colMeans(olive)))
predict(modFit, newdata)


## Question 4
library (caret)
library(ElemStatLearn)
data(SAheart)
set.seed(8484)
train = sample(1:dim(SAheart)[1],size=dim(SAheart)[1]/2,replace=F)
trainSA = SAheart[train,]
testSA = SAheart[-train,]


set.seed(13234)

##testSAnew <- testSA[ , 
##                    c("age", "alcohol", "obesity", "tobacco", "typea", "ldl", "chd")]

##trainSAnew <- trainSA[ , 
##                    c("age", "alcohol", "obesity", "tobacco", "typea", "ldl", "chd")]


##fitModel <- glm(chd ~ age + alcohol + obesity + tobacco + typea + ldl,
##                       data=  trainSA, family=binomial)


fitModel <- train(chd ~ age + alcohol + obesity + tobacco + typea + ldl,
                data=  trainSA, method= 'glm', family='binomial')

predicted1 <- predict(fitModel, newdata = trainSA)
predicted2 <- predict(fitModel, newdata = testSA)

##predict(fitModel$finalModel, newdata = testSAnew[1,])

missClass = function(values,prediction){sum(((prediction > 0.5)*1) != values)/length(values)}

missClass(trainSA$chd, predicted1)
missClass(testSA$chd, predicted2)


## Quizz 5

library(ElemStatLearn)
data(vowel.train)
data(vowel.test) 

vowel.train$y <- factor(vowel.train$y)
vowel.test$y <- factor(vowel.test$y)

set.seed(33833)

modFit <- train(y ~ ., data=vowel.train, method="rf", importance=FALSE)

varImp(modFit)











