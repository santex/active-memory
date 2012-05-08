require(vcd)

data(CoalMiners)
l <- oddsratio(CoalMiners)
g <- seq(25, 60, by = 5)
plot(l,
     xlab = "Age Group",
     main = "Breathelessness and Wheeze in Coal Miners")
m <- lm(l ~ g + I(g^2))
lines(fitted(m), col = "red")

