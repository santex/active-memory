
armaGR <- function(arima.out,noms,n=117){

   essai1 <- arima.out$coef
   essai2 <- sqrt(diag(arima.out$var.coef))

   Essai  <- data.frame(matrix(NA,ncol=4,nrow=length(noms)))
   dimnames(Essai) <- list(noms,c("coef","std","tstat","pv"))

   Essai[,1] <- essai1
   for(i in 1:length(essai2)) 
     Essai[which(rownames(Essai)==names(essai2)[i]),2] <- essai2[i]
   Essai[,3] <- Essai[,1] / Essai[,2]
   Essai[,4] <- round((1-pt(abs(Essai[,3]),df=n-(length(essai2)+1)))*2,5)
   vecteur <- rep(NA,length(noms))
   vecteur[is.na(Essai[,4])] <- 0
            
   maxi          <- which.max(Essai[,4])
   continuer     <- max(Essai[,4],na.rm=TRUE) > .05
   vecteur[maxi] <- 0
   
   cat("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
   list(summary=Essai,suivant=vecteur,continuer=continuer)
}


arimaSelect <- function(serie,order=c(13,0,0),include.mean=F){

   coeff     <- matrix(NA,nrow=order[1]+order[3],ncol=order[1]+order[3])
   pval      <- matrix(NA,nrow=order[1]+order[3],ncol=order[1]+order[3])
   
   liste <- rep(list(NULL),order[1]+order[3])
   noms  <- NULL
   if(order[1] > 0) noms <- paste("ar",1:order[1],sep="")
   if(order[3] > 0) noms <- c( noms , paste("ma",1:order[3],sep="") )
   
   arima.out <- arima(serie,order=order,include.mean=include.mean,method="ML")
   liste[[1]] <- arima.out
   
   dernier   <- armaGR(arima.out,noms,length(serie))
   arret     <- FALSE
   i <- 1
   coeff[i,] <- dernier[[1]][,1]
   pval [i,] <- dernier[[1]][,4]
     
   i <- 2
   aic <- arima.out$aic
   while(!arret){
     liste[[i]] <- arima.out
     arima.out <- arima(serie,
                        order=order,
			include.mean=include.mean,
			method="ML",
			fixed=dernier$suivant)
     aic <- c(aic,arima.out$aic)
     dernier <- armaGR(arima.out,noms,length(serie))
     arret   <- !dernier$continuer
     coeff[i,] <- dernier[[1]][,1]
     pval [i,] <- dernier[[1]][,4]
     
     i <- i+1
   }
   
list(coeff,pval,liste,aic=aic)

}

arimaSelectplot <- function(arimaSelect.out,noms,choix){
	noms <- names(arimaSelect.out[[3]][[1]]$coef)
	coeff <- arimaSelect.out[[1]]
	k <- min(which(is.na(coeff[,1])))-1
	coeff <- coeff[1:k,]
	pval  <- arimaSelect.out[[2]][1:k,]
	aic   <- arimaSelect.out$aic[1:k]
	coeff[coeff==0] <- NA
	n <- ncol(coeff)
	if(missing(choix)) choix <- k
	
	layout(matrix(c(1,1,1,2,
	                3,3,3,2,
			3,3,3,4,
			5,6,7,7),nr=4),
               widths=c(10,35,45,15),
	       heights=c(30,30,15,15))
	couleurs <- rainbow(75)[1:50]#(50)
	ticks <- pretty(coeff)
	
	### graph AIC
	par(mar=c(1,1,3,1))
	plot(aic,k:1-.5,type="o",pch=21,bg="blue",cex=2,axes=F,lty=2,xpd=NA)
	points(aic[choix],k-choix+.5,pch=21,cex=4,bg=2,xpd=NA)
	#axis(3)
	title("aic",line=2)
	
	par(mar=c(3,0,0,0))	
	plot(0,axes=F,xlab="",ylab="",xlim=range(ticks),ylim=c(.1,1))
	rect(xleft  = min(ticks) + (0:49)/50*(max(ticks)-min(ticks)),
	     xright = min(ticks) + (1:50)/50*(max(ticks)-min(ticks)),
	     ytop   = rep(1,50),
	     ybottom= rep(0,50),col=couleurs,border=NA)
	axis(1,ticks)
	rect(xleft=min(ticks),xright=max(ticks),ytop=1,ybottom=0)
	text(mean(coeff,na.rm=T),.5,"coefficients",cex=2,font=2)
	
	
	par(mar=c(1,1,3,1))
	image(1:n,1:k,t(coeff[k:1,]),axes=F,col=couleurs,zlim=range(ticks))
	for(i in 1:n) for(j in 1:k) if(!is.na(coeff[j,i])) {
		if(pval[j,i]<.01)                            symb = "green"
		else if( (pval[j,i]<.05) & (pval[j,i]>=.01)) symb = "orange"
		else if( (pval[j,i]<.1)  & (pval[j,i]>=.05)) symb = "red"
		else                                         symb = "black"
		polygon(c(i+.5   ,i+.2   ,i+.5   ,i+.5),
		        c(k-j+0.5,k-j+0.5,k-j+0.8,k-j+0.5),
			col=symb)
		
		#points(i+.4,k-j+.6,pch=21,bg=symb)
		#text(i+.5,k-j+.8,round(pval[j,i],2),pos=2,cex=.8)
		if(j==choix)  {
			rect(xleft=i-.5,
			     xright=i+.5,
			     ybottom=k-j+1.5,
			     ytop=k-j+.5,
			     lwd=4)
			text(i,
			     k-j+1,
			     round(coeff[j,i],2),
			     cex=1.2,
			     font=2)
		}
		else{
			rect(xleft=i-.5,xright=i+.5,ybottom=k-j+1.5,ytop=k-j+.5)
			text(i,k-j+1,round(coeff[j,i],2),cex=1.2,font=1)
		}
	}
	axis(3,1:n,noms)


	par(mar=c(0.5,0,0,0.5))	
	plot(0,axes=F,xlab="",ylab="",type="n",xlim=c(0,8),ylim=c(-.2,.8))
	cols <- c("green","orange","red","black")
	niv  <- c("0","0.01","0.05","0.1")
	for(i in 0:3){
		polygon(c(1+2*i   ,1+2*i   ,1+2*i-.5   ,1+2*i),
		        c(.4      ,.7      , .4        , .4),
			col=cols[i+1])
		text(2*i,0.5,niv[i+1],cex=1.5)	
		}
	text(8,.5,1,cex=1.5)
	text(4,0,"p-value",cex=2)
	box()
	
	residus <- arimaSelect.out[[3]][[choix]]$res
	
	par(mar=c(1,2,4,1))
	acf(residus,main="")
	title("acf",line=.5)
	
	par(mar=c(1,2,4,1))
	pacf(residus,main="")
	title("pacf",line=.5)
	
	par(mar=c(2,2,4,1))
	qqnorm(residus,main="")
	title("qq-norm",line=.5)
	
}

serie <- c( 12.7928205128205,16.2928205128205,12.5528205128205,11.0128205128205,
            10.1728205128205,
            4.13282051282052,2.33282051282052,10.2828205128205,7.20282051282051 ,
	    5.23282051282051,3.86282051282051,6.1128205128205,
	    5.90282051282051,5.23282051282051,0.802820512820517,3.28282051282051,
	    0.172820512820508,-2.35717948717949,-4.33717948717948,
	    8.80282051282052,-3.81717948717949,-4.98717948717949,-3.42717948717949,
	    -5.39717948717949,0.012820512820511,-1.08717948717948,
	    -3.57717948717949,-0.797179487179491,-4.59717948717949,-9.77717948717948,
	    -6.06717948717949,-0.287179487179486,
	    -8.62717948717949,-8.7971794871795,-3.66717948717948,-7.77717948717948,
	    -7.42717948717949,-5.59717948717949,-4.02717948717948,
	    -2.43717948717949,-2.99717948717949,-4.52717948717948,-5.79717948717949,
	    2.12282051282051,3.01282051282051, 
	    -3.57717948717949,18.4628205128205,22.8328205128205,19.8328205128205,
	    26.1028205128205,20.7828205128205,18.6128205128205,
	    16.5328205128205,6.34282051282051,0.792820512820512,8.91282051282052,
	    1.94282051282052,1.33282051282052,0.132820512820516 ,
	    -2.03717948717949,-1.01717948717949,-0.447179487179483,-10.8171794871795,
	    -6.40717948717949,-3.85717948717949,-8.29717948717949,
	    -5.92717948717949,-3.50717948717949,-10.7871794871795,-4.63717948717949,
	    -9.11717948717948,-3.88717948717949,-4.99717948717949,
	    0.472820512820519,-4.69717948717948,5.03282051282051,1.67282051282051,
	    -3.13717948717949,-4.84717948717949,8.88282051282052,
	    -1.21717948717949,3.99282051282051,0.84282051282051,-0.387179487179495,
	    2.37282051282051,1.58282051282052,-1.44717948717948,
	    -0.927179487179487,2.59282051282051,-4.74717948717949,-4.15717948717949,
	    1.21282051282051,-4.99717948717949,-5.69717948717948,
	    -3.85717948717949,-0.657179487179491,-7.2471794871795,-4.33717948717948,
	    -7.1371794871795,-0.347179487179488,
	    -6.97717948717948,-10.7071794871795,-4.98717948717949,0.48282051282051,
	    -9.28717948717949,-9.6571794871795,-7.04717948717949,
	    -5.16717948717948,-10.4771794871795,-5.21717948717949,-6.32717948717949,
	    5.93282051282051,-4.61717948717948,-0.827179487179492,
	    -5.94717948717948,11.6528205128205,-2.07717948717949 )

#-----------------------------------------------------------------------#
selection <- arimaSelect(serie,order=c(7,0,3))
arimaSelectplot(selection,choix=4)




