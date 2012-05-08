require("colorspace")
require("vcd")

data(HairEyeColor)
x <- margin.table(HairEyeColor, c(1, 2))

## with residual-based shading (of independence)
assoc(x, main = "Relation between hair and eye color", shade = TRUE)

