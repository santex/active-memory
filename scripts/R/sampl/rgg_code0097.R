require(CircStats)

set.seed(543)
unif.data <- runif(50, 0, 2*pi)
rose.diag(unif.data, bins = 18, main = 'Stacked Points', pts=TRUE)

