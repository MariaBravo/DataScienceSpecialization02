> mn <- 1100
> n <- 9
> s <- 30
> mn + c(-1,1)*qt(0.95, n-1) * s/sqrt(n)
[1] 1081.405 1118.595
> library(datasets); data(mtcars)
> round(t.test(mtcars$mpg)$conf.int)
[1] 18 22
attr(,"conf.level")
[1] 0.95
> attr
function (x, which, exact = FALSE)  .Primitive("attr")
> t.test(mtcars$mpg)$conf.int
[1] 17.91768 22.26357
attr(,"conf.level")
[1] 0.95
> round(mn + c(-1,1)*qt(0.95, n-1) * s/sqrt(n))
[1] 1081 1119
