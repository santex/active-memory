########################################################################
# M.H.Prager Function for a 4D contourplot
# email: mike.prager AT noaa.gov
# This function plots x and y versus two responses, z1 and z2
# Variable z1 is plotted as colored (or grayscale) contour areas with key
# Variable z2 is overlaid as heavy black contours with labels
# R language  April 8, 2005
# Revised considerably: June 29, 2006
# Last revision: October 18, 2006
########################################################################
plot4d <- function(x, y, z1, z2, nlev1 = 8, nlev2 = 8,
   keylab = deparse(substitute(z1)),
   main = paste("Black contours:", deparse(substitute(z2))),
   col.start = 0.0, col.stop = 0.8, col.sat = 0.35,
   use.color = TRUE, label.regions = FALSE,
   draw.grid = FALSE,
   xlab = deparse(substitute(x)),
   ylab = deparse(substitute(y))){
########################################################################
# ARGUMENT DEFINITIONS -- Most have Defaults (see arg list above)
#     x - x vector, dimension nx
#     y - y vector, dimension ny
#     z1 - response matrix 1, dimensions nx, ny
#     z2 - response matrix 2, dimensions nx, ny
#     NOTE: See contour() function help for relationships of x, y, z1 or z2
#     nlev1 - number of contour levels desired for colored contours of z1
#     nlev2 - number of contour levels desired for heavy contours of z2
#     keylab - text for colored-contour key (should be brief)
#     main - text for main title of plot
#     xlab, ylab - labels for x-axis and y-axis, respectively
#     col.start - starting value for rainbow of colors or grayscale
#     col.stop - ending value for rainbow of colors or grayscale
#     col.sat - saturation of colors
#     use.color - TRUE for rainbow, FALSE for grayscale
#     draw.grid - TRUE to overlay reference grid on contours
#     label.regions - TRUE to get numeric labels on filled contours
########################################################################
   levs <- pretty(z1, n = nlev1)    # Levels R will use for colored contours
   nlev1 <- length(levs)            # How many breaks are there?
   # Define colors for breaks:
   if (use.color) {
      cols = rainbow(n = nlev1-1, s = col.sat, v = 1, start = col.start,
         end = col.stop)
      } else {
      cols = gray(seq(from = col.start, to = col.stop, length = nlev1 - 1))
      }

   # Plot x-variable, y-variable, and first z-variable
   filled.contour(x, y, z1,
      main = main, font.main = 1, cex.main = 1.0,
      levels = levs, col = cols, xlab = xlab, ylab = ylab,
      key.title = {title(main = keylab, font.main = 1, cex.main = 1.0)},
      # Rest of plot is done within plot.axes to get scaling right
      plot.axes = {
         axis(side = 1)
         axis(side = 2)
         ### Add gray contour lines to color plot.
         contour(x, y, z1, add = TRUE, col = "gray40", lwd = 1,
            nlevels = nlev1, drawlabels = label.regions,
            lty = "solid", method = "edge", vfont = c("sans serif", "bold"))
         #### Plot second z-variable as heavy lines:
         contour(x, y, z2, add = TRUE, labcex = 1.1, lwd = 2,
         nlevels = nlev2, vfont = c("serif", "bold"))
         #### Add a light grid:
         if(draw.grid)  {
            grid(col="gray50")
            } else  {
            axis(side = 3, labels = FALSE, tcl = -0.3)
            axis(side = 4, labels = FALSE, tcl = -0.3)
            }

      }  # End of plot.axes
   )     # End of filled.contour call
}        # End of function (love those braces!)
########################################################################
### EXAMPLE CALL FOLLOWS:
### Load the saved data -- two vectors and two matrices:
download.file("http://addictedtor.free.fr/graphiques/data/90/4D.RData",
              "4D.RData", mode = "wb")
load("4D.RData")

my.title = paste("Black Sea Bass", 
                 "Colors = values of SPR",
                 "Black contours = values of YPR", sep = "\n")
plot4d(x = Fmort, y = a50, z1 = SPR, z2 = YPR, nlev1 = 8, nlev2 = 10,
   keylab = "SPR", main = my.title, col.start = 0.9, col.stop = 0.6,
   col.sat = 0.45, use.color = TRUE, label.regions = FALSE,
   xlab = "Full fishing mortality rate",
   ylab = "Age at 50% selection")

# Then in grayscale with different annotations:
#R> plot4d(x = Fmort, y = a50, z1 = SPR, z2 = YPR, nlev1 = 8, nlev2 = 10,
#R>    col.start = 1.0, col.stop = 0.3, use.color = FALSE, label.regions = FALSE)
#R> 
rm(my.title)
########################################################################


