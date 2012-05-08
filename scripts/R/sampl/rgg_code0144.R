download.file("http://addictedtor.free.fr/graphiques/data/90/4D.RData",
              "4D.RData", mode = "wb")
load("4D.RData")

my.title = paste("Black Sea Bass", 
                 "Colors = values of SPR",
                 "Black contours = values of YPR", sep = "\n")


### wrapped into functions

multiTitle <- function(...){
###
### multi-coloured title
###
### examples:
###  multiTitle(color="red","Traffic",
###             color="orange"," light ",
###             color="green","signal")
###
### - note triple backslashes needed for embedding quotes:
###
###  multiTitle(color="orange","Hello ",
###             color="red"," \\\"world\\\"!")
###
### Barry Rowlingson <b.rowlingson@lancaster.ac.uk>
###
  l = list(...)
  ic = names(l)=='color'
  colors = unique(unlist(l[ic]))

  for(i in colors){
    color=par()$col.main
    strings=c()
    for(il in 1:length(l)){
      p = l[[il]]
      if(ic[il]){ # if this is a color:
        if(p==i){  # if it's the current color
          current=TRUE
        }else{
          current=FALSE
        }
      }else{ # it's some text
        if(current){
          # set as text
          strings = c(strings,paste('"',p,'"',sep=""))
        }else{
          # set as phantom
          strings = c(strings,paste("phantom(\"",p,"\")",sep=""))
        }
      }
    } # next item
    ## now plot this color
    prod=paste(strings,collapse="*")
    express = paste("expression(",prod,")",sep="")
    e=eval(parse(text=express))
    title(e,col.main=i)
  } # next color
  return()
}

## Example
 plot(rnorm(20),rnorm(20),col=rep(c("red","blue"),c(10,10)))
 multiTitle(color="red","Hair color", color="black"," and ",color="blue","Eye color")

## By Duncan Murdoch: https://stat.ethz.ch/pipermail/r-help/2009-January/185696.html
technicolorTitle <- function(words, colours, cex=1) {
    widths <- strwidth(words,cex=cex)
    spaces <- rep(strwidth(" ",cex=cex), length(widths)-1)
    middle <- mean(par("usr")[1:2])
    total <- sum(widths) + sum(spaces)
    start <- c(0,cumsum(widths[-length(widths)] + spaces))
    start <- start + middle - total/2
    mtext(words, 3, 1, at=start, adj=0, col=colours,cex=cex)
    }

## Example
 plot4(technicolorTitle(c("Hair color", "and", "Eye color"), c("red", "black", "blue"))
