library(klaR)

data(iris)
iris2 <- iris
levels(iris2$Species) <- c('s','e','v')
# otherwise v*e*rsicolor are mixed ip with *v*irginica

partimat(Species ~ ., data = iris2, method = "qda", mar=c(4,4,2,1))


