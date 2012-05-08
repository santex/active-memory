
rm(list=ls(all=TRUE))

###############################################################################################
# Main Function
#
# Input
# -----
#   tickers (text strings)
#   start.date (dates)
#   end.date (dates)
#
# Output
# -------
# 6 Double Matrices: Open, High, Low, Close, Volume, Adj. Close
###############################################################################################

data.loading <- function(tickers, start.date, end.date)
{
  # Change the locale
  sl <- Sys.setlocale(locale="UK")
  
  # Create the universe of dates
  all.dates <- seq(as.Date(start.date), as.Date(end.date), by="day")
  all.dates <- subset(all.dates,weekdays(all.dates) != "Sunday" & weekdays(all.dates) != "Saturday")
  all.dates.char <- as.matrix(as.character(all.dates))
  
  # Create sparse matrices
  open <- matrix(NA, NROW(all.dates.char), length(tickers))
  hi <- open
  low <- open
  close <- open
  volume <- open
  adj.close <- open
  
  # Name the rows correctly
  rownames(open) <- all.dates.char
  rownames(hi) <- all.dates.char
  rownames(low) <- all.dates.char
  rownames(close) <- all.dates.char
  rownames(volume) <- all.dates.char
  rownames(adj.close) <- all.dates.char
  
  # Split the start and end dates to be used in the ULR later on
  splt <- unlist(strsplit(start.date, "-"))
  a <- as.character(as.numeric(splt[2])-1)
  b <- splt[3]
  c <- splt[1]
  
  splt <- unlist(strsplit(end.date, "-"))
  d <- as.character(as.numeric(splt[2])-1)
  e <- splt[3]
  f <- splt[1]
  
  # Create the two out of the three basic components for the URL loading
  str1 <- "http://ichart.finance.yahoo.com/table.csv?s="
  str3 <- paste("&a=", a, "&b=", b, "&c=", c, "&d=", d, "&e=", e, "&f=", f, "&g=d&ignore=.csv", sep="")
  
  # Main loop for all assets
  for (i in seq(1,length(tickers),1))
    {
      str2 <- tickers[i]
      strx <- paste(str1,str2,str3,sep="")
      x <- read.csv(strx)
      
      datess <- as.matrix(x[1])
      
      replacing <- match(datess, all.dates.char)
      open[replacing,i] <- as.matrix(x[2])
      hi[replacing,i] <- as.matrix(x[3])
      low[replacing,i] <- as.matrix(x[4])
      close[replacing,i] <- as.matrix(x[5])
      volume[replacing,i] <- as.matrix(x[6])
      adj.close[replacing,i] <- as.matrix(x[7])
  }
  
  # Name the cols correctly
  colnames(open) <- tickers
  colnames(hi) <- tickers
  colnames(low) <- tickers
  colnames(close) <- tickers
  colnames(volume) <- tickers
  colnames(adj.close) <- tickers
  
  # Return the ouput
  return(list(open=open, high=hi, low=low, close=close, volume=volume, adj.close=adj.close))
}

###############################################################################################
#----------------------------------------------------------------------------------------------
#                                               Example
#----------------------------------------------------------------------------------------------
###############################################################################################
# Tickers of assets we are interested in
tickers <- c("SPY", "QQQ", "XLF")

# Starting Date
first.day <- "2005-01-01"

# Current System Date
last.day <- format(Sys.time(), "%Y-%m-%d")

# Download the data
dataset <- data.loading(tickers, first.day, last.day)

# Extract the parts we want to use
open <- dataset$open
close <- dataset$close
adj.close <- dataset$adj.close
hi <- dataset$high
lo <- dataset$low
vol <- dataset$volume

# Remove the lines that have NAs everywhere [horizontally!!] (due to Bank holidays?)
temp <- rowSums(is.na(open)) == (NCOL(open))
open <- open[!temp,]
close <- close[!temp,]
adj.close <- adj.close[!temp,]
hi <- hi[!temp,]
lo <- lo[!temp,]
vol <- vol[!temp,]

# Focus on SPY
i.ticker <- "SPY"
  
etf.open <- open[,i.ticker]
etf.cl <- close[,i.ticker]
etf.adjcl <- adj.close[,i.ticker]
etf.hi <- hi[,i.ticker]
etf.lo <- lo[,i.ticker]
etf.vol <- vol[,i.ticker]

mmin <- min(etf.hi,etf.lo,etf.cl)
mmax <- max(etf.hi,etf.lo,etf.cl)
cols <- c("black", "blue", "red")
labels <- c("close", "high", "low")

plot(etf.cl, type="l",ylim=c(mmin, mmax), col=cols[1], main="SPY", sub="www.quantf.com", xlab="", ylab="Price")
lines(etf.hi,col=cols[2])
lines(etf.lo,col=cols[3])
legend(x="topleft", lty=1, col=cols,legend=labels,cex=0.7)
