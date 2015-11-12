## Quizz 3


## Q1
data(mtcars)
fit <- lm(mpg ~ as.factor(cyl) + wt, data=mtcars)
coef(fit)


## Just a side note: you don't have to worry about excluding the 
## intercept--if you forget to do so then R will automatically exclude 
## it for you. The benefit of this approach is that then the 4-cylinder 
## cars will be treated as a baseline and the coefficients 
## for 6-cyl & 8-cyl can be interpreted as the difference in performance 
## relative to the benchmark.
##

mycol=rainbow(8)
plot(mtcars$wt, mtcars$mpg, pch=19, col=mycol[mtcars$cyl])
abline(c(fit$coeff[1],fit$coeff[4]),col="red",lwd=3)
abline(c(fit$coeff[1] + fit$coeff[2] ,fit$coeff[4]),col="blue",lwd=3)
abline(c(fit$coeff[1] + fit$coeff[3] ,fit$coeff[4]),col="black",lwd=3)


## Q2

data(mtcars)
fit1 <- lm(mpg ~ as.factor(cyl), data=mtcars)
coef(fit1)

fit2 <- lm(mpg ~ as.factor(cyl) + wt, data=mtcars)
coef(fit2)


mycol=rainbow(8)
plot(mtcars$wt, mtcars$mpg, pch=19, col=mycol[mtcars$cyl])
abline(c(fit2$coeff[1],fit2$coeff[4]),col="red",lwd=3)
abline(c(fit2$coeff[1] + fit2$coeff[2] ,fit2$coeff[4]),col="blue",lwd=3)
abline(c(fit2$coeff[1] + fit2$coeff[3] ,fit2$coeff[4]),col="black",lwd=3)



## Q3

fit <-lm(mpg~factor(cyl)+wt,data=mtcars)
fit1 <-lm(mpg~factor(cyl)+wt+interaction(cyl,wt),data=mtcars)
anova(fit,fit1)


## Q4
lm(mpg ~ I(wt * 0.5) + factor(cyl), data = mtcars)

##wt is in 1000 lbs
##ton == short ton == 2000 lbs != tonne == metric ton == 1000 kg
##(which is very confusing for a non-native-speaker that is used to the metric system)

##If you are unsure, you can create two linear models

##with wt => the coefficient is the expected change per 1000 lbs
##with I(wt * 0.5) => what unit do you have to use with this coefficient that the change per 1000 lbs is identical to the first model?

"The estimated expected change in MPG per one ton increase in weight 
for a specific number of cylinders (4, 6, 8)."



## Q6

x <- c(0.586, 0.166, -0.042, -0.614, 11.72)
y <- c(0.549, -0.026, -0.127, -0.751, 1.344)

lm1 <- lm(y ~ x)
hatvalues(lm1)



## Q6

x <- c(0.586, 0.166, -0.042, -0.614, 11.72)
y <- c(0.549, -0.026, -0.127, -0.751, 1.344)

lm1 <- lm(y ~ x)
hatvalues(lm1)
dfbetas(lm1)

##hv <- hatvalues(lm1)
##hvm <- which(hv == max(hv))


see lect 10, slide 10/16.  Just list results...
Yes, I was looking at this slide when I was working on this question.

Here is my values:
    
    > hatvalues(lm(y ~ x))
1         2         3         4         5 
0.2286650 0.2438146 0.2525027 0.2804443 0.9945734 
> dfbeta(lm(y ~ x))
(Intercept)             x
1  0.179114788 -0.0121326898
2  0.019389317 -0.0015645704
3 -0.005003872  0.0004341606
4 -0.207238438  0.0212223777
5  0.007472953 -0.9312924179

So the 5th point has the highest hat values, so we need the slope in 5-th row in dfbetas. That's -0.9312924179. Where I'm wrong?

##dfbeta: effect on coefficients of deleting each observation in turn
##dfbetas: effect on coefficients of deleting each observation in turn, 
##standardized by a deleted estimate of the coefficient standard error









