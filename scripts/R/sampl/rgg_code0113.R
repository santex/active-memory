
library("maps") 
bluered <- function(B,K,S=1,graded=F) {
  if (graded) {
    ## Purple plot
    rgb(B/(B+K),0,K/(B+K),S);
  } else {
    ## All or none
    ifelse(B>K,rgb(1,0,0,S),rgb(0,0,1,S))
  }
}

## map.center returns a dataframe with the name and coordinates of the
## center of each map region. Code is based on map.text, can probably be
## improved as often the map database is already available.
map.center <- function (database, regions = ".") {
  cc = match.call(expand.dots = TRUE)
  cc[[1]] = as.name("map")
  cc$fill = TRUE
  cc$plot = FALSE
  cc$move = cc$add = cc$cex = cc$labels = NULL
  cc$resolution = 0
  m <- eval(cc)

  x <- apply.polygon(m, centroid.polygon)
  x2 <- t(array(unlist(x), c(2, length(x))))
  x <- data.frame(name=names(x),x=x2[,1],y=x2[,2])
}

## ---------------------------------------------------------------------------

## Create a map "database".
counties <- map('county',plot=F)

## List of states and abbreviations
states <- c("ALABAMA","AL","ALASKA","AK","AMERICAN SAMOA","AS","ARIZONA","AZ","ARKANSAS","AR","CALIFORNIA","CA","COLORADO","CO","CONNECTICUT","CT","DELAWARE","DE","DISTRICT OF COLUMBIA","DC",
            "FEDERATED STATES OF MICRONESIA","FM","FLORIDA","FL","GEORGIA","GA","GUAM","GU","HAWAII","HI","IDAHO","ID","ILLINOIS","IL","INDIANA","IN","IOWA","IA","KANSAS","KS","KENTUCKY","KY",
            "LOUISIANA","LA","MAINE","ME","MARSHALL ISLANDS","MH","MARYLAND","MD","MASSACHUSETTS","MA","MICHIGAN","MI","MINNESOTA","MN","MISSISSIPPI","MS","MISSOURI","MO","MONTANA","MT",
            "NEBRASKA","NE","NEVADA","NV","NEW HAMPSHIRE","NH","NEW JERSEY","NJ","NEW MEXICO","NM","NEW YORK","NY","NORTH CAROLINA","NC","NORTH DAKOTA","ND","NORTHERN MARIANA ISLANDS","MP",
            "OHIO","OH","OKLAHOMA","OK","OREGON","OR","PALAU","PW","PENNSYLVANIA","PA","PUERTO RICO","PR","RHODE ISLAND","RI","SOUTH CAROLINA","SC","SOUTH DAKOTA","SD","TENNESSEE","TN",
            "TEXAS","TX","UTAH","UT","VERMONT","VT","VIRGIN ISLANDS","VI","VIRGINIA","VA","WASHINGTON","WA","WEST VIRGINIA","WV","WISCONSIN","WI","WYOMING","WY");
states <- data.frame(name=states[(1:(length(states)/2))*2-1],abbrev=states[(1:(length(states)/2))*2])
states$name <- tolower(as.character(states$name))
states$abbrev <- as.character(states$abbrev)

## Code used to download data files, files needed some tweaking. Data files are
## available separately.
if (F) {
  URL <- "http://www.usatoday.com/news/politicselections/vote2004/PresidentialByCounty.aspx?oi=P&rti=G&sp=XX&tf=l"
  for (S in states$abbrev) {
    URL.s <- sub("XX",S,URL)

    cmdLine <- sprintf("/sw/bin/lynx -dump \"%s\" | /sw/bin/gawk '{if ($1==\"County\") output=1; if ($1==\"Updated:\") output=0; if (output) print $0; }' > %s.dat",URL.s,S)
    cat("Working on ",S,"\n");
    system(cmdLine)
  }
  ## Removed ' from .dat files
  ## Removed extra "County" names from NV.dat
}

## Remove states for which we don't have any data
states <- states[sapply(states$abbrev,function(X){file.exists(sprintf("%s.dat",X))}),]

## Prepare and read in data
election <- NULL
for (S in states$abbrev) {
  ## calls to gawk not necessary if csv files are downloaded.
  if (F) {
    cmdLine <- sprintf("/sw/bin/gawk -f prep.awk %s.dat > %s.csv",S,S);
    system(cmdLine)
  }
  tmp <- read.table(sprintf("%s.csv",S),header=T,sep=";")
  tmp$State <- states$name[states$abbrev==S]
  tmp$X <- NULL
  if (is.null(election)) {
    election <- tmp;
  } else {
    election <- rbind(election,tmp)
  }
}

## Create a column in which state and county is combined, as in the map database
election$stcounty <- tolower(paste(election$State,election$County,sep=","))
## Add a column (order) to the election df representing the order of
## counties in the map database
countyOrder <- data.frame(stcounty = counties$names,order=1:length(counties$names))
election <- merge(election,countyOrder)

