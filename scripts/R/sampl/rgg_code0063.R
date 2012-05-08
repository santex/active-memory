p <- palette(rainbow(12, s = 0.6, v = 0.75))
x <- rnorm(30)
F10 <- ecdf(x)

a <- stars(F10, len = 0.8, key.loc = c(12, 1.5),
           main = "Motor Trend Cars", draw.segments = TRUE)
print(a)
print(p)
