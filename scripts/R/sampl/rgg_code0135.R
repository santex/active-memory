 library(grid)
 library(lattice)
 
 plotMesh.grid<-function(l, z, rot.mat=diag(rep(1,1)), dist = 0.1)
    ## rot.mat: 4x4 
    ## dist: controls perspective, 0 = none
 {
    x <- ltransform3dto3d(l[,z], rot.mat, dist = dist)
    id <- seq(length = ncol(x) / 3)
    ord <- order(x[3, id * 3] + x[3, id * 3 - 1] +
                 x[3, id * 3 - 2])
    grid.newpage()
    xscale <- range(x[1,])
    yscale <- range(x[2,])
    md <- max(diff(xscale), diff(yscale))
    pushViewport(viewport(w = 0.9 * diff(xscale) / md,
                          h = 0.9 * diff(yscale) / md,
                          xscale = xscale,
                         yscale = yscale))
    id <-as.vector(outer(1:3, (id[ord]-1) * 3, "+"))
    grid.polygon(x = x[1,id],
                 y = x[2,id],
                 default.units = "native",
                 gp = gpar(fill = "gray"),
                 id = rep(id[ord], each = 3))
 }



rot.mat <- ltransform3dMatrix(list(y = -30, x = 40))

library(ncdf)
teapot<-open.ncdf("teapot.nc")
z<-get.var.ncdf(teapot,"tris")
l<-get.var.ncdf(teapot,"locations")
plotMesh.grid(l, z, rot.mat, dist = 0) 

