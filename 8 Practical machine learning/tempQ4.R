## Question 1


library(caret)

library(ElemStatLearn)
data(vowel.train)
data(vowel.test) 

vowel.train$y <- factor(vowel.train$y)
vowel.test$y <- factor(vowel.test$y)

set.seed(33833)
modFit1 <- train(y ~ ., data=vowel.train, method="rf")
modFit2 <- train(y ~ ., data=vowel.train, method="gbm", verbose=FALSE)



pred1 <- predict(modFit1, vowel.test)
x1 <- table(pred1, vowel.test$y)
confusionMatrix(x1)

pred2 <- predict(modFit2, vowel.test)
x2 <- table(pred2, vowel.test$y)
confusionMatrix(x2)

x3 <- table(pred1, pred2)
confusionMatrix(x3)

##   .Random.seed


#Question 2

library(caret)
library(gbm)
set.seed(3433)
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]


set.seed(62433)
modTrain1 <- train(diagnosis ~ ., data=training, method="rf",
                 trControl=trainControl(method="cv"), number=3)
modTrain2 <- train(diagnosis ~ ., data=training, method="gbm", verbose=FALSE)
modTrain3 <- train(diagnosis ~ ., data=training, method="lda",
                 metric="Accuracy")


predTrain1 <- predict(modTrain1, training)
predTrain2 <- predict(modTrain2, training)
predTrain3 <- predict(modTrain3, training)


predTest1 <- predict(modTrain1, testing)
predTest2 <- predict(modTrain2, testing)
predTest3 <- predict(modTrain3, testing)




predDF <- data.frame(predTrain1, predTrain2, predTrain3, diagnosis=training$diagnosis)
combModFit <- train(as.factor(diagnosis) ~ ., data=predDF, method = 'rf', number=3)


predTest <- data.frame(predTest1, predTest2, predTest3, diagnosis=testing$diagnosis)

predAll <- predict(combModFit, predTest)
predAll <- predict(combModFit, testing)

x1 <- table(predTest1, testing$diagnosis)
x2 <- table(predTest2, testing$diagnosis)
x3 <- table(predTest3, testing$diagnosis)

x <- table(predAll, testing$diagnosis)

confusionMatrix(x)          ## 0.8415   all      0.8171 
confusionMatrix(x1)         ## 0.8049   rf       0.7927
confusionMatrix(x2)         ## 0.8171   gbm      0.8049
confusionMatrix(x3)         ## 0.7683   lda      0.7683

        

##************************************************


library(caret)
library(gbm)
set.seed(3433)
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]


set.seed(62433)
fit1 <- train(diagnosis ~. , data = training, method = "rf")
fit2 <- train(diagnosis ~. , data = training, method = "gbm")
fit3 <- train(diagnosis ~. , data = training, method = "lda")

pred1 <- predict(fit1, testing)
pred2 <- predict(fit2, testing)
pred3 <- predict(fit3, testing)

predDF <- data.frame(pred1, pred2, pred3, diagnosis = testing$diagnosis)
comFit <- train(diagnosis ~ ., method = "rf", data = predDF)
comPred <- predict(comFit, testing)


x1 <- table(pred1, testing$diagnosis)
x2 <- table(pred2, testing$diagnosis)
x3 <- table(pred3, testing$diagnosis)

x <- table(comPred, testing$diagnosis)

confusionMatrix(x)          ## 0.8415   all      0.8171 
confusionMatrix(x1)         ## 0.8049   rf       0.7927
confusionMatrix(x2)         ## 0.8171   gbm      0.8049
confusionMatrix(x3)         ## 0.7683   lda      0.7683

confusionMatrix(pred1, testing$diagnosis)
confusionMatrix(pred2, testing$diagnosis)
confusionMatrix(pred3, testing$diagnosis)
confusionMatrix(comPred, testing$diagnosis)


##************************************************

## Question 3
library(caret)
set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]


set.seed(233)
modFit <- train(CompressiveStrength ~ ., data=training, method="lasso")
modFit$finalModel
plot(modFit$finalModel)
plot.enet(modFit$finalModel, xvar = "penalty", use.color = TRUE)


#Question 4
library(forecast)
library(lubridate)  # For year() function below
dat = read.csv("gaData.csv")
training = dat[year(dat$date) < 2012,]
testing = dat[(year(dat$date)) > 2011,]

tstrain = ts(training$visitsTumblr)
tstesting = ts(testing$visitsTumblr)

fit <- bats(tstrain, use.parallel=FALSE)
pred <- forecast(fit, h=length(testing$visitsTumblr),level=c(80,95))


d <- data.frame(tstesting, pred$upper[,2], pred$lower[,2])
names(d) <- c("test","upper","lower")
vup <- (d$test <= d$upper)
vdown <- (d$test > d$lower)
vtot <- vup & vdown
sum(vtot*1)/235

##str(pred)
##pred$lower
##pred$upper

#Question 5
library(caret)
set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]

set.seed(325)
library(e1071)

modelFit <- svm(CompressiveStrength ~ ., data = training)
x <- predict(modelFit, testing)
RMSE(x, testing$CompressiveStrength)

RMSE(testing, x)
















