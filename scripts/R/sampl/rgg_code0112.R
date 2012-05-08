require(rpart)


####################################"
# the source code for the function
# from 
#
# http://www.wiwi.uni-bielefeld.de/~wolf/software/R-wtools/bagplot/bagplot.R
#
####################################
##start:##
compute.bagplot<-function(x,y,
   factor=3, # expanding factor for bag to get the loop
   approx.limit=300, # limit 
   dkmethod=2, # in 1:2; there are two methods for approximating the bag
   precision=1, # controls precisionn of computation
   verbose=FALSE,debug.plots="no" # tools for debugging
){
  
  #pwolf 050921
  
# define some functions
win<-function(dx,dy){  atan2(y=dy,x=dx) }
out.of.polygon<-function(xy,pg){
  if(nrow(pg)==1) return(pg) 
  pgcenter<-apply(pg,2,mean)
  pg<-cbind(pg[,1]-pgcenter[1],pg[,2]-pgcenter[2])
  xy<-cbind(xy[,1]-pgcenter[1],xy[,2]-pgcenter[2])
  extr<-rep(FALSE,nrow(xy))
  for(i in seq(nrow(xy))){
    alpha<-sort((win(xy[i,1]-pg[,1],xy[i,2]-pg[,2]))%%(2*pi))
    extr[i]<-pi<max(diff(alpha)) | 
             pi<(alpha[1]+2*pi-alpha[length(alpha)])
  }
  extr
}
cut.z.pg<-function(zx,zy,p1x,p1y,p2x,p2y){
  a2<-(p2y-p1y)/(p2x-p1x); a1<-zy/zx
  sx<-(p1y-a2*p1x)/(a1-a2); sy<-a1*sx
  sxy<-cbind(sx,sy)
  h<-any(is.nan(sxy))||any(is.na(sxy))||any(Inf==abs(sxy))
  if(h){
  if(!exists("verbose")) verbose<-FALSE
    if(verbose) cat("special")
    # points on line defined by line segment
    h<-0==(a1-a2) & sign(zx)==sign(p1x)
       sx<-ifelse(h,p1x,sx); sy<-ifelse(h,p1y,sy)
    h<-0==(a1-a2) & sign(zx)!=sign(p1x)
       sx<-ifelse(h,p2x,sx); sy<-ifelse(h,p2y,sy)
    # line segment vertical 
    #   & center NOT ON line segment
    h<-p1x==p2x & zx!=p1x & p1x!=0 
       sx<-ifelse(h,p1x,sx); sy<-ifelse(h,zy*p1x/zx,sy)
    #   & center ON line segment
    h<-p1x==p2x & zx!=p1x & p1x==0 
       sx<-ifelse(h,p1x,sx); sy<-ifelse(h,0,sy)
    #   & center ON line segment & point on line
    h<-p1x==p2x & zx==p1x & p1x==0 & sign(zy)==sign(p1y)
       sx<-ifelse(h,p1x,sx); sy<-ifelse(h,p1y,sy)
    h<-p1x==p2x & zx==p1x & p1x==0 & sign(zy)!=sign(p1y)
       sx<-ifelse(h,p1x,sx); sy<-ifelse(h,p2y,sy)
    #  points identical to end points of line segment
    h<-zx==p1x & zy==p1y; sx<-ifelse(h,p1x,sx); sy<-ifelse(h,p1y,sy)
    h<-zx==p2x & zy==p2y; sx<-ifelse(h,p2x,sx); sy<-ifelse(h,p2y,sy)
    # point of z is center
    h<-zx==0 & zy==0; sx<-ifelse(h,0,sx); sy<-ifelse(h,0,sy)
    sxy<-cbind(sx,sy)
  } # end of special cases
  #if(verbose){ print(rbind(a1,a2));print(cbind(zx,zy,p1x,p1y,p2x,p2y,sxy))}
  if(!exists("debug.plots")) debug.plots<-"no"
  if(debug.plots=="all"){
    segments(sxy[,1],sxy[,2],zx,zy,col="red") 
    segments(0,0,sxy[,1],sxy[,2],type="l",col="green",lty=2)
    points(sxy,col="red")
  }
  return(sxy)
} 
find.cut.z.pg<-function(z,pg,center=c(0,0),debug.plots="no"){
  if(!is.matrix(z)) z<-rbind(z)
  if(1==nrow(pg)) return(matrix(center,nrow(z),2,TRUE))
  n.pg<-nrow(pg); n.z<-nrow(z)
  # center z and pg
  z<-cbind(z[,1]-center[1],z[,2]-center[2])
  pgo<-pg; pg<-cbind(pg[,1]-center[1],pg[,2]-center[2])
  if(!exists("debug.plots")) debug.plots<-"no"
  if(debug.plots=="all"){plot(rbind(z,pg,0),bty="n"); points(z,pch="p")
           lines(c(pg[,1],pg[1,1]),c(pg[,2],pg[1,2]))}
  # find angles of pg und z
  apg<-win(pg[,1],pg[,2])
  apg[is.nan(apg)]<-0; a<-order(apg); apg<-apg[a]; pg<-pg[a,]
  az<-win(z[,1],z[,2])
  # find line segments
  segm.no<-apply((outer(apg,az,"<")),2,sum)
  segm.no<-ifelse(segm.no==0,n.pg,segm.no)
  next.no<-1+(segm.no %% length(apg))
  # compute cut points
  cuts<-cut.z.pg(z[,1],z[,2],pg[segm.no,1],pg[segm.no,2],
                             pg[next.no,1],pg[next.no,2])
  # rescale 
  cuts<-cbind(cuts[,1]+center[1],cuts[,2]+center[2])
  return(cuts)
}
hdepth.of.points<-function(tp,n){
  n.tp<-nrow(tp)
  tphdepth<-rep(0,n.tp); dpi<-2*pi-0.000001
  minusplus<-c(rep(-1,n),rep(1,n))
  for(j in 1:n.tp) {
    dx<-tp[j,1]-xy[,1]; dy<-tp[j,2]-xy[,2] 
    a<-win(dx,dy)+pi; h<-a<10;a<-a[h]; ident<-sum(!h)
    init<-sum(a < pi); a.shift<-(a+pi) %% dpi
    h<-cumsum(minusplus[order(c(a,a.shift))])
    tphdepth[j]<-init+min(h)+1
    # tphdepth[j]<-init+min(h)+ident; cat("SUMME",ident)
  }
  tphdepth
}
expand.hull<-function(pg,k){
  
resolution<-floor(20*precision)
pg0<-xy[hdepth==1,]
pg0<-pg0[chull(pg0[,1],pg0[,2]),]
end.points<-find.cut.z.pg(pg,pg0,center=center,debug.plots=debug.plots)
lam<-((0:resolution)^1)/resolution^1
  
pg.new<-pg
for(i in 1:nrow(pg)){
  tp<-cbind(pg[i,1]+lam*(end.points[i,1]-pg[i,1]),
            pg[i,2]+lam*(end.points[i,2]-pg[i,2]))
  hd.tp<-hdepth.of.points(tp,nrow(xy))
  ind<-max(sum(hd.tp>=k),1) 
  if(ind<length(hd.tp)){  # hd.tp[ind]>k && 
    tp<-cbind(tp[ind,1]+lam*(tp[ind+1,1]-tp[ind,1]),
              tp[ind,2]+lam*(tp[ind+1,2]-tp[ind,2]))
    hd.tp<-hdepth.of.points(tp,nrow(xy))
    ind<-max(sum(hd.tp>=k),1) 
  } 
  pg.new[i,]<-tp[ind,]
}
pg.new<-pg.new[chull(pg.new[,1],pg.new[,2]),]
# cat("depth pg.new", hdepth.of.points(pg.new,n))
  
pg.add<-0.5*(pg.new+rbind(pg.new[-1,],pg.new[1,]))
end.points<-find.cut.z.pg(pg,pg0,center=center)
for(i in 1:nrow(pg.add)){
  tp<-cbind(pg.add[i,1]+lam*(end.points[i,1]-pg.add[i,1]),
            pg.add[i,2]+lam*(end.points[i,2]-pg.add[i,2]))
  hd.tp<-hdepth.of.points(tp,nrow(xy))
  ind<-max(sum(hd.tp>=k),1) 
  if(ind<length(hd.tp)){ # hd.tp[ind]>k && 
    tp<-cbind(tp[ind,1]+lam*(tp[ind+1,1]-tp[ind,1]),
              tp[ind,2]+lam*(tp[ind+1,2]-tp[ind,2]))
    hd.tp<-hdepth.of.points(tp,nrow(xy))
    ind<-max(sum(hd.tp>=k),1) 
  } 
  pg.add[i,]<-tp[ind,]
}
# cat("depth pg.add", hdepth.of.points(pg.add,n))
  
pg.new<-rbind(pg.new,pg.add)
pg.new<-pg.new[chull(pg.new[,1],pg.new[,2]),]
}
cut.p.sl.p.sl<-function(xy1,m1,xy2,m2){
  sx<-(xy2[2]-m2*xy2[1]-xy1[2]+m1*xy1[1])/(m1-m2)
  sy<-xy1[2]-m1*xy1[1]+m1*sx
  if(!is.nan(sy)) return( c(sx,sy) )
  if(abs(m1)==Inf) return( c(xy1[1],xy2[2]+m2*(xy1[1]-xy2[1])) )
  if(abs(m2)==Inf) return( c(xy2[1],xy1[2]+m1*(xy2[1]-xy1[1])) )
}
pos.to.pg<-function(z,pg,reverse=FALSE){
  if(reverse){
    int.no<-apply(outer(pg[,1],z[,1],">="),2,sum)
    zy.on.pg<-pg[int.no,2]+pg[int.no,3]*(z[,1]-pg[int.no,1])
  }else{
    int.no<-apply(outer(pg[,1],z[,1],"<="),2,sum)
    zy.on.pg<-pg[int.no,2]+pg[int.no,3]*(z[,1]-pg[int.no,1])
  }
  ifelse(z[,2]<zy.on.pg, "lower","higher")
}
# check input
xydata<-if(missing(y)) x else cbind(x,y)
if(is.data.frame(xydata)) xydata<-as.matrix(xydata)
# select sample in case of large data set
very.large.data.set<-nrow(xydata)>approx.limit
if(!exists(".Random.seed")) set.seed(13)
save.seed<-.Random.seed
if(very.large.data.set){
  ind<-sample(seq(nrow(xydata)),size=approx.limit)
  xy<-xydata[ind,]
} else xy<-xydata
n<-nrow(xy)
points.in.bag<-floor(n/2)
# if jittering is needed 
# the following two lines can be activated
#xy<-xy+cbind(rnorm(n,0,.0001*sd(xy[,1])),
#             rnorm(n,0,.0001*sd(xy[,2])))
assign(".Random.seed",save.seed,env=.GlobalEnv)
if(verbose) cat("end of initialization")
  
prdata<-prcomp(xydata)
is.one.dim<-(min(prdata[[1]])/max(prdata[[1]]))<0.0001
if(is.one.dim){
 if(verbose) cat("data set one dimensional")
  center<-colMeans(xydata)
  res<-list(xy=xy,xydata=xydata,prdata=prdata,is.one.dim=is.one.dim,center=center)
  class(res)<-"bagplot"
 return(res)
} 
if(verbose) cat("data not linear")
  
dx<-(outer(xy[,1],xy[,1],"-"))
dy<-(outer(xy[,2],xy[,2],"-"))
alpha<-atan2(y=dy,x=dx); diag(alpha)<-1200 
for(j in 1:n) alpha[,j]<-sort(alpha[,j])
alpha<-alpha[-n,] ; m<-n-1
## quick look inside, just for check
if(debug.plots=="all"){
  plot(xy,bty="n"); xdelta<-abs(diff(range(xy[,1]))); dx<-xdelta*.3
  for(j in 1:n) {
    p<-xy[j,]; dy<-dx*tan(alpha[,j])
    segments(p[1]-dx,p[2]-dy,p[1]+dx,p[2]+dy,col=j)
    text(p[1]-xdelta*.02,p[2],j,col=j)
  }
}
if(verbose) print("end of computation of angles")
  
hdepth<-rep(0,n); dpi<-2*pi-0.000001
minusplus<-c(rep(-1,m),rep(1,m))
for(j in 1:n) {
  a<-alpha[,j]+pi; h<-a<10; a<-a[h]; init<-sum(a < pi) # hallo
  a.shift<-(a+pi) %% dpi
  h<-cumsum(minusplus[order(c(a,a.shift))])
  hdepth[j]<-init+min(h)+1 #  or do we have to count identical points?:
#  hdepth[j]<-init+min(h)+sum(xy[j,1]==xy[,1] & xy[j,2]==xy[,2])# hallo
}
if(verbose){print("end of computation of hdepth:"); print(hdepth)}
## quick look inside, just for a check
if(debug.plots=="all"){
  plot(xy,bty="n")
  xdelta<-abs(diff(range(xy[,1]))); dx<-xdelta*.1
  for(j in 1:n) {
    a<-alpha[,j]+pi; a<-a[a<10]; init<-sum(a < pi)
    a.shift<-(a+pi) %% dpi
    h<-cumsum(minusplus[ao<-(order(c(a,a.shift)))])
    no<-which((init+min(h)) == (init+h))[1]
    p<-xy[j,]; dy<-dx*tan(alpha[,j])
    segments(p[1]-dx,p[2]-dy,p[1]+dx,p[2]+dy,col=j,lty=3)
    dy<-dx*tan(c(sort(a),sort(a))[no])
    segments(p[1]-5*dx,p[2]-5*dy,p[1]+5*dx,p[2]+5*dy,col="black")
    text(p[1]-xdelta*.02,p[2],hdepth[j],col=1,cex=2.5)
  }
}
  
hd.table<-table(sort(hdepth))
d.k<-cbind(dk=rev(cumsum(rev(hd.table))),
           k =as.numeric(names(hd.table)))
k.1<-sum(points.in.bag<d.k[,1])
if(nrow(d.k)>1){
  k<-d.k[k.1+1,2] 
} else { 
  k<-d.k[k.1,2]
}
if(verbose){cat("counts of members of dk:"); print(hd.table)}
if(verbose){cat("end of computation of k, k=",k)}
  
center<-apply(xy[which(hdepth==max(hdepth)),,drop=FALSE],2,mean)
hull.center<-NULL
if(10<nrow(xy)&&length(hd.table)>2){
  n.p<-floor(c(32,16,8)[1+(n>50)+(n>200)]*precision)
  cands<-xy[rev(order(hdepth))[1:6],]
  cands<-cands[chull(cands[,1],cands[,2]),]; n.c<-nrow(cands)
  
  xyextr<-rbind(apply(cands,2,min),apply(cands,2,max))
  h1<-seq(xyextr[1,1],xyextr[2,1],length=n.p)
  h2<-seq(xyextr[1,2],xyextr[2,2],length=n.p)
  tp<-cbind(matrix(h1,n.p,n.p)[1:n.p^2],
            matrix(h2,n.p,n.p,TRUE)[1:n.p^2])
  tphdepth<-hdepth.of.points(tp,n)
  hull.center<-tp[which(tphdepth>=(max(tphdepth))),,drop=FALSE]
  center<-apply(hull.center,2,mean)
  cands<-hull.center[chull(hull.center[,1],hull.center[,2]),,drop=F]
  xyextr<-rbind(apply(cands,2,min),apply(cands,2,max))
  xydel<-(xyextr[2,]-xyextr[1,])/n.p
  xyextr<-rbind(xyextr[1,]-xydel,xyextr[2,]+xydel)
  h1<-seq(xyextr[1,1],xyextr[2,1],length=n.p)
  h2<-seq(xyextr[1,2],xyextr[2,2],length=n.p)
  tp<-cbind(matrix(h1,n.p,n.p)[1:n.p^2],
            matrix(h2,n.p,n.p,TRUE)[1:n.p^2])
  tphdepth<-hdepth.of.points(tp,n)
  hull.center<-tp[which(tphdepth>=max(tphdepth)),,drop=FALSE]
  center<-apply(hull.center,2,mean)
  hull.center<-hull.center[chull(hull.center[,1],hull.center[,2]),]
  if(verbose){cat("hull.center",hull.center); print(table(tphdepth)) }
}
if(verbose) cat("center depth:",hdepth.of.points(rbind(center),n))
if(verbose){print("end of computation of center"); print(center)}
# cat("HALLO"); print(hdepth.of.points(cbind(6.75,4.85),n))
  if(dkmethod==1){
    
# inner hull of bag
xyi<-xy[hdepth>=k,,drop=FALSE]
pdk<-xyi[chull(xyi[,1],xyi[,2]),,drop=FALSE]
# outer hull of bag
xyo<-xy[hdepth>=(k-1),,drop=FALSE]
pdk.1<-xyo[chull(xyo[,1],xyo[,2]),,drop=FALSE]
if(verbose)cat("hull computed:") 
#; if(verbose){print(pdk); print(pdk.1) }
if(debug.plots=="all"){
  plot(xy,bty="n")
  h<-rbind(pdk,pdk[1,]); lines(h,col="red",lty=2)
  h<-rbind(pdk.1,pdk.1[1,]);lines(h,col="blue",lty=3)
  points(center[1],center[2],pch=8,col="red")
}
exp.dk<-expand.hull(pdk,k)
exp.dk.1<-expand.hull(exp.dk,k-1) # pdk.1,k-1,20)
  }else{
    
# define direction for hdepth search
num<-floor(c(417,351,171,85,67,43)[sum(n>c(1,50,100,150,200,250))]*precision)
num.h<-floor(num/2); angles<-seq(0,pi,length=num.h)
ang<-tan(pi/2-angles)
# standardization of data set
xym<-apply(xy,2,mean); xysd<-apply(xy,2,sd)
xyxy<-cbind((xy[,1]-xym[1])/xysd[1],(xy[,2]-xym[2])/xysd[2])
kkk<-k          
ia<-1; a<-angles[ia]; xyt<-xyxy%*%c(cos(a),-sin(a)); xyto<-order(xyt)
# initial for upper part
ind.k <-xyto[kkk]; cutp<-c(xyxy[ind.k,1],-10)
dxy<-diff(range(xyxy))
pg<-rbind(c(cutp[1],-dxy,Inf),c(cutp[1],dxy,NA))
# initial for lower part
ind.kk<-xyto[n+1-kkk]; cutpl<-c(xyxy[ind.kk,1],10)
pgl<-rbind(c(cutpl[1],dxy,Inf),c(cutpl[1],-dxy,NA))
if(debug.plots=="all"){ plot(xyxy,type="p",bty="n") 
# text(xy,,1:n,col="blue")
# hx<-xy[ind.k,c(1,1)]; hy<-xy[ind.k,c(2,2)]
# segments(hx,hy,c(10,-10),hy+ang[ia]*(c(10,-10)-hx),lty=2)
# text(hx+rnorm(1,,.1),hy+rnorm(1,,.1),ia)
}  
for(ia in seq(angles)[-1]){ 
  
# determine critical points pnew and pnewl of direction a
### cat("ia",ia)
a<-angles[ia]; angtan<-ang[ia]; xyt<-xyxy%*%c(cos(a),-sin(a)); xyto<-order(xyt)
ind.k <-xyto[kkk]; ind.kk<-xyto[n+1-kkk]; pnew<-xyxy[ind.k,]; pnewl<-xyxy[ind.kk,] 
if(debug.plots=="all") points(pnew[1],pnew[2],col="red")
# new limiting lines are defined by pnew / pnewl and slope a
# find segment of polygon that is cut by new limiting line and cut
if(abs(angtan)>1e10){  ###  cat("y=c case")
    pg.no<-sum(pg[,1]<pnew[1]) 
    cutp<-c(pnew[1],pg[pg.no,2]+pg[pg.no,3]*(pnew[1]-pg[pg.no,1]))
    pg.nol<-sum(pgl[,1]>=pnewl[1])
    cutpl<-c(pnewl[1],pgl[pg.nol,2]+pgl[pg.nol,3]*(pnewl[1]-pgl[pg.nol,1]))
}else{    ### cat("normal case")
    pg.inter<-pg[,2]-angtan*pg[,1]; pnew.inter<-pnew[2]-angtan*pnew[1]
    pg.no<-sum(pg.inter<pnew.inter)
    cutp<-cut.p.sl.p.sl(pnew,ang[ia],pg[pg.no,1:2],pg[pg.no,3])
    pg.interl<-pgl[,2]-angtan*pgl[,1]; pnew.interl<-pnewl[2]-angtan*pnewl[1]
    pg.nol<-sum(pg.interl>pnew.interl)
    cutpl<-cut.p.sl.p.sl(pnewl,angtan,pgl[pg.nol,1:2],pgl[pg.nol,3])
}
# update pg, pgl
pg<-rbind(pg[1:pg.no,],c(cutp,angtan),c(cutp[1]+dxy, cutp[2]+angtan*dxy,NA))
pgl<-rbind(pgl[1:pg.nol,],c(cutpl,angtan),c(cutpl[1]-dxy, cutpl[2]-angtan*dxy,NA))
#########################################
#### cat("angtan",angtan,"pg.no",pg.no,"pkt:",pnew)
# if(ia==stopp) lines(pg,type="b",col="green") 
if(debug.plots=="all"){
  points(pnew[1],pnew[2],col="red") 
  hx<-xyxy[ind.k,c(1,1)]; hy<-xyxy[ind.k,c(2,2)]
  segments(hx,hy,c(10,-10),hy+ang[ia]*(c(10,-10)-hx),lty=2)
#  text(hx+rnorm(1,,.1),hy+rnorm(1,,.1),ia)
#print(pg) 
# if(ia==stopp) lines(pgl,type="b",col="green") 
  points(cutpl[1],cutpl[2],col="red") 
  hx<-xyxy[ind.kk,c(1,1)]; hy<-xyxy[ind.kk,c(2,2)]
  segments(hx,hy,c(10,-10),hy+ang[ia]*(c(10,-10)-hx),lty=2)
#  text(hx+rnorm(1,,.1),hy+rnorm(1,,.1),ia)
#print(pgl)
}
}
pg<-pg[-nrow(pg),][-1,,drop=F]; pgl<-pgl[-nrow(pgl),][-1,,drop=FALSE]
indl<-pos.to.pg(pgl,pg); indu<-pos.to.pg(pg,pgl,TRUE)
npg<-nrow(pg); npgl<-nrow(pgl)
rnuml<-rnumu<-lnuml<-lnumu<-0; sl<-pg[1,1:2]; sr<-pgl[1,1:2]
# right region
if(indl[1]=="higher"&indu[npg]=="lower"){ 
  rnuml<-which(indl=="lower")[1]-1; xyl<-pgl[rnuml,] #
  rnumu<-which(rev(indu=="higher"))[1]; xyu<-pg[npg+1-rnumu,] #
  sr<-cut.p.sl.p.sl(xyl[1:2],xyl[3],xyu[1:2],xyu[3])
}
# left region
if(indl[npgl]=="higher"&indu[1]=="lower"){ 
  lnuml<-which(rev(indl=="lower"))[1]; xyl<-pgl[npgl+1-lnuml,] #
  lnumu<-which(indu=="higher")[1]-1; xyu<-pg[lnumu,] #?
  sl<-cut.p.sl.p.sl(xyl[1:2],xyl[3],xyu[1:2],xyu[3])
}
pgl<-pgl[(rnuml+1):(npgl-lnuml),1:2,drop=FALSE]
pg <-pg [(lnumu+1):(npg -rnumu),1:2,drop=FALSE]
pg<-rbind(pg,sr,pgl,sl)
pg<-pg[chull(pg[,1],pg[,2]),]
if(debug.plots=="all") lines(rbind(pg,pg[1,]),col="red")
exp.dk<-cbind(pg[,1]*xysd[1]+xym[1],pg[,2]*xysd[2]+xym[2])
if(kkk>1) kkk<-kkk-1
ia<-1; a<-angles[ia]; xyt<-xyxy%*%c(cos(a),-sin(a)); xyto<-order(xyt)
# initial for upper part
ind.k <-xyto[kkk]; cutp<-c(xyxy[ind.k,1],-10)
dxy<-diff(range(xyxy))
pg<-rbind(c(cutp[1],-dxy,Inf),c(cutp[1],dxy,NA))
# initial for lower part
ind.kk<-xyto[n+1-kkk]; cutpl<-c(xyxy[ind.kk,1],10)
pgl<-rbind(c(cutpl[1],dxy,Inf),c(cutpl[1],-dxy,NA))
if(debug.plots=="all"){ plot(xyxy,type="p",bty="n") 
# text(xy,,1:n,col="blue")
# hx<-xy[ind.k,c(1,1)]; hy<-xy[ind.k,c(2,2)]
# segments(hx,hy,c(10,-10),hy+ang[ia]*(c(10,-10)-hx),lty=2)
# text(hx+rnorm(1,,.1),hy+rnorm(1,,.1),ia)
}  
for(ia in seq(angles)[-1]){ 
  
# determine critical points pnew and pnewl of direction a
### cat("ia",ia)
a<-angles[ia]; angtan<-ang[ia]; xyt<-xyxy%*%c(cos(a),-sin(a)); xyto<-order(xyt)
ind.k <-xyto[kkk]; ind.kk<-xyto[n+1-kkk]; pnew<-xyxy[ind.k,]; pnewl<-xyxy[ind.kk,] 
if(debug.plots=="all") points(pnew[1],pnew[2],col="red")
# new limiting lines are defined by pnew / pnewl and slope a
# find segment of polygon that is cut by new limiting line and cut
if(abs(angtan)>1e10){  ###  cat("y=c case")
    pg.no<-sum(pg[,1]<pnew[1]) 
    cutp<-c(pnew[1],pg[pg.no,2]+pg[pg.no,3]*(pnew[1]-pg[pg.no,1]))
    pg.nol<-sum(pgl[,1]>=pnewl[1])
    cutpl<-c(pnewl[1],pgl[pg.nol,2]+pgl[pg.nol,3]*(pnewl[1]-pgl[pg.nol,1]))
}else{    ### cat("normal case")
    pg.inter<-pg[,2]-angtan*pg[,1]; pnew.inter<-pnew[2]-angtan*pnew[1]
    pg.no<-sum(pg.inter<pnew.inter)
    cutp<-cut.p.sl.p.sl(pnew,ang[ia],pg[pg.no,1:2],pg[pg.no,3])
    pg.interl<-pgl[,2]-angtan*pgl[,1]; pnew.interl<-pnewl[2]-angtan*pnewl[1]
    pg.nol<-sum(pg.interl>pnew.interl)
    cutpl<-cut.p.sl.p.sl(pnewl,angtan,pgl[pg.nol,1:2],pgl[pg.nol,3])
}
# update pg, pgl
pg<-rbind(pg[1:pg.no,],c(cutp,angtan),c(cutp[1]+dxy, cutp[2]+angtan*dxy,NA))
pgl<-rbind(pgl[1:pg.nol,],c(cutpl,angtan),c(cutpl[1]-dxy, cutpl[2]-angtan*dxy,NA))
#########################################
#### cat("angtan",angtan,"pg.no",pg.no,"pkt:",pnew)
# if(ia==stopp) lines(pg,type="b",col="green") 
if(debug.plots=="all"){
  points(pnew[1],pnew[2],col="red") 
  hx<-xyxy[ind.k,c(1,1)]; hy<-xyxy[ind.k,c(2,2)]
  segments(hx,hy,c(10,-10),hy+ang[ia]*(c(10,-10)-hx),lty=2)
#  text(hx+rnorm(1,,.1),hy+rnorm(1,,.1),ia)
#print(pg) 
# if(ia==stopp) lines(pgl,type="b",col="green") 
  points(cutpl[1],cutpl[2],col="red") 
  hx<-xyxy[ind.kk,c(1,1)]; hy<-xyxy[ind.kk,c(2,2)]
  segments(hx,hy,c(10,-10),hy+ang[ia]*(c(10,-10)-hx),lty=2)
#  text(hx+rnorm(1,,.1),hy+rnorm(1,,.1),ia)
#print(pgl)
}
}
pg<-pg[-nrow(pg),][-1,,drop=F]; pgl<-pgl[-nrow(pgl),][-1,,drop=FALSE]
indl<-pos.to.pg(pgl,pg); indu<-pos.to.pg(pg,pgl,TRUE)
npg<-nrow(pg); npgl<-nrow(pgl)
rnuml<-rnumu<-lnuml<-lnumu<-0; sl<-pg[1,1:2]; sr<-pgl[1,1:2]
# right region
if(indl[1]=="higher"&indu[npg]=="lower"){ 
  rnuml<-which(indl=="lower")[1]-1; xyl<-pgl[rnuml,] #
  rnumu<-which(rev(indu=="higher"))[1]; xyu<-pg[npg+1-rnumu,] #
  sr<-cut.p.sl.p.sl(xyl[1:2],xyl[3],xyu[1:2],xyu[3])
}
# left region
if(indl[npgl]=="higher"&indu[1]=="lower"){ 
  lnuml<-which(rev(indl=="lower"))[1]; xyl<-pgl[npgl+1-lnuml,] #
  lnumu<-which(indu=="higher")[1]-1; xyu<-pg[lnumu,] #?
  sl<-cut.p.sl.p.sl(xyl[1:2],xyl[3],xyu[1:2],xyu[3])
}
pgl<-pgl[(rnuml+1):(npgl-lnuml),1:2,drop=FALSE]
pg <-pg [(lnumu+1):(npg -rnumu),1:2,drop=FALSE]
pg<-rbind(pg,sr,pgl,sl)
pg<-pg[chull(pg[,1],pg[,2]),]
if(debug.plots=="all") lines(rbind(pg,pg[1,]),col="red")
exp.dk.1<-cbind(pg[,1]*xysd[1]+xym[1],pg[,2]*xysd[2]+xym[2])
  }
  
lambda<-if(nrow(d.k)==1) 0.5 else
                         (n/2-d.k[k.1+1,1])/(d.k[k.1,1]-d.k[k.1+1,1]) 
if(verbose) cat("lambda",lambda)
  
cut.on.pdk.1<-find.cut.z.pg(exp.dk,  exp.dk.1,center=center)
cut.on.pdk  <-find.cut.z.pg(exp.dk.1,exp.dk,  center=center)
# expand inner polgon 
h1<-(1-lambda)*exp.dk+lambda*cut.on.pdk.1
# shrink outer polygon
h2<-(1-lambda)*cut.on.pdk+lambda*exp.dk.1
h<-rbind(h1,h2); hull.bag<-h[chull(h[,1],h[,2]),]
if(verbose)cat("bag completed:") #if(verbose)print(hull.bag) 
if(debug.plots=="all"){   lines(hull.bag,col="red") }
  
hull.loop<-cbind(hull.bag[,1]-center[1],hull.bag[,2]-center[2])
hull.loop<-factor*hull.loop
hull.loop<-cbind(hull.loop[,1]+center[1],hull.loop[,2]+center[2])
if(verbose) cat("loop computed")
  
if(!very.large.data.set){
  pxy.bag    <-xydata[hdepth>= k   ,,drop=FALSE]
  pkt.cand   <-xydata[hdepth==(k-1),,drop=FALSE]    
  pkt.not.bag<-xydata[hdepth< (k-1),,drop=FALSE]
  if(length(pkt.cand)>0){
    outside<-out.of.polygon(pkt.cand,hull.bag)
    if(sum(!outside)>0) 
      pxy.bag    <-rbind(pxy.bag,     pkt.cand[!outside,])
    if(sum( outside)>0) 
      pkt.not.bag<-rbind(pkt.not.bag, pkt.cand[ outside,])
  }
}else {
  extr<-out.of.polygon(xydata,hull.bag)
  pxy.bag    <-xydata[!extr,] 
  pkt.not.bag<-xydata[extr,,drop=FALSE]  
}
if(length(pkt.not.bag)>0){ 
  extr<-out.of.polygon(pkt.not.bag,hull.loop)
  pxy.outlier<-pkt.not.bag[extr,,drop=FALSE]
  if(0==length(pxy.outlier)) pxy.outlier<-NULL
  pxy.outer<-pkt.not.bag[!extr,,drop=FALSE]
}else{
  pxy.outer<-pxy.outlier<-NULL
}  
if(verbose) cat("points of bag, outer points and outlier identified")
  
hull.loop<-rbind(pxy.outer,hull.bag)
hull.loop<-hull.loop[chull(hull.loop[,1],hull.loop[,2]),]
if(verbose) cat("end of computation of loop")
  
assign(".Random.seed",save.seed,env=.GlobalEnv)
res<-list(
 center=center,
 pxy.bag=pxy.bag,
 pxy.outer=if(length(pxy.outer)>0) pxy.outer else NULL,
 pxy.outlier=if(length(pxy.outlier)>0) pxy.outlier else NULL,
 hull.center=hull.center,
 hull.bag=hull.bag,
 hull.loop=hull.loop,
 hdepths=hdepth,
 is.one.dim=is.one.dim,
 prdata=prdata,
 xy=xy,xydata=xydata
)
if(verbose) res<-c(res,list(exp.dk=exp.dk,exp.dk.1=exp.dk.1,hdepth=hdepth))
class(res)<-"bagplot"
return(res)
}
plot.bagplot<-function(bagplot.obj,
   show.outlier=TRUE,# if TRUE outlier are shown
   show.whiskers=TRUE, # if TRUE whiskers are shown
   show.looppoints=TRUE, # if TRUE points in loop are shown
   show.bagpoints=TRUE, # if TRUE points in bag are shown
   show.loophull=TRUE, # if TRUE loop is shown
   show.baghull=TRUE, # if TRUE bag is shown
   add=FALSE, # if TRUE graphical elements are added to actual plot
   pch=16,cex=.4,..., # to define further parameters of plot
   verbose=FALSE # tools for debugging
){
  
win<-function(dx,dy){  atan2(y=dy,x=dx) }
 
cut.z.pg<-function(zx,zy,p1x,p1y,p2x,p2y){
  a2<-(p2y-p1y)/(p2x-p1x); a1<-zy/zx
  sx<-(p1y-a2*p1x)/(a1-a2); sy<-a1*sx
  sxy<-cbind(sx,sy)
  h<-any(is.nan(sxy))||any(is.na(sxy))||any(Inf==abs(sxy))
  if(h){
  if(!exists("verbose")) verbose<-FALSE
    if(verbose) cat("special")
    # points on line defined by line segment
    h<-0==(a1-a2) & sign(zx)==sign(p1x)
       sx<-ifelse(h,p1x,sx); sy<-ifelse(h,p1y,sy)
    h<-0==(a1-a2) & sign(zx)!=sign(p1x)
       sx<-ifelse(h,p2x,sx); sy<-ifelse(h,p2y,sy)
    # line segment vertical 
    #   & center NOT ON line segment
    h<-p1x==p2x & zx!=p1x & p1x!=0 
       sx<-ifelse(h,p1x,sx); sy<-ifelse(h,zy*p1x/zx,sy)
    #   & center ON line segment
    h<-p1x==p2x & zx!=p1x & p1x==0 
       sx<-ifelse(h,p1x,sx); sy<-ifelse(h,0,sy)
    #   & center ON line segment & point on line
    h<-p1x==p2x & zx==p1x & p1x==0 & sign(zy)==sign(p1y)
       sx<-ifelse(h,p1x,sx); sy<-ifelse(h,p1y,sy)
    h<-p1x==p2x & zx==p1x & p1x==0 & sign(zy)!=sign(p1y)
       sx<-ifelse(h,p1x,sx); sy<-ifelse(h,p2y,sy)
    #  points identical to end points of line segment
    h<-zx==p1x & zy==p1y; sx<-ifelse(h,p1x,sx); sy<-ifelse(h,p1y,sy)
    h<-zx==p2x & zy==p2y; sx<-ifelse(h,p2x,sx); sy<-ifelse(h,p2y,sy)
    # point of z is center
    h<-zx==0 & zy==0; sx<-ifelse(h,0,sx); sy<-ifelse(h,0,sy)
    sxy<-cbind(sx,sy)
  } # end of special cases
  #if(verbose){ print(rbind(a1,a2));print(cbind(zx,zy,p1x,p1y,p2x,p2y,sxy))}
  if(!exists("debug.plots")) debug.plots<-"no"
  if(debug.plots=="all"){
    segments(sxy[,1],sxy[,2],zx,zy,col="red") 
    segments(0,0,sxy[,1],sxy[,2],type="l",col="green",lty=2)
    points(sxy,col="red")
  }
  return(sxy)
} 
 
find.cut.z.pg<-function(z,pg,center=c(0,0),debug.plots="no"){
  if(!is.matrix(z)) z<-rbind(z)
  if(1==nrow(pg)) return(matrix(center,nrow(z),2,TRUE))
  n.pg<-nrow(pg); n.z<-nrow(z)
  # center z and pg
  z<-cbind(z[,1]-center[1],z[,2]-center[2])
  pgo<-pg; pg<-cbind(pg[,1]-center[1],pg[,2]-center[2])
  if(!exists("debug.plots")) debug.plots<-"no"
  if(debug.plots=="all"){plot(rbind(z,pg,0),bty="n"); points(z,pch="p")
           lines(c(pg[,1],pg[1,1]),c(pg[,2],pg[1,2]))}
  # find angles of pg und z
  apg<-win(pg[,1],pg[,2])
  apg[is.nan(apg)]<-0; a<-order(apg); apg<-apg[a]; pg<-pg[a,]
  az<-win(z[,1],z[,2])
  # find line segments
  segm.no<-apply((outer(apg,az,"<")),2,sum)
  segm.no<-ifelse(segm.no==0,n.pg,segm.no)
  next.no<-1+(segm.no %% length(apg))
  # compute cut points
  cuts<-cut.z.pg(z[,1],z[,2],pg[segm.no,1],pg[segm.no,2],
                             pg[next.no,1],pg[next.no,2])
  # rescale 
  cuts<-cbind(cuts[,1]+center[1],cuts[,2]+center[2])
  return(cuts)
}
 for(i in seq(along=bagplot.obj)) 
    eval(parse(text=paste(names(bagplot.obj)[i],"<-bagplot.obj[[",i,"]]")))
 if(is.one.dim){
    
  if(verbose) cat("data set one dimensional")
  prdata<-prdata[[2]]; 
  trdata<-xydata%*%prdata; ytr<-mean(trdata[,2])
  boxplotres<-boxplot(trdata[,1],plot=FALSE)
  dy<-0.1*diff(range(stats<-boxplotres$stats))  
  dy<-0.05*mean(c(diff(range(xydata[,1])),
                  diff(range(xydata[,2]))))
  segtr<-rbind(cbind(stats[2:4],ytr-dy,stats[2:4],ytr+dy),
               cbind(stats[c(2,2)],ytr+c(dy,-dy),
                     stats[c(4,4)],ytr+c(dy,-dy)),
               cbind(stats[c(2,4)],ytr,stats[c(1,5)],ytr))
  segm<-cbind(segtr[,1:2]%*%t(prdata), 
              segtr[,3:4]%*%t(prdata)) 
  if(!add) plot(xydata,type="n",bty="n",pch=16,cex=.2,...) 
  extr<-c(min(segm[6,3],segm[7,3]),max(segm[6,3],segm[7,3]))
  extr<-extr+c(-1,1)*0.000001*diff(extr)
  xydata<-xydata[xydata[,1]<extr[1] | 
                 xydata[,1]>extr[2],,drop=FALSE]
  if(0<nrow(xydata))points(xydata[,1],xydata[,2],pch=pch,cex=cex)
  segments(segm[,1],segm[,2],segm[,3],segm[,4],)
  return("one dimensional boxplot plottet")
 } 
 
if(!add) plot(xydata,type="n",pch=pch,cex=cex,bty="n",...)
if(verbose) text(xy[,1],xy[,2],paste(as.character(hdepth)),cex=2)
# loop: ------------------------------------------------------
if(show.loophull){ # fill loop
    h<-rbind(hull.loop,hull.loop[1,]); lines(h[,1],h[,2],lty=1)
    polygon(hull.loop[,1],hull.loop[,2],col="#aaccff")
}
if(show.looppoints && length(pxy.outer)>0){ # points in loop
    points(pxy.outer[,1],pxy.outer[,2],col="#3355ff",pch=pch,cex=cex)
}
# bag: -------------------------------------------------------
if(show.baghull){ # fill bag
    h<-rbind(hull.bag,hull.bag[1,]); lines(h[,1],h[,2],lty=1)
    polygon(hull.bag[,1],hull.bag[,2],col="#7799ff")
}
if(show.bagpoints && length(pxy.bag)>0){ # points in bag 
    points(pxy.bag[,1],pxy.bag[,2],col="#000088",pch=pch,cex=cex)
}
# whiskers
if(show.whiskers && length(pxy.outer)>0){
    debug.plots<-"not"
    pkt.cut<-find.cut.z.pg(pxy.outer,hull.bag,center=center)
    segments(pxy.outer[,1],pxy.outer[,2],pkt.cut[,1],pkt.cut[,2],col="red")
}
# outlier: --------------------------------------------------
if(show.outlier && length(pxy.outlier)>0){ # points in loop 
      points(pxy.outlier[,1],pxy.outlier[,2],col="red",pch=pch,cex=cex)
}
# center:
if(exists("hull.center")&&length(hull.center)>2){
    h<-rbind(hull.center,hull.center[1,]); lines(h[,1],h[,2],lty=1)
    polygon(hull.center[,1],hull.center[,2],col="orange")
}
  points(center[1],center[2],pch=8,col="red")
if(verbose){
   h<-rbind(exp.dk,exp.dk[1,]); lines(h,col="blue",lty=2)
   h<-rbind(exp.dk.1,exp.dk.1[1,]); lines(h,col="black",lty=2)
   if(exists("tphdepth"))
      text(tp[,1],tp[,2],as.character(tphdepth),col="green")
   text(xy[,1],xy[,2],paste(as.character(hdepth)),cex=2)
   points(center[1],center[2],pch=8,col="red")
}
"bagplot plottet"
}
bagplot<-function(x,y,
   factor=3, # expanding factor for bag to get the loop
   approx.limit=300, # limit 
   show.outlier=TRUE,# if TRUE outlier are shown
   show.whiskers=TRUE, # if TRUE whiskers are shown
   show.looppoints=TRUE, # if TRUE points in loop are shown
   show.bagpoints=TRUE, # if TRUE points in bag are shown
   show.loophull=TRUE, # if TRUE loop is shown
   show.baghull=TRUE, # if TRUE bag is shown
   create.plot=TRUE, # if TRUE a plot is created 
   add=FALSE, # if TRUE graphical elements are added to actual plot
   pch=16,cex=.4,..., # to define further parameters of plot
   dkmethod=2, # in 1:2; there are two methods for approximating the bag
   precision=1, # controls precisionn of computation
   verbose=FALSE,debug.plots="" # tools for debugging
){
  bo<-compute.bagplot(x=x,y=y,factor=factor,approx.limit=approx.limit,
                      dkmethod=dkmethod,precision=precision,
                      verbose=verbose,debug.plots=debug.plots)
  if(create.plot){ 
    plot(bo,
     show.outlier=show.outlier,
     show.whiskers=show.whiskers,
     show.looppoints=show.looppoints,
     show.bagpoints=show.bagpoints,
     show.loophull=show.loophull,
     show.baghull=show.baghull,
     add=add,pch=pch,cex=cex,...,
     verbose=verbose
    )
  }
}
##:start##
#:0



#############################################
##### the plot

cardata <- car.test.frame[,6:7]
bagplot(cardata,verbose=F,factor=3,show.baghull=T,dkmethod=2,
show.loophull=T,precision=1)
title("car data Chambers/Hastie 1992")
box()
