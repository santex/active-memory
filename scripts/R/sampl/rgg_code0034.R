require("ade4")

data (euro123)

opar <- par(mfrow = c(2,2))
#     triangle.plot(euro123$in78, clab = 0, cpoi = 2, addmean = TRUE, show = FALSE)
     triangle.plot(euro123$in86, label = row.names(euro123$in78), clab = 0.8)
     triangle.biplot(euro123$in78, euro123$in86)
     triangle.plot(rbind.data.frame(euro123$in2005, euro123$in2010), clab = 1,  addaxes = TRUE, sub = "Principal axis", csub = 2, possub = "topright")
par(opar)

