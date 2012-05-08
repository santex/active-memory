  data(iris3)
     ir <- rbind(iris3[,,1], iris3[,,2], iris3[,,3])
     parcoord(log(ir)[, c(3, 4, 2, 1)], col = 1 + (0:149)%/%50)

