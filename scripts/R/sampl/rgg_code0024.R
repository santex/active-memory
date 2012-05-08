z <- 2 * volcano        # Exaggerate the relief
x <- 10 * (1:nrow(z))   # 10 meter spacing (S to N)
y <- 10 * (1:ncol(z))   # 10 meter spacing (E to W)
par(mar=rep(.5,4))
persp(x, y, z, theta = 120, phi = 15, scale = FALSE, axes = FALSE)

