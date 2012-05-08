qqnorm(precip, ylab = "Precipitation [in/yr] for 70 US cities", pch="+")
qqline(precip)
points( qnorm(c(.25,.75)), 
  quantile(precip, c(.25, .75)) , 
  pch=16, col=2, cex=2)

