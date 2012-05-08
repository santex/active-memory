require(lattice)
require(MASS)
require(grid)

data(iris)
parallel(~iris[1:3]|Species, data = iris, 
            layout=c(2,2), pscales = 0,
            varnames = c("Sepal\nLength", "Sepal\nWidth", "Petal\nLength"),
            page = function(...) {
                grid.text(x = seq(.6, .8, len = 4), 
                          y = seq(.9, .6, len = 4), 
                          label = c("Three", "Varieties", "of", "Iris"),
                          gp = gpar(fontsize=20))
            })

