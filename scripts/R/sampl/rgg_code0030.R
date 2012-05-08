require("RColorBrewer")

palette(brewer.pal(7,"Accent")[-4])
x <- c(-0.475,-1.553,-0.434,-1.019,0.395)
d1 <- density(x,bw=.3,from=-3,to=3)
par(mar=c(3, 2, 2, 3) + 0.1,las=1)
plot(d1,ylim=c(-.3,.6),xlim=c(-2.5,1),axes=F,ylab="",xlab="",main="")
axis(1)
axis(4,0:3*.2)
abline(h=-.3,col="gray")
#rug(x)
mat <- matrix(0,nc=512,nr=5)
for(i in 1:5){
	d <- density(x[i],bw=.3,from=-3,to=3)
	lines(d$x,(d$y)/5-.3,col=i+1)
	mat[i,] <- d$y/5
}
for(i in 2:5) mat[i,] <- mat[i,] + mat[i-1,]
usr <- par("usr")
mat <- rbind(0,mat)
#segments(x0=rep(usr[1],5),x1=rep(d$x[171],5),y0=mat[,171],y1=mat[,171],lty=3)
for(i in 2:6) polygon(c(d$x,rev(d$x)),c(mat[i,],rev(mat[i-1,])),col=i,border=NA)
#segments(x0=d$x[171],x1=d$x[171],y0=0,y1=d1$y[171],lwd=3,col="white")
lines(d1,lwd=2)

box()
#palette("default")


