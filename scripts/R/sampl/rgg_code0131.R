require(klaR)

data(iris)
library(som)
irissom <- som(iris[,1:4], xdim = 6, ydim = 14)
shardsplot(irissom, data.or = iris, vertices = FALSE)
opar <- par(xpd = NA)
legend(7.5, 6.1, col = rainbow(3), xjust = 0.5, yjust = 0,
    legend = levels(iris[, 5]), pch = 16, horiz = TRUE)
par(opar)    

