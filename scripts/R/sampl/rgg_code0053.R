#library(UsingR)
record.high=c(95,95,93,96,98,96,97,96,95,97)
record.low= c(49,47,48,51,49,48,52,51,49,52)
normal.high=c(78,78,78,79,79,79,79,80,80,80)
normal.low= c(62,62,62,63,63,63,64,64,64,64)
actual.high=c(80,78,80,68,83,83,73,75,77,81)
actual.low =c(62,65,66,58,69,63,59,58,59,60)
x=rbind(record.low,record.high,normal.low,normal.high,actual.low,actual.high)
the.names=c("S","M","T","W","T","F","S")[c(3:7,1:5)]
barplot(x,names=the.names)

