require(class)

data(crabs, package = "MASS")

lcrabs <- log(crabs[, 4:8])
crabs.grp <- factor(c("B", "b", "O", "o")[rep(1:4, rep(50,4))])
gr <- somgrid(topo = "triangular")
crabs.som <- batchSOM(lcrabs, gr, c(4, 4, 2))
plot(crabs.som)

