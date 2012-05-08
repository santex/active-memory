require(fpc)

require(A2R)
# get that package from 
# http://addictedtor.free.fr/packages


d.usa <- dist(USArrests, "euc")
h.usa <- hclust(d.usa, method="ward")

set.seed(1)
some.factor <- letters[1:4][rbinom(50, prob=0.5, size=3)+1]

hubertgamma <- rep(0,10)
for(i in 1:10){
  hubertgamma[i] <- cluster.stats(d.usa, 
                                  cutree(h.usa, k=i+1),
                                  G2 = FALSE,
                                  G3 = FALSE,
                                  silhouette = FALSE)$hubertgamma
}

A2Rplot(h.usa, 
        k=3, 
        fact.sup=some.factor, 
        criteria=hubertgamma,
        boxes = FALSE,
        col.up = "gray",
        col.down = c("orange","royalblue","green3"))


