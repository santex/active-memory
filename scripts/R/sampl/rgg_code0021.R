x <- 10*(1:nrow(volcano)); x.at <- seq(100, 800, by=100)
y <- 10*(1:ncol(volcano)); y.at <- seq(100, 600, by=100)

					# Using Gray Scale

image(x, y, volcano, col=gray(100:200/200), axes=FALSE)
contour(x, y, volcano, levels=seq(90, 200, by=5), add=TRUE, col="black")
axis(1, at=x.at)
axis(2, at=y.at)
box()
title(main="Maunga Whau Volcano \n col=gray(100:200/200)", font.main=4)

