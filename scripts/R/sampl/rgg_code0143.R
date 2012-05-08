 library(grid)
 library(lattice)
 require(hexbin)


 plotMesh.grid<-function(x, y, kat, xbnds=range(x), ybnds=range(y), dist = 1)
    ## rot.mat: 4x4 transformation matrix
    ## dist: controls perspective, 0 = none
 {

    grid.newpage()
    xscale <- range(x[1,])
    yscale <- range(x[2,])
    md <- max(diff(xscale), diff(yscale))
    pushViewport(viewport(w = 0.9 * diff(xscale) / md,
                          h = 0.9 * diff(yscale) / md,
                          xscale = xscale,
                         yscale = yscale))
    id <-
        as.vector(outer(1:3, (id[ord]-1) * 3, "+"))
    grid.polygon(x = x[1,id],
                 y = x[2,id],
                 default.units = "native",
                 gp = gpar(fill = "gray"),
                 id = rep(id[ord], each = 3))
 }



n <- 9999
dd <- data.frame(y  = rep(factor(1:3),n/3),
                 x1 = rnorm(n)+sin((0:2)*1*pi/3),
                 x2 = rnorm(n)+cos((0:2)*1*pi/3))

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
rot.mat <- ltransform3dMatrix(list(y = 3, x = 3))

plot(dd[,-1], type="n", main="DATA-CANS-WEIGHTED", xlab="x1", ylab="x2")
hexbinpie(dd$x1, dd$x2, kat=dd$y,
          hex = "gray", circ = "gray50",
          pal = c("red","green","blue"))

plot(rot.mat[,-1])

