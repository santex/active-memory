library(Hmisc)
library(lattice)
tmp <-
structure(list(Position = structure(as.integer(c(1, 2, 1, 2,
1, 2, 1, 2)), .Label = c("Inside", "Outside"), class = "factor"),
    AltGeo = structure(as.integer(c(1, 1, 2, 2, 3, 3, 4, 4)), .Label = c("Basalt-High",
    "Basalt-Low", "Quartz-High", "Quartz-Low"), class = "factor"),
    Sodium = c(27.3333333333333, 26.8888888888889, 25, 18.1111111111111,
    4.66666666666667, 5.55555555555556, 10.6666666666667, 5.66666666666667
    ), SD = c(5.3851648071345, 2.42097317438899, 20.1618451536560,
    15.2679766541317, 5.45435605731786, 8.09492296305393, 10.6183802907976,
    8.06225774829855), Nobs = c(9, 9, 9, 9, 9, 9, 9, 9), Lower = c(25.5382783976218,
    26.0818978307592, 18.2793849487813, 13.0217855597339, 2.84854798089405,
    2.85724790120425, 7.12720656973412, 2.97924741723382), Upper = c(29.1283882690448,
    27.6958799470186, 31.7206150512187, 23.2004366624884, 6.48478535243929,
    8.25386320990686, 14.2061267635992, 8.35408591609952)), .Names = c("Position",
"AltGeo", "Sodium", "SD", "Nobs", "Lower", "Upper"), row.names = c("1",
"2", "3", "4", "5", "6", "7", "8"), class = "data.frame")
tmp$PosNum <- unclass(tmp$Position)
labs <- unique(tmp$Position)

print(xYplot(Cbind(Sodium,Lower,Upper) ~ PosNum|AltGeo, data=tmp, nx=FALSE,
  xlim=c(0.5,2.5),
  ylim=c(min(tmp$Lower)-1,max(tmp$Upper)+1),
  scales = list(x = list(at=seq(1, 2, by=1), labels = labs)),
  xlab="Position", ylab="Sodium"
  ) )

