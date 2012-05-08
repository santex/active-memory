   for( i in 1:36 ) system( sprintf("convert png/graph_%d.png
jpg/g_%d.jpg",i,i) )




require( rgl )      # for 3 d graphics
require( rimage )   # to import jpeg files

images <- lapply( floor( runif( 6, min = 1, max = 36) ), function( x ){

  graph <- read.jpeg( sprintf("./jpg/g_%d.jpg" ,x) )
  imdim <- dim(graph)[1:2]
  mindim <- min( imdim )
  graph <- switch( attr( graph, "type"),
  "grey" = {
    # extract a square portion of the graphic
    g <- imagematrix( graph[
      floor( (imdim[1] - mindim)/2)  + 1:mindim ,
      floor( (imdim[2] - mindim)/2)  + 1:mindim ] )
    g[c(1, mindim-1),] <- 0    # these two lines are to setup the borders
    g[,c(1, mindim-1)] <- 0    # of the graphics as black lines
    g
    },
  "rgb" = {
    g <-imagematrix( graph[
      floor( (imdim[1] - mindim)/2)  + 1:mindim ,
      floor( (imdim[2] - mindim)/2)  + 1:mindim , ] )
    g[c(1, mindim-1),,] <- 0   # similar.
    g[,c(1, mindim-1),] <- 0
    g
    }
     )
} )
#3
## setup an empty 3d scene
plot3d( 0,0,0, xlim= c(0,1), ylim = c(0,1), zlim = c(0,1), axes = FALSE,xlab = "", ylab = "", zlab = "", type = "n", box = FALSE)

coords <- rbind(  c(0 , 2, 3),  c(1 , 3, 2),  c(3, 0 , 2),  c(2, 1 , 3),  c(2, 3, 0 ),  c(3, 2, 1 )  )
.f <- function(co, d){
  if( co == 1 | co == 0 ) rep( co, d*d ) else
  if( co == 2 ) rep(seq(1,0,length=d), each = d) else
  if( co == 3 )  rep(seq(1,0,length=d), d)
}
for( idx in 1:6 ){
  co <- coords[idx,]
  x  <- images[[idx]]
  # find out which colors to use for each pixel of the graph
  cols <- switch( attr(x, "type"), "grey" = grey(x), "rgb"  = rgb(x[, , 1], x[, , 2], x[, , 3]) )
  d <- dim(x)[1]

  # draw the actual graph on one of the faces of the cube
  points3d( x = .f(co[1], d), y = .f(co[2], d), z = .f(co[3], d),
    col = cols, size = 4 )
}

## cosmetic
rgl.bg(sphere=TRUE, color=c("black","orange"), lit=FALSE, back="lines" )
