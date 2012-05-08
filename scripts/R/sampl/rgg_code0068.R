require(RColorBrewer)
require(maps)
require(cluster)


palette(brewer.pal(3,"Accent"))

op <- par(no.readonly=TRUE)
x <- state.x77[,-c(1:2,7:8)]

pamr <- pam(x, k=3)
pamc <- pamr$clustering


layout(matrix(c(1,1,2,3),nr=2),heights=c(50,50),widths=c(75,25))


#------ first plot : the map
par(mar=c(.5,.5,.5,.5))
map("state", regions = names(pamc),
              boundary = FALSE, 
              lty = 1, lwd =1,
              col= pamc ,
              fill=T)
              
legend("bottomleft",legend=paste("group",1:3," : ",c("blabla","bla","yada yada")), 
       fill=1:3, 
       bg=gray(.8), 
       cex=1.2)

title("Cluster analysis on state.x77 data", 
      cex.main=2, 
      font.main=3, 
      col.main="orange", 
      line=1)
mtext(paste("variables : ", paste(colnames(x),collapse=", ")),
      line=0,
      cex=.8,
      side=3)
 
par(mar=c(2,.5,2,.5))              

#------ secondplot : clusplot
clusplot(pamr, color=TRUE, col.clus = 1:3, shade = TRUE, axes=FALSE)


#------ third plot : silhouette plot
si <- silhouette(pamr)

plot(si,do.n.k=FALSE, col=rev(si[,1]),do.col.sort=FALSE,do.clus.stat= FALSE)

par(op)            # reset the parameters
palette('default') # reset the palette

