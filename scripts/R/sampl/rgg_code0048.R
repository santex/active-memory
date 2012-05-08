library(lattice)
lattice.options(default.theme = canonical.theme(color = FALSE))


tmp <-
    expand.grid(geology = c("Sand","Clay","Silt","Rock"),
                species = c("ArisDiff", "BracSera", "CynDact", 
                            "ElioMuti", "EragCurS", "EragPseu"),
                dist = seq(1,9,1) )

tmp$height <- rnorm(216)


sp <- list(superpose.symbol = list(pch = 1:6, cex = 1.2),
           superpose.line = list(col = "grey", lty = 1))

# print is needed when you source() the file
print(xyplot(height ~ dist | geology, data = tmp,
       groups = species,
       layout = c(2,2),
       panel = function(x, y, type, ...) {
         panel.superpose(x, y, type="l", ...)
         lpoints(x, y, pch=16, col="white", cex=2)
         panel.superpose(x, y, type="p",...)
       },
       par.settings = sp,
       auto.key = list(columns = 2, lines = TRUE)))

