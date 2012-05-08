require(gplots)

set.seed(120)
# simulate an AR(1) process
coefs  <- 0.95
series <- arima.sim(list(ar=coefs),n=250)


# fit AR(1) with the 200 first data
model  <- arima(series[1:200],c(1 ,   # AR part
                                0,    #  I order
			        0))   # MA part

# make forecast from the model
forecast <- predict(model,80)

# compute the limits of the graph
ylim <- c( min(series[1:200],forecast$pred - 1.96 * forecast$se),
           max(series[1:200],forecast$pred + 1.96 * forecast$se))

# prepare the space where to plot
opar <- par(mar=c(4,4,2,2),las=1)
plot(series,ylim=ylim,type="n",xlim=c(1,250))
usr <- par("usr")

# split the figure in two parts
#   - the part used to fit the model
rect(usr[1],usr[3],201   ,usr[4],border=NA,col="lemonchiffon")

#   - the part used to make the forecast
rect(201   ,usr[3],usr[2],usr[4],border=NA,col="lavender")

abline(h= (-3:3)*2 , col ="gray" , lty =3)


# draw a 95% confidence band
polygon( c(201:280,280:201),
         c(forecast$pred - 1.96*forecast$se,rev(forecast$pred + 1.96*forecast$se)),
	 col = "orange",
	 lty=2,border=NA)

	     
lines( 201:280 , forecast$pred - 1.96*forecast$se , lty=2)
lines( 201:280 , forecast$pred + 1.96*forecast$se , lty=2)



lines( series , lwd=2 )
lines(201:280 , forecast$pred , lwd=2 , col ="white")

smartlegend( x="left", y= "top", inset=0,                             #smartlegend parameters
             legend = c("series","prediction","95% confidence band"), #legend parameters
	     fill=c("black","white","orange"),                        #legend parameters
	     bg = "gray")                                             #legend parameters


box()
par(opar) # reset the par

