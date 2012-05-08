
library("Defaults")
setDefaults(cat,file="sink.txt")


f = function() { 
  for(i in 1:10000)
      cat(i)
  return(1)
}


x<-f()
x

