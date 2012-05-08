x <- c(rnorm(100), rnorm(50, mean=2,sd=.5))
h <- hist(x, plot=FALSE, breaks=20)

# quick hack to transform histogram into cumulative 
# histogram
#  actually, only the first command is required
#  but this is cleaner to do the 3 of them
h$counts     <- cumsum(h$counts)
h$density    <- cumsum(h$density)
h$itensities <- h$density


plot(h, freq=TRUE, main="(Cumulative) histogram of x", 
 col="navajowhite2", border="turquoise3")
box()

