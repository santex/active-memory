   par.uin <- function()
  # determine scale of inches/userunits in x and y
  # from http://tolstoy.newcastle.edu.au/R/help/01c/2714.html
  # Brian Ripley Tue 20 Nov 2001 - 20:13:52 EST
 {
    u <- par("usr")
    p <- par("pin")
    c(p[1]/(u[2] - u[1]), p[2]/(u[4] - u[3]))
 }

 quiver2 <- function(expr, 
                     x, 
                     y, 
                     nlevels=20, 
                     length=0.05, 
                     ...){

    z <- expand.grid(x,y)
    xx  <- x 
    x   <- z[,1]
    yy  <- y 
    y   <- z[,2]
    
    fxy <- eval(expr)
    grad_x <- eval(D(expr, "x"))
    grad_y <- eval(D(expr, "y"))
  
  dim(fxy) <- c(length(xx), length(yy))
  dim(grad_x) <- dim(fxy)
  dim(grad_y) <- dim(fxy)
  
  maxlen <- min(diff(xx), diff(yy)) * .9
  grad_x <- grad_x / max(grad_x) * maxlen
  grad_y <- grad_y / max(grad_y) * maxlen
  
  filled.contour(xx, yy, fxy, nlevels=nlevels,
    plot.axes = {
      contour(xx, yy, fxy, add=T, col="gray", 
              nlevels=nlevels, drawlabels=FALSE)
      
      arrows(x0  = x, 
             x1  = x + grad_x,
             y0  = y, 
             y1  = y + grad_y, 
             length = length*min(par.uin()))
      
      axis(1)
      axis(2)
    }, 
    ...)
}

f <- expression( (3*x^2 + y) * exp(-x^2-y^2))

x <- y <- seq(-2, 2, by=.2)
par(mar=c(3,3,3,3))
quiver2(f,x,y, color.palette=terrain.colors)

