require(circular)

op <- par(xpd=NA, no.readonly=TRUE)

set.seed(7)
x <- rvonmises(n=100, mu=pi, kappa=2)
res25 <- density(x, bw=25)
plot(res25, points.plot=TRUE, xlim=c(-1.5,1))
res50 <- density(x, bw=25, adjust=2)
lines(res50, col=2)

par(op)

