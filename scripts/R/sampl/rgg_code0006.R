par(bg="cornsilk")
n <- 10
g <- gl(n, 100, n*100)
x <- rnorm(n*100) + sqrt(as.numeric(g))
boxplot(split(x,g), col="lavender", notch=TRUE)
title(main="Notched Boxplots", xlab="Group", font.main=4, font.lab=1)

