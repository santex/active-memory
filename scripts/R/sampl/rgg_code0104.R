require(hdrcde)

x <- c(rnorm(200,0,1),rnorm(200,4,1))
y <- c(rnorm(200,0,1),rnorm(200,4,1))
par(mfrow=c(1,2))
plot(x,y, pch="+", cex=.5)
hdr.boxplot.2d(x,y)

