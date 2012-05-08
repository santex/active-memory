library(MASS)

with(crabs,
     coplot(FL ~ RW | sp * sex, 
            subscripts = T, 
            xlab = "Rear Width (mm)",
            ylab = "Frontal Lobe (mm)",
            panel = function(x, y, subscripts, ...){
                        points(x, y, col = "gray75")
                        lines(smooth.spline(RW[subscripts], FL[subscripts]), lwd = 2,col = "black")
                     }
	    )
     )

