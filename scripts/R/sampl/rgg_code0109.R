library(stats)
library(quantreg)

##### Custom functions required ####################################
# Fuzzy-remanent growth curve with two different kinetic parameters
# passing by {0, 0}
# See Grosjean et al, 2003, Can. J. Fish. Aquat. Sci. 60:237-246,
# for definition and discussion of this growth model
fuzremOrig2 <- function (input, Asym, lrc1, lrc2, c0) {
    .expr1 <- exp(lrc1)
    .expr4 <- exp(-.expr1 * input)
    .expr5 <- 1 - .expr4
    .expr6 <- Asym * .expr5
    .expr7 <- exp(lrc2)
    .expr9 <- input - c0
    .expr11 <- exp(-.expr7 * .expr9)
    .expr12 <- 1 + .expr11
    .expr22 <- .expr12^2
    .value <- .expr6/.expr12
    .actualArgs <- as.list(match.call()[c("Asym", "lrc1", "lrc2", "c0")])
    if (all(unlist(lapply(.actualArgs, is.name)))) {
        .grad <- array(0, c(length(.value), 4),
            list(NULL, c("Asym", "lrc1", "lrc2", "c0")))
        .grad[, "Asym"] <- .expr5 / .expr12
        .grad[, "lrc1"] <- Asym * (.expr4 * (.expr1 * input)) / .expr12
        .grad[, "lrc2"] <- .expr6 * (.expr11 * (.expr7 * .expr9)) / .expr22
        .grad[, "c0"] <- -.expr6 * (.expr11 * .expr7) / .expr22
        dimnames(.grad) <- list(NULL, .actualArgs)
        attr(.value, "gradient") <- .grad
    }
    .value
}
# Self-starting function for fuzremOrig2
fuzremOrig2.ival <- function (mCall, data, LHS) {
    xy <- sortedXyData(mCall[["input"]], LHS, data)
    if (nrow(xy) < 5) {
        stop("Too few distinct input values to fit a fuzzy-remanent growth function with 2 kinetic parameter passing by {0, 0}")
    }
    xydata <- c(as.list(xy), c0 = NLSstClosestX(xy, mean(range(xy[["y"]]))))
    xydata <- as.list(xydata)
    options(show.error.messages = FALSE)
    # Sometimes, the following evaluation gives an error
    # (singular gradient, ...). Try another way to estimate initial parameters
    pars <- try(as.vector(coef(nls(y ~ (1 - exp(-exp(lrc) * x))/
        (1 + exp((c0 - x)*exp(lrc))), data = xydata, start = list(lrc = 0),
        algorithm = "plinear"))))
    if (!is.null(class(pars)) && class(pars) == "try-error") {
        cat("Using second alternative for initial parameters estimation\n")
        options(show.error.messages = TRUE)
        pars <- as.vector(coef(nls(y ~ SSlogis(x, Asym, xmid, scal),
            data = xydata)))
        xydata$c0 <- pars[2]
        pars[1] <- log(1/pars[3])
    } else { options(show.error.messages = TRUE)}
    pars <- as.vector(coef(nls(y ~ (1 - exp(-exp(lrc1) * x))/
        (1 + exp((c0 - x)*exp(lrc2))), data = data.frame(xy),
        start = list(c0 = xydata$c0, lrc1 = pars[1], lrc2 = pars[1]),
        algorithm = "plinear")))
    value <- c(pars[4], pars[2], pars[3], pars[1])
    names(value) <- mCall[c("Asym", "lrc1", "lrc2", "c0")]
    return(value)
}
# Self-Starting function, combining fuzremOrig2 and fuzremOrig2.ival
SSfuzremOrig2 <- selfStart(fuzremOrig2, fuzremOrig2.ival, para = "", template = "")
remove(fuzremOrig2, fuzremOrig2.ival)
attr(SSfuzremOrig2,"pnames") <- c("Asym", "lrc1", "lrc2", "c0")

# Expand a "class"-"frequencies at time" data frame into
# a "time"-"mean size in class" data frame
expandFreq <- function(ages, freqs) {
	for (i in 2:ncol(freqs)){
		size <- rep(freqs[, 1], freqs[, i])
		age <- rep(ages[i-1], length(size))
		if (i == 2){
			res <- cbind(age, size)
		} else {
			res <- rbind(res, cbind(age, size))
		}
	}
	res <- as.data.frame(res)
	return(res)
}

