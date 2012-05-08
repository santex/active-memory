require(plotrix)

Ymd.format <- "%Y/%m/%d"

Ymd <- function(x){ as.POSIXct(strptime(x, format=Ymd.format))}
gantt.info <- list(
  labels     =c("First task","Second task","Third task","Fourth task","Fifth task"),
  starts     =Ymd(c("2004/01/01","2004/02/02","2004/03/03","2004/05/05","2004/09/09")),
  ends       =Ymd(c("2004/03/03","2004/05/05","2004/05/05","2004/08/08","2004/12/12")),
  priorities =c(1,2,3,4,5))

gantt.chart(gantt.info,main="Calendar date Gantt chart")

