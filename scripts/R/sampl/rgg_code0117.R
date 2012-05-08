require(vcd)

data("Arthritis")

spine(Improved ~ Age, 
      data = Arthritis, 
      breaks = quantile(Arthritis$Age))
