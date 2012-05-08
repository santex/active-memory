require(plotrix)

testlen <- c(sin(seq(0,1.98*pi,length=100))+2+rnorm(100)/10)
testpos <- seq(0,1.98*pi,length=100)

radial.plot(testlen,testpos,rp.type="p",main="Test Polygon",line.col="blue")
