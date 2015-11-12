
# Q1 Q2

x <- c(0.61, 0.93, 0.83, 0.35, 0.54, 0.16, 0.91, 0.62, 0.62)
y <- c(0.67, 0.84, 0.6, 0.18, 0.85, 0.47, 1.1, 0.65, 0.36)

fit <- lm(y ~ x)
summary(fit)



# Q3

data(mtcars)
fit <- lm(mpg ~ wt, mtcars)
sumCoef <- summary(fit)$coefficients
sumCoef[1,1] + c(-1,1) * qt(0.975, df=fit$df)* sumCoef[1,2]

sumCoef[2,1] + c(-1,1) * qt(0.975, df=fit$df)* sumCoef[2,2]


data(mtcars)
y <- mtcars$mpg
x <- mtcars$wt
model <- lm(y~x)
resids <- summary(model)$residuals
sigma2 <- (1/(length(y)-2))*sum(resids^2)
sigma <- sqrt(sigma2)
interval <- qt(0.975,length(y)-2)*sigma*sqrt(1+1/length(y))

##newdata <- data.frame(x = 3)
##p2 <- predict(model,newdata,interval = ("prediction"))


newdata <- data.frame(x = 2)
p2 <- predict(fit,newdata,interval = ("confidence"))


## Question 6
model <- mtcars
model$wt <- model$wt/2
fit <- lm(model$mpg ~ model$wt, model)
sumCoef <- summary(fit)$coefficients
p <- 1*sumCoef[2,1] + sumCoef[2,2]*c(-1,1)*qt(0.975, df=fit$df)





