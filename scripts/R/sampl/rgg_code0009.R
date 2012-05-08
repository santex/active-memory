par(bg="cornsilk")
set.seed(432)
x <- rnorm(1000)
hist(x, xlim=range(-4, 4, x), col="lavender", main="")
title(main="1000 Normal Random Variates", font.main=3)

