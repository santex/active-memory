data(warpbreaks)  ## given two factors
coplot(breaks ~ 1:54 | wool * tension, data = warpbreaks,
       col = "red", bg = "pink", pch = 21,
       bar.bg = c(fac = "light blue"))

