z <- 2 * volcano        # Exaggerate the relief
x <- 10 * (1:nrow(z))   # 10 meter spacing (S to N)
y <- 10 * (1:ncol(z))   # 10 meter spacing (E to W)

z0 <- min(z) - 20
z <- rbind(z0, cbind(z0, z, z0), z0)
x <- c(min(x) - 1e-10, x, max(x) + 1e-10)
y <- c(min(y) - 1e-10, y, max(y) + 1e-10)

fill <- matrix("green3", nr = nrow(z)-1, nc = ncol(z)-1)
fill[ , i2 <- c(1,ncol(fill))] <- "gray"
fill[i1 <- c(1,nrow(fill)) , ] <- "gray"

fcol <- fill
zi <- volcano[ -1,-1] + volcano[ -1,-61] +
           volcano[-87,-1] + volcano[-87,-61]  ## / 4
fcol[-i1,-i2] <-
    terrain.colors(20)[cut(zi, quantile(zi, seq(0,1, len = 21)),
                           include.lowest = TRUE)]
par(mar=rep(.5,4))
persp(x, y, 2*z, theta = 110, phi = 40, col = fcol, scale = FALSE,
      ltheta = -120, shade = 0.4, border = NA, box = FALSE)

