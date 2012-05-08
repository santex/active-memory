require(hexbin)
library(grid)
library(lattice)
 

hexbinpie <- function(x, y, kat, xbnds=range(x), ybnds=range(y),
   pal=terrain.colors(length(levels(as.factor(kat)))),
   hex="gray", circ=NA, cnt="black", ...) {
       
  hb  <- hexbin(x, y, xbnds=xbnds, ybnds=ybnds, IDs=TRUE, xbin = 20 )
  hbc <- hcell2xy(hb)
  rx  <- diff(hb@xbnds) / (2 * hb@xbins)
  ry  <- diff(hb@ybnds) / (2 * hb@xbins*hb@shape)
  hexC <-  hexcoords(dx=rx, dy=ry/sqrt(3), n=1)
  nl <- length(levels(as.factor(kat)))
  zbnds <- quantile(hb@count,prob=c(.05,.95), na.rm=TRUE )
  maxhb <- max(hb@count)
  zz <- pmax(pmin(sqrt(hb@count/zbnds[2]),1),0.2)
  tt <- unclass(table(kat,hb@cID))
  for (i in seq(along=zz)) {
    if (!is.na(hex)) polygon(hbc$x[i]+hexC$x, hbc$y[i]+hexC$y, col=NA,
border=hex)
    tp <- pi/2 - 2*pi*c(0,cumsum(tt[,i])/sum(tt[,i])) #torespontok
    for (j in 1:nl) {
      if (tp[j+1]==tp[j]) next
      pp <- seq(tp[j], tp[j+1],
         length=floor((tp[j]-tp[j+1])*4)+2) #polygon-pontok
      xi <- hbc$x[i]+c(0,zz[i]*rx*cos(pp))
      yi <- hbc$y[i]+c(0,zz[i]*ry*sin(pp))
      polygon(xi,yi, col=pal[j], border=NA,...)
      }
    if (!is.na(circ)) polygon(hbc$x[i]+rx*zz[i]*cos((1:18)*pi/9),
       hbc$y[i]+ry*zz[i]*sin((1:18)*pi/9), col=NA, border=circ)
    }
  for (i in seq(along=zz)) {
    if ((!is.na(cnt))&(hb@count[i]>zbnds[2]))
       text(hbc$x[i],hbc$y[i],hb@count[i],col=cnt,cex=.5)
    }
  }




set.seed(c(-40,-40))
x <- rnorm(9999)
y <- rnorm(9999)
bin <- hexbin(x, y)
n <- 9999
dd <- data.frame(y  = rep(factor(1:3),n/3),
                 x1 = rnorm(n)+sin((0:2)*1*pi/3),
                 x2 = rnorm(n)+cos((0:2)*1*pi/3))

## Using plot method for hexbin objects:
plot(dd[,-1], type="n", main="active::memory (DATA-CANS-WEIGHTED)", xlab="x1", ylab="x2")
hexbinpie(dd$x1, dd$x2, kat=dd$y,
          hex = "gray", circ = "gray50",
          pal = c("red","green","blue")) 

#plotMesh.grid(dd$x1, dd$x2, dd, dist = 0) 

plot(dd[,-1], main="SHIT-STORM");#, style = "nested.lattice")
plot(dd, style = "nested.lattice", main="SHIT-STORM-MENU")

