
Q1

x <- c(0.61, 0.93, 0.83, 0.35, 0.54, 0.16, 0.91, 0.62, 0.62)
y <- c(0.67, 0.84, 0.6, 0.18, 0.85, 0.47, 1.1, 0.65, 0.36)
f <- lm(y ~ x)
f

##----------------------------------------

Q2

x <- c(0.61, 0.93, 0.83, 0.35, 0.54, 0.16, 0.91, 0.62, 0.62)
y <- c(0.67, 0.84, 0.6, 0.18, 0.85, 0.47, 1.1, 0.65, 0.36)

fit=lm(y~x)
res=resid(fit)
sd(res)


##yh = 0.1885+0.7224*x
##sd(y-yh)


summary(fit)$sigma 

//**********************************************

Q3


data (mtcars)

attach (mtcars)

car.lm <- lm (mpg ~ wt)
avgweight = mean (mtcars$wt)
newdata = data.frame (wt = avgweight)
predict (car.lm, newdata,interval="confidence")

//----------------------------------------------------
    
Q5

data(mtcars)
attach (mtcars)

fit <- lm(mpg ~ wt, data = mtcars) 
newdata <- data.frame(wt=3.00)
predict(fit, newdata, interval = ("predict"))



//----------------------------------------------------
Q6
    
    
mpg=mtcars$mpg
weight=mtcars$wt
weight2=weight/2
fit3<-lm(mpg~weight2)
sumCoef<-summary(fit3)$coefficients
sumCoef[2,1]+c(-1,1)*qt(.975,df=fit3$df)*sumCoef[2,2]



//*********************************
    
Q9

beta1 =cor(y,x)???sd(y)/sd(x)
beta0 =mean(y)???beta1???mean(x)
e1 = y???beta0???beta1???x
ssq1 =sum(e^2)

e2=y???mean(y)  # with just the intercept, I am guessing the horizontal line is at mean of y
ssq2=sum(e2^2)

ssq2/ssq1



//---------------------------------------
    












