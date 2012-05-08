data(iris3)
Iris <- data.frame(rbind(iris3[,,1], iris3[,,2], iris3[,,3]),
                   Sp = rep(c("s","c","v"), rep(50,3)))
z <- lda(Sp ~ ., Iris, prior = c(1,1,1)/3)

plot(z, dimen=1, type="both", cex=1.2)

