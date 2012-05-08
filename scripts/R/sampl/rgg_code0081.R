
fancyaxis <- function(side, summ, at=NULL, mingap=0.5, digits=2,
                      shiftfac=0.003, gapfac=0.003) {
  # side: like axis()
  # summ: a summary object, for example returned by summary()
  # mingap: the smallest gap permitted between two tickmarks,
  #         expressed as a fraction of the default tickmark gap
  # digits: the number of digits to round minimum and maximum to
  # shiftfac: proportion of plot width used to offset the broken axis
  # gapfac: proportion of plot width used to leave for median gap
  
  # TODO:
  # Deal with case where length(axTicks)<2
  # Deal with logarithmic axis case properly, as axTicks difference
  #  is not uniform.
  
  # Get summary information
  amin <- summ[1]
  aq1 <- summ[2]
  amed <- summ[3]
  amean <- summ[4]
  aq3 <- summ[5]
  amax <- summ[6]

  # Find out the properties of the side we are doing
  parside <-
    if (side==1){
      # Does the outside of the plot have larger or smaller vales
      flip <- 1
      # Are we on the xaxis
      xaxis <- TRUE
      # Is this axis logarithmic
      islog <- par("xlog")
      # Is the other axis logarithmic
      otherlog <- par("ylog")
      # Relevant index of par("usr")
      3
    }
    else if (side==2) {
      flip <- 1
      xaxis <- FALSE
      islog <- par("ylog")
      otherlog <- par("xlog")
      1
    }
    else if (side==3) {
      flip <- -1
      xaxis <- TRUE
      islog <- par("xlog")
      otherlog <- par("ylog")
      4
    }
    else if (side==4) {
      flip <- -1
      xaxis <- FALSE
      islog <- par("ylog")
      otherlog <- par("xlog")
      2
    }

  # Calculate default positions of ticks
  if (is.null(at))
    ticks <- axTicks(side)
  else
    ticks <- at

  # Remove any ticks outside the range
  ticks <- ticks[(ticks>=amin) & (ticks<=amax)]
  
  # Calculate the minimum desired gap between ticks
  numticks <- length(ticks)
  if (islog)
    axgap <- (log10(ticks[numticks])-log10(ticks[numticks-1]))*mingap
  else
    axgap <- (ticks[numticks]-ticks[numticks-1])*mingap

  # Get new range of tickmarks
  numticks <- length(ticks)
  firsttick <- ticks[1]
  lasttick <- ticks[numticks]
  
  # If max tick will be too close to the last tick, replace it,
  #  otherwise append it
  if (islog && (log10(amax) - log10(lasttick) < axgap)) {
    ticks[numticks]<-amax
  } else if (amax - lasttick < axgap) {
    ticks[numticks]<-amax	
  } else {	
    ticks<-c(ticks,amax)
  }
  
  # Similarly for first tick
  if (islog && (abs(log10(amin)-log10(firsttick)) < axgap)) {
    ticks[1]<-amin	
  } else if (firsttick - amin < axgap) {
    ticks[1]<-amin	
  } else {	
    ticks<-c(amin, ticks)
  }

  # Format the labels. min and max should have as many
  #  trailing zeros they were rounded to, the others
  #  should have the minimum needed to represent the tick marks
  numticks <- length(ticks)

  # Min and max
  lmin <- format(round(ticks[1],digits), nsmall=digits, trim=TRUE)
  lmax <- format(round(ticks[numticks]), nsmall=digits, trim=TRUE)

  # The others
  middle <- format(ticks[2:(numticks-1)], trim=TRUE)

  # Combine them
  labels <- c(lmin,middle,lmax)

  # Draw the axis
  oldlend <- par(lend = "butt")
  on.exit(par(oldlend))

  # Used for overwriting the axis line to leave tickmarks
  bg <- par("bg")
  if (bg == "transparent")
    bg <- "white"

  lwd=0.7
  # Draw the axis and tickmarks
  axis(side, ticks, labels=FALSE, col="gray50", lwd=lwd)
  # Erase the axis
  overlwd=1
  axis(side, ticks, labels=FALSE, col=bg, tcl = 0, lwd=overlwd)
  # Draw the labels
  axis(side, ticks, labels=labels, tick=FALSE)

  # Axis position
  base<-par("usr")[parside]

  # Width and height in user units
  plotwidth <- diff(par("usr")[1:2])
  plotheight <- diff(par("usr")[3:4])

  # Shift for the q2 and q3 axis from the base (in inches)
  shift <- par("pin")[1]*shiftfac*flip
  # Gap for the median
  gap <- par("pin")[1]*gapfac
  
  # Shift for the mean pointer away from the axis
  meanshift <- par("cin")[1]*0.5*flip

  # Scale lengths so both axes are equal on output device
  if (!xaxis) {
    # Y axis

    # Convert inches into user units
    shift <- shift/par("pin")[1]*plotwidth
    meanshift <- meanshift/par("pin")[1]*plotwidth
    gap <- gap/par("pin")[2]*plotheight
  } else {
    # X axis

    # Convert inches into user units
    shift <- shift/par("pin")[2]*plotheight
    meanshift <- meanshift/par("pin")[2]*plotheight
    gap <- gap/par("pin")[1]*plotwidth
  }

  if (islog) {
    # Log case on this axis (affects gap)
    lmed <- log10(amed)
    gapt <- 10^(lmed + gap)
    gapb <- 10^(lmed - gap)
  } else {
    # Linear case on this axis
    gapt <- amed + gap
    gapb <- amed - gap
  }

  # Position of q2 and q3 axis segments
  offset <- base + shift

  # Which segment is the mean in?
  if((amean>aq3) || (amean<aq1)) {
    # Mean is in q1/q4, so move relative to base
    meanbase <- base - meanshift
  } else {
    # Mean is in q2/q3, so move relative to shifted base
    meanbase <- offset - meanshift
  }

  if (otherlog) {
    # Log case on the other axis (affects shift, base, meanshift)
    meanbase <- 10^meanbase
    offset <- 10^offset
    base <- 10^base
  }

  # Stops the lines overrunning
  par(lend = "butt")

  # Line width for axis lines
  lwd=1

  # Draw q1 and q4 axis segments
  if (!xaxis) {
    #     xs,         ys,          Don't clip, Line width, Don't overlap 
    lines(rep(base,2),c(amin,aq1), xpd=TRUE, lwd=lwd)
    lines(rep(base,2),c(aq3,amax), xpd=TRUE, lwd=lwd)
  } else {
    lines(c(amin,aq1),rep(base,2), xpd=TRUE, lwd=lwd)
    lines(c(aq3,amax),rep(base,2), xpd=TRUE, lwd=lwd)
  }

  # Draw q2 and q3 axis segments
  if (!xaxis) {
    lines(rep(offset,2),c(aq1,gapb), xpd=TRUE, lwd=lwd)
    lines(rep(offset,2),c(gapt,aq3), xpd=TRUE, lwd=lwd)
  } else {
    lines(c(aq1,gapb),rep(offset,2), xpd=TRUE, lwd=lwd)
    lines(c(gapt,aq3),rep(offset,2), xpd=TRUE, lwd=lwd)
  }
  

  # Draw the mean
  if (!xaxis) {
    points(meanbase, amean, pch=18, cex=0.7, col="red", xpd=TRUE)
  } else {
    points(amean, meanbase, pch=18, cex=0.7, col="red", xpd=TRUE)
  }
}

                      
                      
                      
# Draw a stripchart on an axis, showing marginal frequency
# TODO: Does not handle log axes well
axisstripchart <- function(x, side, sshift=0.3) {
  # x:    the data from which the plots are to be produced.
  # side: as in axis()
  
  # Find out the properties of the side we are doing
  parside <-
    if (side==1){
      # Does the outside of the plot have larger or smaller vales
      flip <- 1
      # Are we on the yaxis
      yaxis <- FALSE
      # Relevant index of par("usr")
      3
    }
    else if (side==2) {
      flip <- 1
      yaxis <- TRUE
      1
    }
    else if (side==3) {
      flip <- -1
      yaxis <- FALSE
      4
    }
    else if (side==4) {
      flip <- -1
      yaxis <- TRUE
      2
    }

  # Axis position
  base<-par("usr")[parside]
  
  # Width and height in user units
  plotwidth <- diff(par("usr")[1:2])
  plotheight <- diff(par("usr")[3:4])
  
  # Shift for the q2 and q3 axis from the base (in inches)
  shift <- par("pin")[1]*0.003*flip
  # Gap for the median
  gap <- par("pin")[1]*0.003
  # Shift for the mean pointer away from the axis
  meanshift <- par("cin")[1]*0.5*flip
  # Shift away from the q2 and q3 axis for the stripchart
  stripshift <- par("cin")[1]*sshift*flip
  
  # Scale lengths so both axes are equal on output device
  if (yaxis) {
    shift <- shift/par("pin")[1]*plotwidth
    meanshift <- meanshift/par("pin")[1]*plotwidth
    stripshift <- stripshift/par("pin")[1]*plotwidth
    gap <- gap/par("pin")[2]*plotheight
  } else {
    shift <- shift/par("pin")[2]*plotheight
    meanshift <- meanshift/par("pin")[2]*plotheight
    stripshift <- stripshift/par("pin")[2]*plotheight
    gap <- gap/par("pin")[1]*plotwidth
  }

  # If vertical, stripchart assumes offset is a factor of character
  # width, if horizontal, character height (bug?). So correct for this
  if (yaxis)
    offset=flip*par("cin")[2]/par("cin")[1]
  else
    offset=flip

  # Don't clip the chart
  oldxpd <- par(xpd = TRUE)
  on.exit(par(oldxpd))
  
  stripchart(x, method="stack", vertical=yaxis, offset=offset, pch=15,
             cex=0.2, add=TRUE, at=base+shift+stripshift, col="red")
}