# Plot of size distributions, quantiles regressions and residuals diagnosis
# (boxplot) for curves tau = 0.05, 0.5 & 0.95 in the case of individual size
# distributions are known at each sampled time
rqFreqPlot <- function(ages, freqs, agecurves, curves, xlim = c(min(ages),
    max(ages)), ylim = c(min(curves), max(curves)), barscale = 100, barcol = 8,
    boxwex = 50, ylab1 = "", ylab2 = "", lty = c(2, 1, 2), ...) {
 	# Verify parameters ages and agecurves
	if (!all(ages %in% agecurves))
		stop("ages must be a subset of agecurves!")

	# Create a layout for the histograms and the boxplots
	nf <- layout(matrix(c(2,1),2,1,byrow = TRUE), widths = 7,
        heights = c(2, 5), respect = TRUE)
	layout.show(nf)
	par(mar = c(5, 4, 0, 2), lab = c(5, 5, 7))
	# Draw the curves
	par(new = FALSE)
	X <- matrix(rep(agecurves, ncol(curves)), nrow = length(agecurves),
        ncol = ncol(curves))
	Y <- curves
	matplot(X, Y, type = "l", xaxs = "i", lty = lty, col = 1, lwd = 2,
        bty = "l", xlim = xlim, ylim = ylim, ylab = ylab1, ...)
	# Draw the histograms
	for (i in 1:length(ages)){
		par(new = TRUE)
		xmin <- -ages[i] + xlim[1]
		xmax <- xlim[2] - ages[i]
		ser <- freqs[, i+1]
		ser <- ser/max(ser) * barscale
		barplot(ser, horiz = TRUE, axes = FALSE, xlim = c(xmin, xmax),
            ylim = ylim, col = barcol, space = 0)
	}
	# Add a residual analysis above the graph
	spreadCalc <- function(x, na.rm = FALSE){
		# Substract median from expanded frequencies data
		# And narrow range to 0.05 - 0.95 quantiles
		res <- x
		q <- quantile(res, c(0.05, 0.95), na.rm = na.rm)
		res[res < q[1]] <- q[1]
		res[res > q[2]] <- q[2]
		return(res)
	}
	## Expand one or several frequency columns into individual measurements
	expandFreq2 <- function(freqs) {
		# Consider mean size at each class for expanding the observations
		# with classes being first column and frequencies in each class
        # in the following columns
		# A list of vectors is returned
		res <- list(NULL)
		nCols <- ncol(freqs)
		for (i in 2:nCols)
			res[[i-1]] <- rep(freqs[, 1], freqs[, i])
		return(res)
	}

	# A modified boxplot.default() function with different parameters
    # (no box around the graph and plain lines for hinges)
	boxplot2 <- function (x, ..., range = 1.5, width = NULL, varwidth = FALSE,
        notch = FALSE, outline = TRUE, names, boxwex = 0.8, plot = TRUE,
        border = par("fg"), col = NULL, log = "", pars = NULL,
        horizontal = FALSE, add = FALSE, at = NULL) {
	    args <- list(x, ...)
	    namedargs <- if (!is.null(attributes(args)$names))
	        attributes(args)$names != ""
	    else rep(FALSE, length = length(args))
	    pars <- c(args[namedargs], pars)
	    groups <- if (is.list(x))
	        x
	    else args[!namedargs]
	    if (0 == (n <- length(groups)))
	        stop("invalid first argument")
	    if (length(class(groups)))
	        groups <- unclass(groups)
	    if (!missing(names))
	        attr(groups, "names") <- names
	    else {
	        if (is.null(attr(groups, "names")))
	            attr(groups, "names") <- 1:n
	        names <- attr(groups, "names")
	    }
	    for (i in 1:n) groups[i] <- list(boxplot.stats(groups[[i]], range))
	    stats <- matrix(0, nr = 5, nc = n)
	    conf <- matrix(0, nr = 2, nc = n)
	    ng <- out <- group <- numeric(0)
	    ct <- 1
	    for (i in groups) {
	        stats[, ct] <- i$stats
	        conf[, ct] <- i$conf
	        ng <- c(ng, i$n)
	        if ((lo <- length(i$out))) {
	            out <- c(out, i$out)
	            group <- c(group, rep(ct, lo))
	        }
	        ct <- ct + 1
	    }
	    z <- list(stats = stats, n = ng, conf = conf, out = out, group = group, names = names)
	    if (plot) {
	        bxp2(z, width, varwidth = varwidth, notch = notch, boxwex = boxwex, border = border, col = col, log = log, pars = pars, outline = outline, horizontal = horizontal, add = add, at = at)
	        invisible(z)
	    }
	    else z
	}

	# A modified bxp() function for plotting the boxplot generated by boxplot2()
	bxp2 <- function (z, notch = FALSE, width = NULL, varwidth = FALSE,
        outline = TRUE, notch.frac = 0.5, boxwex = 0.8, border = par("fg"),
        col = NULL, log = "", pars = NULL, frame.plot = axes,
        horizontal = FALSE, add = FALSE, at = NULL, show.names = NULL, ...) {
	    pars <- c(pars, list(...))
	    bplt <- function(x, wid, stats, out, conf, notch, border,
	        col, horizontal) {
	        if (!any(is.na(stats))) {
	            wid <- wid/2
	            if (notch) {
	                xx <- x + wid * c(-1, 1, 1, notch.frac, 1, 1,
	                  -1, -1, -notch.frac, -1)
	                yy <- c(stats[c(2, 2)], conf[1], stats[3], conf[2],
	                  stats[c(4, 4)], conf[2], stats[3], conf[1])
	            }
	            else {
	                xx <- x + wid * c(-1, 1, 1, -1)
	                yy <- stats[c(2, 2, 4, 4)]
	            }
	            if (!notch)
	                notch.frac <- 1
	            wntch <- notch.frac * wid
	            if (horizontal) {
	                polygon(yy, xx, col = col, border = border)
	                segments(stats[3], x - wntch, stats[3], x + wntch,
	                  col = border)
	                segments(stats[c(1, 5)], rep(x, 2), stats[c(2,
	                  4)], rep(x, 2), lty = 1, col = border)
	                segments(stats[c(1, 5)], rep(x - wid/2, 2), stats[c(1,
	                  5)], rep(x + wid/2, 2), col = border)
	                do.call("points", c(list(out, rep(x, length(out))),
	                  pt.pars))
	            }
	            else {
	                polygon(xx, yy, col = col, border = border)
	                segments(x - wntch, stats[3], x + wntch, stats[3],
	                  col = border)
	                segments(rep(x, 2), stats[c(1, 5)], rep(x, 2),
	                  stats[c(2, 4)], lty = 1, col = border)
	                segments(rep(x - wid/2, 2), stats[c(1, 5)], rep(x +
	                  wid/2, 2), stats[c(1, 5)], col = border)
	                do.call("points", c(list(rep(x, length(out)),
	                  out), pt.pars))
	            }
	            if (any(inf <- !is.finite(out))) {
	                warning(paste("Outlier (", paste(unique(out[inf]),
	                  collapse = ", "), ") in ", paste(x, c("st",
	                  "nd", "rd", "th")[pmin(4, x)], sep = ""), " boxplot are NOT drawn",
	                  sep = ""))
	            }
	        }
	    }
	    if (!is.list(z) || 0 == (n <- length(z$n)))
	        stop("invalid first argument")
	    if (is.null(at))
	        at <- 1:n
	    else if (length(at) != n)
	        stop(paste("`at' must have same length as `z $ n', i.e.",
	            n))
	    if (is.null(z$out))
	        z$out <- numeric()
	    if (is.null(z$group) || !outline)
	        z$group <- integer()
	    if (is.null(pars$ylim))
	        ylim <- range(z$stats[is.finite(z$stats)], z$out[is.finite(z$out)],
	            if (notch)
	                z$conf[is.finite(z$conf)])
	    else {
	        ylim <- pars$ylim
	        pars$ylim <- NULL
	    }
	    width <- if (!is.null(width)) {
	        if (length(width) != n | any(is.na(width)) | any(width <= 0))
	            stop("invalid boxplot widths")
	        boxwex * width/max(width)
	    }
	    else if (varwidth)
	        boxwex * sqrt(z$n/max(z$n))
	    else if (n == 1)
	        0.5 * boxwex
	    else rep(boxwex, n)
	    if (missing(border) || length(border) == 0)
	        border <- par("fg")
	    pt.pars <- c(pars[names(pars) %in% c("pch", "cex", "bg")],
	        col = border)
	    for (i in 1:n) bplt(at[i], wid = width[i], stats = z$stats[,
	        i], out = z$out[z$group == i], conf = z$conf[, i], notch = notch,
	        border = border[(i - 1)%%length(border) + 1], col = if (is.null(col))
	            col
	        else col[(i - 1)%%length(col) + 1], horizontal = horizontal)
	    invisible(at)
	}

	# Calculate and plot residuals
	baselevels <- curves[agecurves %in% ages, 2]
	expfreqs <- expandFreq2(freqs)
	for (i in 1:length(baselevels))
		expfreqs[[i]] <- expfreqs[[i]] - baselevels[i]
	# Draw it
	par(mar = c(1, 4, 1, 2), lab = c(5, 3, 7))
	matplot(X, Y - Y[, 2], type = "l", xaxs = "i", xaxt = "n", lty = lty,
        col = 1, lwd = 2, bty = "l", xlim = xlim, ylim = c(-12, 20),
        ylab = ylab2,...)
	# Some options cannot be changed in the original boxplot function!
    # So, we use our own implementation here
	boxplot2(lapply(expfreqs, spreadCalc), col = "gray90", boxwex = boxwex,
        range = 0, add = TRUE, at = ages)
	# Draw tick marks for the X axis
	axis(1, labels = FALSE)
}


