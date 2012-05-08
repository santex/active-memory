require("plotrix")

set.seed(1001)
bvals <- matrix(rpois(12,20),nrow=3)
b <- barplot.symbol.default(bvals, rel.width=.5)
