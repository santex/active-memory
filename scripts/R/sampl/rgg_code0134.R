  library(ncdf)
  teapot<-open.ncdf("teapot.nc")
  # file at http://www.maplepark.com/~drf5n/extras/teapot.nc
  edges<-get.var.ncdf(teapot,"tris")
  vertices<-get.var.ncdf(teapot,"locations")


plotMesh<-function(vertices,edges,col,rot.mat=diag(4),dist=0.1,...){
  ## rot.mat a 4x4 homogeneous transformation matrix
  ## dist: controls perpective per lattice::ltransform3dto3d

  # rotate
  vertices<-ltransform3dto3d(vertices,rot.mat,dist)
    xscale <- range(vertices[1,])
    yscale <- range(vertices[2,])
    plot(xscale, yscale, type = "n")

  # find plot order

  ord<-order(apply(edges,2,function(x){sum(vertices[3,x])}))

  if (length(col) == 1){
    sapply(ord,function(x){
      polygon(vertices[1,edges[,x]],vertices[2,edges[,x]],col=col,...)})
  } else {
    sapply(ord,function(x){
      polygon(vertices[1,edges[,x]],vertices[2,edges[,x]],col=col[x],...)})
  }

  invisible(ord)
 }

   grey.colors<-function(n,start=0,end=1){
     if(length(n)>1) n=length(n)
     gray(seq(start,end,len=n))}

 library(lattice)
 rot.mat <- ltransform3dMatrix(list(z=45,y=30)) #;rot.mat
 plotMesh(vertices,edges,rot.mat=rot.mat,col=grey.colors(dim(edges)[2]),lty=0)
