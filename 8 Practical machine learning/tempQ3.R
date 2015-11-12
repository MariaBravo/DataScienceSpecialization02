
Quiz 3
install.packages("c:\\temp\\pgmm_1.0.tar.gz", repos=NULL, type="source")


Q1

library(AppliedPredictiveModeling)
data(segmentationOriginal)
library(caret)

set.seed(975)

mydata<-segmentationOriginal
inTrain<-createDataPartition(y=mydata$Case,p=0.7,list=FALSE)
training<-mydata[inTrain,]
testing<-mydata[-inTrain,]
dim(training);dim(testing)

test_set = subset(segmentationOriginal, Case == "Test");
train_set = subset(segmentationOriginal, Case == "Train");


modFit<-train(Class~.,method="rpart", training)
print(modFit$finalModel)
plot(modFit$finalModel,uniform=TRUE,main="Classification Tree")
text(modFit$finalModel,use.n=TRUE,all=TRUE,CEX=0.8)
library(rattle)
fancyRpartPlot(modFit$finalModel)


Q4

library(ElemStatLearn)
data(SAheart)
set.seed(8484)
train = sample(1:dim(SAheart)[1],size=dim(SAheart)[1]/2,replace=F)
trainSA = SAheart[train,]
testSA = SAheart[-train,]

set.seed(13234)
fit <- train(form=  ,  method="glm", family = "binomial", data = trainSA)


3. Fit model
fit <- train(form= ... ,  method=..., family =  ..., data = ...)

Parameters:
    method = "glm"  (given)
family = "binomial" (given)
data = "the training set"
form = outcome ~ predictor 1 + ... + predictor 6

4.  Prediction
prediction <- predict(fit, newdata = "the test set")

5. Define misclassification function (given)
    missClass = function(values,prediction){sum(((prediction > 0.5)*1) != values)/length(values)}
we need: missClass(actual chd values, predicted chd values)

6. Calculate the misclassification rate for the model using this function and a prediction on the "response" scale

missClass(values, prediction)
I'm  assuming that values = "the test set" or "the training set"?






