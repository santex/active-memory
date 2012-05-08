require(seewave)

data(pellucens)
par(bg = "black", col = "white")
pellucenszoom <- cutw(pellucens, f = 22050, from = 1, plot = FALSE)
spectro(pellucenszoom, f = 22050, wl = 512, ovlp = 85, collevels = seq(-25,
    0, 0.5), osc = TRUE, colgrid = "white", palette = rev.heat.colors,
    colwave = "white", colaxis = "white", collab = "white", colline = "white")
