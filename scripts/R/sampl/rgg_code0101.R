
h <- hist(geyser$waiting, prob=TRUE, plot=FALSE)

# compute the frequency polygon
diffBreaks <- h$mids[2] - h$mids[1]
xx <- c( h$mids[1]-diffBreaks, h$mids, tail(h$mids,1)+diffBreaks )
yy <- c(0, h$density, 0)

# draw the histogram 
hist(geyser$waiting, prob = TRUE, xlim=range(xx),
    border="gray", col="gray90")

# adds the frequency polygon
lines(xx, yy, lwd=2, col = "royalblue")
