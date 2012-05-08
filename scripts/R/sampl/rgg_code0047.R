andrews.curves <- function(xdf, cls, npts=101, title="Classes") {
    n <- nrow(xdf)
    clss <- as.factor(cls)
    xpts <- seq(0, 2*pi, length=npts)
    X <- xpts
    for (i in 1:n) {
        xi <- unname(unlist(xdf[i, ]))
        ys <- andrews.function(xi, npts)
        X <- cbind(X, ys)
    }
    ymin <- min(X[, 2:(n+1)])
    ymax <- max(X[, 2:(n+1)])
    plot(0, 0, type="n", xlim=c(0, 2*pi), ylim=c(ymin, ymax),
         main="Andrews' Curves", xlab="", ylab="")

    clrs <- as.integer(clss)
    for (i in 2:(n+1)) {
        lines(X[, 1], X[, i], col=clrs[i-1])
    }
    legend(4, ymax, levels(clss), col=c(1:nlevels(clss)), lty=1)
    # return(X)
}

andrews.function <- function (xs, no.pts=101) {
    n <- length(xs)
    xpts <- seq(0, 2*pi, length=no.pts)
    ypts <- c()
    for (p in xpts) {
        y <- xs[1]
        for (i in 2:n) {
             if (i %% 2 == 1) { y <- y + xs[i]*sin((i %/% 2)*p) }
             else             { y <- y + xs[i]*cos((i %/% 2)*p) }
        }
        ypts <- c(ypts, y)
    }
    return(ypts)
}
###########################################################################
    data(iris)
    old <- par(bg="whitesmoke")
    andrews.curves(iris[,1:4], iris[,5], title="Iris Data")
    par(old)


