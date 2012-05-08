set.seed(65)
x      <- rnorm(500)
breaks <- quantile(x, 0:20/20)

hist(x, 
     breaks = breaks, 
     col    = "#ffc38a", 
     border = "#5FAE27", 
     main   = "Histogram with equal counts")

     
# add a kernel density estimator of x
lines(density(x), col = '#3F489D', lty = '1318', lwd=2)

# add a box around the plot
box()
