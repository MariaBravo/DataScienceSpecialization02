
library(caret)

datTrain <- read.csv("pml-training.csv", header = TRUE)
datTest <- read.csv("pml-testing.csv", header = TRUE)


data(iris)

inTrain <- createDataPartition(y=iris$Species, p=0.7, list=FALSE)
training <- iris[inTrain,]
testing  <- iris[-inTrain,]

modlda <- train(Species ~ ., data=training, method="lda")
modnb <- train(Species ~ ., data=training, method="nb")
plda <- predict(modlda, testing)
pnb <- predict(modnb, testing)
table(plda, pnb)
