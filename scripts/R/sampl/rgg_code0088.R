x<-seq(-10,10,length=400)
y1<-dnorm(x)
y2<-dnorm(x,m=3)
par(mar=c(5,4,2,1))
plot(x, y2, xlim=c(-3,8), type="n", xlab=quote(Z==frac(mu[1]-mu[2],
                 sigma/sqrt(n))), ylab="Density")
polygon(c(1.96,1.96,x[240:400],10), c(0,dnorm(1.96,m=3),y2[240:400],0),
                 col="grey80", lty=0)
lines(x, y2)
lines(x, y1)
polygon(c(-1.96,-1.96,x[161:1],-10), c(0,dnorm(-1.96,m=0), y1[161:1],0),
                 col="grey30", lty=0)
polygon(c(1.96, 1.96, x[240:400], 10), c(0,dnorm(1.96,m=0),
                 y1[240:400],0), col="grey30")
legend(4.2, .4, fill=c("grey80","grey30"),
              legend=expression(P(abs(Z)>1.96, H[1])==0.85,
              P(abs(Z)>1.96,H[0])==0.05), bty="n")
text(0, .2, quote(H[0]:~~mu[1]==mu[2]))
text(3, .2, quote(H[1]:~~mu[1]==mu[2]+delta))
