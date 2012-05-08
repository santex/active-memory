require(gplots)

# example data, bivariate normal, no correlation
x <- rnorm(2000, sd=4)
y <- rnorm(2000, sd=1)

# separate scales for each axis, this looks circular
hist2d(x,y, nbins=50, col = c("white",heat.colors(16)))
rug(x,side=1)
rug(y,side=2)
box()
