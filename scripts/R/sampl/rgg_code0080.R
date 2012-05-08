# Source code from 
# http://fawn.unibw-hamburg.de/cgi-bin/Rwiki.pl?QuiverPlot

 quiver<- function(u,v,scale=1,length=0.05)
 # first stab at matlab's quiver in R
 # from http://tolstoy.newcastle.edu.au/R/help/01c/2711.html
 # Robin Hankin Tue 20 Nov 2001 - 13:10:28 EST
  {
    xpos <- col(u)
    ypos <- max(row(u))-row(u)

    speed <- sqrt(u*u+v*v)
    maxspeed <- max(speed)

    u <- u*scale/maxspeed
    v <- v*scale/maxspeed

    matplot(xpos,ypos,type="p",cex=0)
    arrows(xpos,ypos,xpos+u,ypos+v,length=length*min(par.uin()))
  }

 par.uin <- function()
  # determine scale of inches/userunits in x and y
  # from http://tolstoy.newcastle.edu.au/R/help/01c/2714.html
  # Brian Ripley Tue 20 Nov 2001 - 20:13:52 EST
 {
    u <- par("usr")
    p <- par("pin")
    c(p[1]/(u[2] - u[1]), p[2]/(u[4] - u[3]))
 }

 set.seed(1)
 u <- matrix(rnorm(100),nrow=10)
 v <- matrix(rnorm(100),nrow=10)
 quiver(u,v)

