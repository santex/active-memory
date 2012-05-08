require(gplots)

carnames <- c("bmw","renault","mercedes","seat")
carcolors <- c("red","white","silver","green")
datavals <- round(rnorm(16, mean=100, sd=60),1)
data <- data.frame(Car=rep(carnames,4),
                   Color=rep(carcolors, c(4,4,4,4) ),
                   Value=datavals )
		   
levels(data$Car) <- c("BMW: \nHigh End,\n German","Renault: \nMedium End,\n French",
 "Mercedes:\n High End,\n German", "Seat:\n Imaginary,\n Unknown Producer")

# generate balloon plot with default scaling
balloonplot( data$Car, data$Color, data$Value, ylab ="Color", xlab="Car")


