require(lattice)

	data(iris)
	print(cloud(Sepal.Length ~ Petal.Length * Petal.Width, data = iris,
	  groups = Species, screen = list(z = 20, x = -70),
	  perspective = FALSE,
	  key = list(title = "Iris Data", x = .15, y=.85, corner = c(0,1),
	  border = TRUE, 
	  points = Rows(trellis.par.get("superpose.symbol"), 1:3),
	  text = list(levels(iris$Species)))))

