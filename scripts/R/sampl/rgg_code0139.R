library("geneplotter")  ## from BioConductor
require("RColorBrewer") ## from CRAN

  x1  <- matrix(rnorm(1e4), ncol=2)
  x2  <- matrix(rnorm(1e4, mean=3, sd=1.5), ncol=2)
  x   <- rbind(x1,x2)

  layout(matrix(1:4, ncol=2, byrow=TRUE))
  op <- par(mar=rep(2,4))
  smoothScatter(x, nrpoints=0)
  smoothScatter(x)
  smoothScatter(x, nrpoints=Inf,
                colramp=colorRampPalette(brewer.pal(9,"YlOrRd")),
                bandwidth=40)
  colors  <- densCols(x)
  plot(x, col=colors, pch=20)

par(op)