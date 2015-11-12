prostate <- read.csv("prostate.csv")
library(tree)
pstree <- tree(lcavol ~., data=prostate, mincut=1)
plot(pstree, col=12, main="Classification Tree for prediction of prostate cancer tumor", cex=2)
text(pstree, digits=2, cex=0.7, all=TRUE)


test <- data.frame(lcavol=0,age=50,lbph=-1.39,lcp=-1.39,gleason=6,lpsa=-0.431)

logsize <- predict(pstree,test)
volcc <- 10 ^ logsize


pstcut <- prune.tree(pstree,k=1.7)
plot(pstcut)
pstcut
pstcut <- prune.tree(pstree,k=2.05)
plot(pstcut)
pstcut
pstcut <- prune.tree(pstree,k=3)
plot(pstcut)
pstcut
pstcut <- prune.tree(pstree)
pstcut
plot(pstcut)
pstcut <- prune.tree(pstree,best=3)
pstcut
set.seed(2)
cvpst <- cv.tree(pstree, K=10)
cvpst$size

cvpst$dev
plot(cvpst, pch=21, bg=8, type="p", cex=1.5, ylim=c(65,100))

pstcut <- prune.tree(pstree, best=3)
pstcut

plot(pstcut, col=8)
text(pstcut)


plot(prostate[,c("lcp","lpsa")],cex=0.2*exp(prostate$lcavol))
abline(v=.261624, col=4, lwd=2)
lines(x=c(-2,.261624), y=c(2.30257,2.30257), col=4, lwd=2)




     
     
     