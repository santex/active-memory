require(colorspace)
require(vcd)


data(MSPatients)
pushViewport(viewport(layout = grid.layout(ncol = 2)))
pushViewport(viewport(layout.pos.col = 1))
agreementplot(t(MSPatients[,,1]), main = "Winnipeg Patients",
              newpage = FALSE)
popViewport()
pushViewport(viewport(layout.pos.col = 2))
agreementplot(t(MSPatients[,,2]), main = "New Orleans Patients",
              newpage = FALSE)
popViewport(2)