## Determine size of county. (N.B., size is determined by number of voters,
## not by real number of inhabitants.)
election$size <- election$Bush+election$Kerry+election$Nader
election$sizeR <- election$size/max(election$size)

## Create a vector of colors, counties for which we don't have any data will
## be colored grey, others blue or red depending on who "won" that county.
col <- rep("grey",length(counties$names))
col[tmp$order] <- ifelse((tmp$Bush>tmp$Kerry),"red","blue")

## Add the county center coordinates to the election data.
county.coord <- map.center("county")
names(county.coord)[1] <- "stcounty";
election <- merge(election,county.coord)

## ---------------------------------------------------------------------------
##
## And finally, the actual plotting
##
## ---------------------------------------------------------------------------

## Real plot, only works when exporting to a recent enough version of PDF or
## Quartz. If you're using a device that can't handle transparancy, change
## the .4 and the .6 in the bluered function to 1.
pdf("US04Election-PopGraded.pdf",version="1.4",width=10,height=6.5)
## Draw the USA outline
map('usa',fill=T,col="white",bg="darkgray")
## Create the colors for the states
col <- rep(rgb(.1,.1,.1,.2),length(counties$names))
col[election$order] <- bluered(election$Bush,election$Kerry,.4,graded=T)
## Plot states without borders (should work with map, see help for fill
## argument, but cannot get it working)
m <- map('county',fill=T,plot=F)
polygon(m$x,m$y,col=col,border=NA)
## Draw county borders
map('county',col="darkgrey",add=T)
## Draw state borders
map('state',col="black",add=T,lwd=1)
## Color for circles
col <- bluered(election$Bush,election$Kerry,.6)
## Symbols is the easiest way to draw circles that have the right aspect ratio
symbols(election$x, election$y,circles=log(election$sizeR+1)*3,fg=col,bg=col,add=T,inches=F)
dev.off()

## Not sure which version I like more, the previous (with purple counties)
## or the next one, with blue/red counties.

## Real plot, only works when exporting to a recent enough version of PDF or Quartz.
pdf("US04Election-PopBin.pdf",version="1.4",width=10,height=6.5)
## Draw the USA outline
map('usa',fill=T,col="white",bg="darkgray")
## Create the colors for the states
col <- rep(rgb(.1,.1,.1,.2),length(counties$names))
col[election$order] <- bluered(election$Bush,election$Kerry,.4,graded=F)
## Plot states without borders (should work with map, see help for fill
## argument, but cannot get it working)
m <- map('county',fill=T,plot=F)
polygon(m$x,m$y,col=col,border=NA)
## Draw county borders
map('county',col="darkgrey",add=T)
## Draw state borders
map('state',col="black",add=T,lwd=2)
## Color for circles
col <- bluered(election$Bush,election$Kerry,.6)
## Symbols is the easiest way to draw circles that have the right aspect ratio
symbols(election$x, election$y,circles=log(election$sizeR+1)*3,fg=col,bg=col,add=T,inches=F)
dev.off()

## Plot without transparancy, but neutral states colored white. Made with
## help from Gregoire Thomas.

bluered <- function(B,K,S=1,graded=F) {
  if (graded) {
    ## Suggested by Gregoire Thomas:
    Kn <- K/(B+K)
    red   <- ifelse(Kn<0.5, 1, 2-2*Kn)
    blue  <- ifelse(Kn<0.5, 2*Kn, 1)
    green <- ifelse(Kn<0.5, blue, red)
    rgb(red, green, blue, S)
  } else {
    ## All or none
    ifelse(B>K,rgb(1,0,0,S),rgb(0,0,1,S))
  }
}

png("map3.png",width=600,height=400)
map('usa',fill=T,col="white",bg="darkgray")
## Create the colors for the states
col <- rep(rgb(.1,.1,.1,.2),length(counties$names))
col[election$order] <- bluered(election$Bush,election$Kerry,1,graded=T)
## Plot states without borders (should work with map, see help for fill
## argument, but cannot get it working)
m <- map('county',fill=T,plot=F)
polygon(m$x,m$y,col=col,border=NA)
## Draw county borders
map('county',col="darkgrey",add=T)
## Color for circles
col <- bluered(election$Bush,election$Kerry,1,graded=T)
## Symbols is the easiest way to draw circles that have the right aspect ratio
symbols(election$x, election$y,circles=log(election$sizeR+1)*3,fg=col,bg=col,add=T,inches=F)
##
col <- bluered(election$Bush,election$Kerry,1,graded=F)
## Symbols is the easiest way to draw circles that have the right aspect ratio
symbols(election$x, election$y,circles=log(election$sizeR+1)*3,fg=col,bg=NA,add=T,inches=F)
dev.off()

## ---------------------------------------------------------------------------
