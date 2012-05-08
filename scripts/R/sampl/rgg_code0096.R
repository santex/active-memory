require("vcd")

## Hitters
data(Hitters)
attach(Hitters)
colors <- c("black","red","green","blue","red","black","blue")
pch <- substr(levels(Positions), 1, 1)
ternaryplot(
  Hitters[,2:4],
  pch = as.character(Positions),
  col = colors[as.numeric(Positions)],
  main = "Baseball Hitters Data"
)
grid_legend(0.8, 0.9, pch, colors, levels(Positions),
  title = "POSITION(S)")
  
  
Hitters
