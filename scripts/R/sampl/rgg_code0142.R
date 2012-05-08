library(connectedness) ## On CRAN

data(connect)
table(connect$group, connect$season)
tmp <- connectedness(x=connect$group, y=connect$season)

## Plot method
par(mfrow=c(2, 2))
plot(tmp)

plot(tmp, matrix=FALSE, lines=TRUE, col=c("green", "blue"),
     pointsArg=list(pch=c(15, 19), cex=2), linesArg=list(lwd=2))

plot(tmp, scale=FALSE, lines=TRUE, linesSet=1,
     linesArg=list(col="black", lwd=2))

plot(tmp, set=2, col=c("gray"),
     plotArg=list(xlab="Group", ylab="Season"))
