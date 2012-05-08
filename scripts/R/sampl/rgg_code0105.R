require(hdrcde)

data(faithful)
faithful.cde <- cde.est(faithful$waiting,faithful$eruptions)
plot(faithful.cde,xlab="Waiting time",ylab="Duration time",plot.fn="hdr")

points(faithful$waiting,faithful$eruptions, pch="+", col="yellow")