### The example dataset ########################################################
# A contingency table of observed frequencies by size classes and ages
freqs <- structure(list(

MeanD = c(0.5, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5, 7.5,
        8.5, 9.5, 10.5, 11.5, 12.5, 13.5, 14.5, 15.5, 16.5, 17.5, 18.5,
        19.5, 20.5, 21.5, 22.5, 23.5, 24.5, 25.5, 26.5, 27.5, 28.5, 29.5,
        30.5, 31.5, 32.5, 33.5, 34.5, 35.5, 36.5, 37.5, 38.5, 39.5, 40.5,
        41.5, 42.5, 43.5, 44.5, 45.5, 46.5, 47.5, 48.5, 49.5, 50.5, 51.5,
        52.5, 53.5, 54.5, 55.5, 56.5, 57.5, 58.5, 59.5, 60.5, 61.5, 62.5,
        63.5, 64.5, 65.5, 66.5),

 F0.5y = c(65, 142, 114, 115, 65, 62,
        31, 34, 31, 20, 17, 18, 7, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        ),

 F1.0y = c(0, 11, 22, 19, 27, 32, 42, 46, 44, 38, 28, 22, 25,
        16, 16, 15, 23, 15, 13, 11, 5, 6, 10, 5, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),

 F1.5y = c(0, 0,
        0, 0, 0, 0, 0, 0, 2, 4, 6, 10, 22, 31, 30, 35, 29, 35, 25, 31,
        25, 14, 21, 27, 19, 17, 7, 8, 12, 3, 8, 7, 6, 8, 5, 7, 4, 3,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0),

 F2.0y = c(0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 2, 0, 3, 10, 6, 12, 20, 25, 26, 36, 36, 35, 10, 23,
        27, 18, 18, 16, 7, 4, 7, 7, 10, 9, 8, 7, 6, 11, 1, 2, 0, 1, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        ),

 F2.5y = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 1, 0, 0, 0, 2, 0, 5, 6, 15, 18, 15, 12, 23, 29, 22, 33, 23,
        17, 16, 19, 11, 15, 12, 13, 3, 16, 11, 12, 13, 10, 7, 3, 2, 1,
        2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),

 F3.0y = c(0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        1, 0, 0, 1, 0, 2, 1, 4, 9, 16, 9, 16, 9, 13, 17, 15, 13, 28,
        21, 22, 19, 14, 17, 12, 13, 10, 8, 11, 14, 8, 0, 0, 0, 1, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0),

 F3.5y = c(0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 5, 5, 9, 8, 19, 16, 17, 31, 28,
        24, 30, 22, 16, 15, 8, 13, 11, 12, 8, 4, 1, 2, 0, 0, 0, 0, 0,
        0, 0),

 F4.0y = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 1, 0, 0, 1, 8, 3, 1, 15, 13, 15, 16, 9, 34, 22, 22, 16, 6,
        14, 13, 8, 7, 2, 4, 2, 0, 1, 0, 0, 0, 0),

 F4.5y = c(0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 6,
        3, 7, 8, 9, 12, 21, 25, 28, 13, 21, 17, 9, 9, 5, 11, 7, 4, 2,
        0, 2, 0, 0),

 F5.0y = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 2, 3, 2, 2, 6, 10, 8, 10, 14, 16,
        19, 12, 9, 6, 5, 4, 0, 5, 1, 0, 0, 1, 0),

 F5.5y = c(0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0,
        2, 1, 4, 3, 1, 5, 6, 8, 12, 14, 10, 4, 6, 6, 3, 1, 3, 1, 1, 0,
        0, 0),

 F6.0y = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 2, 3, 2, 2, 3, 4, 7, 1, 13, 12,
        7, 8, 6, 5, 3, 1, 1, 0, 1, 2, 0),

 F6.5y = c(0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 3,
        0, 2, 1, 1, 5, 4, 8, 13, 7, 13, 7, 5, 4, 2, 1, 0, 2, 1, 0),

 F7.0y = c(0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,
        0, 0, 0, 1, 1, 1, 0, 2, 2, 2, 3, 12, 5, 11, 8, 5, 5, 2, 3, 1,
        0, 1, 0, 1)), 
