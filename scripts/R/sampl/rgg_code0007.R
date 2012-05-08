par(bg="white")
n <- 100
set.seed(43214) #just so we have the same exact graph
x <- c(0,cumsum(rnorm(n)))
y <- c(0,cumsum(rnorm(n)))
xx <- c(0:n, n:0)
yy <- c(x, rev(y))
plot(xx, yy, type="n", xlab="Time", ylab="Distance")
polygon(xx, yy, col="gray")
title("Distance Between Brownian Motions")

