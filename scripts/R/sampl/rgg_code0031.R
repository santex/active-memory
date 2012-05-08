require("vcd")

# create data
madison=table(rep(0:6,c(156,63,29,8,4,1,1)))

# fit a poisson distribution
madisonPoisson=goodfit(madison,"poisson")
rootogram(madisonPoisson)


