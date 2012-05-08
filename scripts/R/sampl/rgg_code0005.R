pie.sales <- c(0.12, 0.3, 0.26, 0.16, 0.04, 0.12)
names(pie.sales) <- c("Blueberry", "Cherry","Apple", "Boston Cream", "Other", "Vanilla Cream")
pie(pie.sales,col=c("purple","violetred1","green3","cornsilk","cyan","white"))
title(main="January Pie Sales", cex.main=1.8, font.main=1)
title(xlab="(Don't try this at home kids)", cex.lab=0.8, font.lab=3)

