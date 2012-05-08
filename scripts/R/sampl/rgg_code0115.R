require(rmeta)

op <- par(lend='square', no.readonly=TRUE)

data(catheter)
a <- meta.MH(n.trt, n.ctrl, col.trt, col.ctrl, data=catheter,
             names=Name, subset=c(13,6,5,3,7,12,4,11,1,8,10,2))
funnelplot(a$logOR, a$selogOR,
           plot.conf=TRUE, summ=a$logMH, mirror=TRUE)
           
par(op)
