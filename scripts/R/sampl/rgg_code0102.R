require(hdrcde)
require(vioplot)
require(Hmisc)

x <- c(rnorm(100,0,1), rnorm(100,3,1))
opar <- par(mfrow=c(1,5), mar=c(3,2,4,1))

xxx <- seq(min(x), max(x), length=500)
yyy <- dnorm(xxx)/2 + dnorm(xxx, mean=3)/2

plot(yyy, xxx, type="l",main="Underlying\ndensity")

boxplot(x, col="gray90", main="standard\nboxplot")
hdr.boxplot(x, main="HDR\nboxplot")
vioplot(x)
title("violin plot")
plot(x)
par(opar)