Names = c("MeanD", "F0.5y", "F1.0y", "F1.5y",
        "F2.0y", "F2.5y", "F3.0y", "F3.5y", "F4.0y", "F4.5y", "F5.0y",
        "F5.5y", "F6.0y", "F6.5y", "F7.0y"),
        
class = "data.frame", row.names = c("1",
        "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13",
        "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24",
        "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35",
        "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46",
        "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57",
        "58", "59", "60", "61", "62", "63", "64", "65", "66", "67"))
# ages are the time at which these freqs are measured (in years)
ages <- c(0.49, 0.91, 1.41, 1.91, 2.41, 2.92, 3.42, 3.92, 4.41, 4.91,
         5.42, 5.91, 6.42, 6.91)
# To draw the curves, we use more data points on the time axis
agecurves <- c(0.00, 0.49, 0.76, 0.91, 1.17, 1.41, 1.66, 1.91, 2.16, 2.41, 2.67,
         2.92, 3.17, 3.42, 3.67, 3.92, 4.16, 4.41, 4.91, 5.42, 5.91, 6.42, 6.91)
# Since quantile() and nlrq() fonctions have no weight argument,
# we have to expand the data before using these functions
agesize <- expandFreq(ages, freqs)


### Here is the actual calculations and graph plotting ########################
# Quantile regressions for tau=0.05, 0.50 & 0.95 with the choosen growth model
rq.05 <- nlrq(size ~ SSfuzremOrig2(age, Asym, lrc1, lrc2, c0),
    data = agesize, tau = 0.05, trace = FALSE)
rq.50 <- nlrq(size ~ SSfuzremOrig2(age, Asym, lrc1, lrc2, c0),
    data = agesize, tau = 0.50, trace = FALSE)
rq.95 <- nlrq(size ~ SSfuzremOrig2(age, Asym, lrc1, lrc2, c0),
    data = agesize, tau = 0.95, trace = FALSE)
# Predict sizes with these three growth models
c.05 = predict(rq.05, newdata = list(age = agecurves))
c.50 = predict(rq.50, newdata = list(age = agecurves))
c.95 = predict(rq.95, newdata = list(age = agecurves))
curves = data.frame(c.05, c.50, c.95)
# Plot the graph (histograms with time, curves for the three quantile
# regressions and residuals as boxplots)
rqFreqPlot(ages, freqs, agecurves, curves, barscale = .35, barcol = "gray90",
    boxwex = .15, xlim = c(0, 7), ylim = c(0,67), main = "",
    xlab = expression(paste(italic("t"), " (years)")),
    ylab1 = expression(paste(italic("D"), " (mm)")),
    ylab2 = expression(paste(Delta, italic("D"), " (mm)")), las = 1, lty = 1)
title("Sea urchin growth modeled using quantile regression")