stripchartexample <- function() {
  # Sample dataset from R
  xdata <- faithful$waiting
  ydata <- faithful$eruptions*60
  len=length(xdata)
  
  # Label event with its previous duration

  split=180

  lag=ydata[1:len-1]
  colours <- lag
  colours[lag>=split] <- "red"
  colours[!(lag>=split)] <- "blue"

  xdata=xdata[2:len]
  ydata=ydata[2:len]
  len=length(xdata)
  
  # Plot the data
  plot(xdata,ydata,
       # Omit axes
       axes=FALSE,
       pch=20,
       main=sprintf("Old Faithful Eruptions (%d samples)", len),
       xlab="Time till next eruption (min)",
       ylab="Duration (sec)",
       # Leave some space for the rug plot
       xlim=c(41,max(xdata)),
       ylim=c(70,max(ydata)),
       cex=0.5,
       col=colours)

  axp=par("xaxp")
  axp[3] <- axp[3]*2
  par("xaxp"=axp)
  
  # Add the axes, passing in the summary to provide quartile and mean
  fancyaxis(1,summary(xdata), digits=0)
  fancyaxis(2,summary(ydata), digits=0)

  # Add the stripcharts
  axisstripchart(xdata, 1)
  axisstripchart(ydata, 2)

  lines(c(min(xdata),max(xdata)),c(split,split),lty=2, col="gray50", xpd=FALSE)
  h=par("cxy")[2]/2
  points(rep(max(xdata),2),c(split+h,split-h),col=c("red","blue"), pch=20)
  text(95,split+h, "Previous duration", adj=c(1,0.5))
  
}


stripchartexample()

