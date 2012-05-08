require(lattice)

x <- seq(-pi, pi, len = 20)
y <- seq(-pi, pi, len = 20)
g <- expand.grid(x = x, y = y)
g$z <- sin(sqrt(g$x^2 + g$y^2))
print(wireframe(z ~ x * y, g, drape = TRUE,
                aspect = c(3,1), colorkey = TRUE))
