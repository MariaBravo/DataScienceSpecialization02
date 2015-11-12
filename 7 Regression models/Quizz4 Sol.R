## Q1

In questions 1 and 2, "autoloader" should read "autolander".

In question 5, "coefficients" in the last sentence of the question should be singular,
and would be clearer if it read "coefficient for x".

In addition, there is no variable called "auto" as stated in question 1. 
"Auto" is a value/enum for the variable use. Lastly, "...labeled as "head" in the 
variable headwind (numerator) to tail winds (denominator)" makes little sense. 
There is no variable called "headwind". We really just need to calculate the odds
ratio of autolander-used / autolander-not-used.

library(MASS)

fit <- lm(as.integer(use) ~ ., data = shuttle)

glm(as.integer(use) ~ ., data = shuttle)

glm(formula = use ~ wind, family = binomial, data = shuttle)



# Q2

library(MASS)
data(shuttle)
landing <- glm(use ~ wind + magn, family="binomial", data=shuttle)
summary(landing)
landing$coef
landing$coef[1]/landing$coef[2]

(exp(landing$coef[1]))/(exp(landing$coef[2]))


# Q3

shuttle$auto <- as.numeric(shuttle$use=="auto")

shuttle$wind <- as.numeric(shuttle$wind=="head")

fit2 <- glm(auto ~ wind + magn -1, binomial, shuttle)

fit4 <- glm(1-auto ~ wind + magn -1, binomial, shuttle)

fit2$coefficients

fit4$coefficients






# Q4

fit <- glm(count ~ spray - 1, data = InsectSprays, family = "poisson")

(exp(fit$coeff))


# Q5


# Q6
x <- -5:5
y <- c(5.12, 3.93, 2.67, 1.87, 0.52, 0.08, 0.93, 2.05, 2.54, 3.87, 4.97)

knots <- seq(0,4*pi,length=20)
splineTerms <- sapply(knots,function(knot) (x > knot) * (x - knot))
xMat <- cbind(1,x,splineTerms)
yhat <- predict(lm(y ~ xMat - 1))


