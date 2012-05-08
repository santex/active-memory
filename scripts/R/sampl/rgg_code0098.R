require(A2R)

########################## from stats::hclust help
hc <- hclust(dist(USArrests)^2, "cen")
memb <- cutree(hc, k = 10)
cent <- NULL
for(k in 1:10){
  cent <- rbind(cent, colMeans(USArrests[memb == k, , drop = FALSE]))
}
hc1 <- hclust(dist(cent)^2, method = "cen", members = table(memb))
##########################

hc1$labels <- sprintf('g %02d',1:10)

A2Rplot(hc1, 
        members = table(memb), 
        k=4, 
        lwd.up   =  2, lty.up=1, col.up = "gray",
        lwd.down =  1, lty.down='twodash', 
        col.down = c("orange", "brown", "green3", "royalblue"),
        knot.pos = "bary"
        )

