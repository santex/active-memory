x <- 1:10
y <- sort(10*runif(10))
z <- runif(10)
symbols(x, y, thermometers=cbind(.5, 1, z), inches=.5, fg = 1:10)

