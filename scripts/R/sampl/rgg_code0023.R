x <- seq(-10, 10, length = 50)
y <- x
rotsinc <- function(x,y)
{
    sinc <- function(x) { y <- sin(x)/x ; y[is.na(y)] <- 1; y }
    10 * sinc( sqrt(x^2+y^2) )
}
sinc.exp <- expression(z == Sinc(sqrt(x^2 + y^2)))

z <- outer(x, y, rotsinc)

par(bg = "white",mfrow=c(1,2),mar=rep(1.5,4))
persp(x, y, z, theta = 30, phi = 30, expand = 0.5, col = "lightblue")
title(sub=".")## work around persp+plotmath bug
title(main = sinc.exp)

persp(x, y, z, theta = 30, phi = 30, expand = 0.5, col = "lightblue",
      ltheta = 120, shade = 0.75, ticktype = "detailed",
      xlab = "X", ylab = "Y", zlab = "Z")
title(sub=".")## work around persp+plotmath bug
title(main = sinc.exp)

