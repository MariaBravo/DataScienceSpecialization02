library(AppliedPredictiveModeling)
data(concrete)
library(caret)
library(Hmisc)

set.seed(975)
inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training = mixtures[ inTrain,]
testing = mixtures[-inTrain,]

con.var <- runif(100,0,10)
cut(con.var, breaks = 3, labels = c("small", "medium", "large"))

cutCompressiveStrength <- cut2(training$CompressiveStrength, g = 4)
cutAge <- cut2(training$Age, g = 4)
cutFlyAsh <- cut2(training$FlyAsh, g = 4)
cutSuperplasticizer <- cut2(training$Superplasticizer, g = 4)
cutCement <- cut2(training$Cement, g = 4)
cutWater <- cut2(training$Water, g = 4)
cutCoarseAggregate <- cut2(training$CoarseAggregate, g = 4)
cutFineAggregate <- cut2(training$FineAggregate, g = 4)

featurePlot(y=training$CompressiveStrength, x=training[,c("Age", "FlyAsh")], plot="pairs")
qq <- qplot(CompressiveStrength,FlyAsh, data=training)
qq + geom_smooth(method='lm', formula=y~x)

qq <- qplot(CompressiveStrength,Age, data=training)
qq + geom_smooth(method='lm', formula=y~x)


qq <- qplot(CompressiveStrength,data=training)
qq

par(mfrow=c(2,1))
plot(training$CompressiveStrength, type="l")
plot(training$FlyAsh, type="l")

plot(training$Age, type="l")
plot(training$Superplasticizer, type="l")

plot(training$Cement, type="l")
plot(training$Water, type="l")
plot(training$CoarseAggregate, type="l")
plot(training$FineAggregate, type="l")


with(training, plot(CompressiveStrength, col=cutAge))
with(training, plot(CompressiveStrength, col=cutFlyAsh))
with(training, plot(CompressiveStrength, col=cutCement))
with(training, plot(CompressiveStrength, col=cutWater))
with(training, plot(CompressiveStrength, col=cutCoarseAggregate))
with(training, plot(CompressiveStrength, col=cutFineAggregate))
with(training, plot(CompressiveStrength, col=cutSuperplasticizer))
with(training, plot(CompressiveStrength, col=cutCompressiveStrength))


qplot(cutFlyAsh, CompressiveStrength, data=training, col=cutFlyAsh)
qplot(training$CompressiveStrength, col=cutFlyAsh)


q <- qplot(CompressiveStrength, FlyAsh, data=training) 
q + geom_smooth(method='lm', formula=y~x) 


##---------------------------------------------------------------


library(AppliedPredictiveModeling)
data(concrete)
library(caret)
set.seed(975)
inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training = mixtures[ inTrain,]
testing = mixtures[-inTrain,]

qplot(Superplasticizer, data=training, geom="density")




##------------------------------------------------------------
##------------------------------------------------------------
##------------------------------------------------------------


set.seed(3433)
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]


l1 <- grep("IL", names(training))
n <- names(testing)
smallTraining <- training[, n[l1]]

##preProc<-preProcess(smallTraining[,-1],method="pca")
##trainPC<-predict(preProc,smallTraining[,-1])

smallTraining.pca <- prcomp(smallTraining, scale.=TRUE)   ## perform PCA on data, use scaling as well as centering
# this procedure also returns the std. deviation for each principal component in a vector
# this vector, when squared, gives variances, which add up to the original data variance
var.vector <- smallTraining.pca$sdev^2                 ## vector of variance for each PC
relative.var <- var.vector/sum(var.vector)  ## divide all by the total variance to get the share for each
relative.var           ## show variance explained by each component
cumsum(relative.var)   ## show the variance explained by first X components (cumulative sum)


##----------------------------------------------------------------
##----------------------------------------------------------------

set.seed(3433)
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]

l1 <- grepl("^IL", colnames(training), ignore.case = T)
n <- names(testing)
smallTraining <- training[, n[l1]]

smallTraining.pca <- prcomp(smallTraining, scale.=TRUE)   ## perform PCA on data, use scaling as well as centering
# this procedure also returns the std. deviation for each principal component in a vector
# this vector, when squared, gives variances, which add up to the original data variance
var.vector <- smallTraining.pca$sdev^2                 ## vector of variance for each PC
relative.var <- var.vector/sum(var.vector)  ## divide all by the total variance to get the share for each
relative.var           ## show variance explained by each component
cumsum(relative.var)   ## show the variance explained by first X components (cumulative sum)


##--------------------------------------------
##--------------------------------------------


set.seed(3433)
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]


training <- training[c(1,58:69)]
testing <-testing[c(1,58:69)]

g1 <- train(training$diagnosis~., data=training, method="glm")
confusionMatrix(testing$diagnosis, predict(g1, testing))

preProc <- preProcess(training[,-1], method="pca", thresh=0.8)
trainPC<-predict(preProc, training[,-1])
testPC<-predict(preProc, testing[,-1])
g2 <- train(training$diagnosis~., data=trainPC, method="glm")
confusionMatrix(testing$diagnosis, predict(g2, testPC))



I train a pca with a threshold of 0.8 on the training set and produce both 
a preprocessed training and test set named psubTrain, psubTest. 
Note this is the same pca model required for question 4 which I correctly answered.

To train the first glm I just run
g1 <- train(training$diagnosis~., data=subTrain, method="glm")

to train the second glm I run
g2 <- train(training$diagnosis~., data=psubTrain, method="glm")

finally to evaluate the accuracy
# for first model
mean(testing$diagnosis == predict(g1, subTest))
# for second model
mean(testing$diagnosis == predict(g2, psubTest))

Turns out I accidentally assigned the training data to the subset of test data 
when extracting the IL* columns. 

used your function as well as the confusionMatrix.







