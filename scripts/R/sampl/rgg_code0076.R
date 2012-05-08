require(plotrix)

#data(soils)
soil.texture()


require(plotrix)

a <- c(10,20,45)                      
b <- c(2,55,8)                         
c <- c(10,35,16)     

library("geneplotter")  ## from BioConductor
require("RColorBrewer") ## from CRAN

  x1  <- matrix(a, ncol=3)
  x2  <- matrix(b, ncol=3)
  x3  <- matrix(c, ncol=3)
  
#  rnorm(b, mean=3, sd=1.5)
  x   <- rbind(rnorm(x1, mean=3, sd=1.5),
  rnorm(x2, mean=3, sd=1.5),
  rnorm(x3, mean=3, sd=1.5))
  
  
  
main.title<-"SOIL TEXTURE PLOT"
soil.texture(x1,
             main=main.title,
             show.lines=TRUE,
             pch=3)

