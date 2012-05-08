library(hexbin)

x <- rnorm(10000)
y <- rnorm(10000)

bin <- hexbin(x,y)
erodebin <- erode(smooth.hexbin(bin))

hboxplot(erodebin, density = c(32,7), border = c(2,4))

