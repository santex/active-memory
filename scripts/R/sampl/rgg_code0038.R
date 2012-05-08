require("hexbin")

data(NHANES)# pretty large data set!
good <- !(is.na(NHANES$Albumin) | is.na(NHANES$Transferin))
NH.vars <- NHANES[good, c("Age","Sex","Albumin","Transferin")]

# extract dependent variables and find  ranges for global binning
x <- NH.vars[,"Albumin"]
rx <- range(x)
y <- NH.vars[,"Transferin"]
ry <- range(y)

age <- cut(NH.vars$Age,c(1,45,65,200))
sex <- NH.vars$Sex
subs <- tapply(age,list(age,sex))
#bivariate bins for each factor combination

for (i in 1:length(unique(subs))) {
   good <- subs==i
   assign(paste("nam",i,sep=""),
   erode.hexbin(hexbin(x[good],y[good],xbins=23,xbnds=rx,ybnds=ry)))
}

nam <- matrix(paste("nam",1:6,sep=""),ncol=3,byrow=TRUE)
rlabels <-c("Females","Males")
clabels  <- c("Age <= 45","45 < Age <= 65","Age > 65")
zoom <- hmatplot(nam,rlabels,clabels,border=list(hbox=c("black","white"),
                 hdiff=rep("white",6)))

