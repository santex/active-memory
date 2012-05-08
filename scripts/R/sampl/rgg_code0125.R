
a <- c(10,20,45)                      
b <- c(2,5,8)                         
c <- c(-10,35,16)     

library("geneplotter")  ## from BioConductor
require("RColorBrewer") ## from CRAN

  x1  <- matrix(a, ncol=3)
  x2  <- matrix(b, ncol=3)
  x3  <- matrix(c, ncol=3)
  
#  rnorm(b, mean=3, sd=1.5)
  x   <- rbind(rnorm(x1, mean=3, sd=1.5),
  rnorm(x2, mean=3, sd=1.5),
  rnorm(x3, mean=3, sd=1.5))

  layout(matrix(1:4, ncol=2))

op <- par(mar=rep(2,4))
smoothScatter(x, nrpoints=10)
smoothScatter(x)
smoothScatter(x, nrpoints=Inf,
              colramp=colorRampPalette(brewer.pal(9,"YlOrRd")),
              bandwidth=40)
 colors  <- densCols(x)
  plot(x, col=colors, pch=20#)
par(op)
