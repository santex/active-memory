## --- Hershey Vector Fonts

######
# create tables of vector font functionality
######
make.table <- function(nr, nc) {
    savepar <- par(mar=rep(0, 4), pty="s")
    plot(c(0, nc*2 + 1), c(0, -(nr + 1)),
         type="n", xlab="", ylab="", axes=FALSE)
    savepar
}

get.r <- function(i, nr)     i %% nr + 1
get.c <- function(i, nr)     i %/% nr + 1

draw.title <- function(title, i = 0, nr, nc) {
    r <- get.r(i, nr)
    c <- get.c(i, nr)
    text((nc*2 + 1)/2, 0, title, font=2)
}

draw.sample.cell <- function(typeface, fontindex, string, i, nr) {
    r <- get.r(i, nr)
    c <- get.c(i, nr)
    text(2*(c - 1) + 1, -r, paste(typeface, fontindex))
    text(2*c, -r, string, vfont=c(typeface, fontindex), cex=1.5)
    rect(2*(c - 1) + .5, -(r - .5), 2*c + .5, -(r + .5), border="grey")
}

draw.vf.cell <- function(typeface, fontindex, string, i, nr, raw.string=NULL) {
    r <- get.r(i, nr)
    c <- get.c(i, nr)
    if (is.null(raw.string))
        raw.string <- paste("\\", string, sep="")
    text(2*(c - 1) + 1, -r, raw.string, col="grey")
    text(2*c, -r, string, vfont=c(typeface, fontindex))
    rect(2*(c - 1) + .5, -(r - .5), (2*c + .5), -(r + .5), border="grey")
}

nr <- 25
nc <- 4
make.table(nr, nc)
i <- 0
draw.title("ISO Latin-1 Escape Sequences", i, nr, nc)
draw.vf.cell(tf, fi, "\\r!", i, nr); i<-i+1; { "exclamdown"}
draw.vf.cell(tf, fi, "\\ct", i, nr); i<-i+1; { "cent"}
draw.vf.cell(tf, fi, "\\Po", i, nr); i<-i+1; { "sterling"}
draw.vf.cell(tf, fi, "\\Ye", i, nr); i<-i+1; { "yen"}
draw.vf.cell(tf, fi, "\\bb", i, nr); i<-i+1; { "brokenbar"}
draw.vf.cell(tf, fi, "\\sc", i, nr); i<-i+1; { "section"}
draw.vf.cell(tf, fi, "\\ad", i, nr); i<-i+1; { "dieresis"}
draw.vf.cell(tf, fi, "\\co", i, nr); i<-i+1; { "copyright"}
draw.vf.cell(tf, fi, "\\Of", i, nr); i<-i+1; { "ordfeminine"}
draw.vf.cell(tf, fi, "\\no", i, nr); i<-i+1; { "logicalnot"}
draw.vf.cell(tf, fi, "\\hy", i, nr); i<-i+1; { "hyphen"}
draw.vf.cell(tf, fi, "\\rg", i, nr); i<-i+1; { "registered"}
draw.vf.cell(tf, fi, "\\a-", i, nr); i<-i+1; { "macron"}
draw.vf.cell(tf, fi, "\\de", i, nr); i<-i+1; { "degree"}
draw.vf.cell(tf, fi, "\\+-", i, nr); i<-i+1; { "plusminus"}
draw.vf.cell(tf, fi, "\\S2", i, nr); i<-i+1; { "twosuperior"}
draw.vf.cell(tf, fi, "\\S3", i, nr); i<-i+1; { "threesuperior"}
draw.vf.cell(tf, fi, "\\aa", i, nr); i<-i+1; { "acute"}
draw.vf.cell(tf, fi, "\\*m", i, nr); i<-i+1; { "mu"}
draw.vf.cell(tf, fi, "\\md", i, nr); i<-i+1; { "periodcentered"}
draw.vf.cell(tf, fi, "\\S1", i, nr); i<-i+1; { "onesuperior"}
draw.vf.cell(tf, fi, "\\Om", i, nr); i<-i+1; { "ordmasculine"}
draw.vf.cell(tf, fi, "\\14", i, nr); i<-i+1; { "onequarter"}
draw.vf.cell(tf, fi, "\\12", i, nr); i<-i+1; { "onehalf"}
draw.vf.cell(tf, fi, "\\34", i, nr); i<-i+1; { "threequarters"}
draw.vf.cell(tf, fi, "\\r?", i, nr); i<-i+1; { "questiondown"}
draw.vf.cell(tf, fi, "\\`A", i, nr); i<-i+1; { "Agrave"}
draw.vf.cell(tf, fi, "\\'A", i, nr); i<-i+1; { "Aacute"}
draw.vf.cell(tf, fi, "\\^A", i, nr); i<-i+1; { "Acircumflex"}
draw.vf.cell(tf, fi, "\\~A", i, nr); i<-i+1; { "Atilde"}
draw.vf.cell(tf, fi, "\\:A", i, nr); i<-i+1; { "Adieresis"}
draw.vf.cell(tf, fi, "\\oA", i, nr); i<-i+1; { "Aring"}
draw.vf.cell(tf, fi, "\\AE", i, nr); i<-i+1; { "AE"}
draw.vf.cell(tf, fi, "\\,C", i, nr); i<-i+1; { "Ccedilla"}
draw.vf.cell(tf, fi, "\\`E", i, nr); i<-i+1; { "Egrave"}
draw.vf.cell(tf, fi, "\\'E", i, nr); i<-i+1; { "Eacute"}
draw.vf.cell(tf, fi, "\\^E", i, nr); i<-i+1; { "Ecircumflex"}
draw.vf.cell(tf, fi, "\\:E", i, nr); i<-i+1; { "Edieresis"}
draw.vf.cell(tf, fi, "\\`I", i, nr); i<-i+1; { "Igrave"}
draw.vf.cell(tf, fi, "\\'I", i, nr); i<-i+1; { "Iacute"}
draw.vf.cell(tf, fi, "\\^I", i, nr); i<-i+1; { "Icircumflex"}
draw.vf.cell(tf, fi, "\\:I", i, nr); i<-i+1; { "Idieresis"}
draw.vf.cell(tf, fi, "\\~N", i, nr); i<-i+1; { "Ntilde"}
draw.vf.cell(tf, fi, "\\`O", i, nr); i<-i+1; { "Ograve"}
draw.vf.cell(tf, fi, "\\'O", i, nr); i<-i+1; { "Oacute"}
draw.vf.cell(tf, fi, "\\^O", i, nr); i<-i+1; { "Ocircumflex"}
draw.vf.cell(tf, fi, "\\~O", i, nr); i<-i+1; { "Otilde"}
draw.vf.cell(tf, fi, "\\:O", i, nr); i<-i+1; { "Odieresis"}
draw.vf.cell(tf, fi, "\\mu", i, nr); i<-i+1; { "multiply"}
draw.vf.cell(tf, fi, "\\/O", i, nr); i<-i+1; { "Oslash"}
draw.vf.cell(tf, fi, "\\`U", i, nr); i<-i+1; { "Ugrave"}
draw.vf.cell(tf, fi, "\\'U", i, nr); i<-i+1; { "Uacute"}
draw.vf.cell(tf, fi, "\\^U", i, nr); i<-i+1; { "Ucircumflex"}
draw.vf.cell(tf, fi, "\\:U", i, nr); i<-i+1; { "Udieresis"}
draw.vf.cell(tf, fi, "\\'Y", i, nr); i<-i+1; { "Yacute"}
draw.vf.cell(tf, fi, "\\ss", i, nr); i<-i+1; { "germandbls"} # WRONG!
draw.vf.cell(tf, fi, "\\`a", i, nr); i<-i+1; { "agrave"}
draw.vf.cell(tf, fi, "\\'a", i, nr); i<-i+1; { "aacute"}
draw.vf.cell(tf, fi, "\\^a", i, nr); i<-i+1; { "acircumflex"}
draw.vf.cell(tf, fi, "\\~a", i, nr); i<-i+1; { "atilde"}
draw.vf.cell(tf, fi, "\\:a", i, nr); i<-i+1; { "adieresis"}
draw.vf.cell(tf, fi, "\\oa", i, nr); i<-i+1; { "aring"}
draw.vf.cell(tf, fi, "\\ae", i, nr); i<-i+1; { "ae"}
draw.vf.cell(tf, fi, "\\,c", i, nr); i<-i+1; { "ccedilla"}
draw.vf.cell(tf, fi, "\\`e", i, nr); i<-i+1; { "egrave"}
draw.vf.cell(tf, fi, "\\'e", i, nr); i<-i+1; { "eacute"}
draw.vf.cell(tf, fi, "\\^e", i, nr); i<-i+1; { "ecircumflex"}
draw.vf.cell(tf, fi, "\\:e", i, nr); i<-i+1; { "edieresis"}
draw.vf.cell(tf, fi, "\\`i", i, nr); i<-i+1; { "igrave"}
draw.vf.cell(tf, fi, "\\'i", i, nr); i<-i+1; { "iacute"}
draw.vf.cell(tf, fi, "\\^i", i, nr); i<-i+1; { "icircumflex"}
draw.vf.cell(tf, fi, "\\:i", i, nr); i<-i+1; { "idieresis"}
draw.vf.cell(tf, fi, "\\~n", i, nr); i<-i+1; { "ntilde"}
draw.vf.cell(tf, fi, "\\`o", i, nr); i<-i+1; { "ograve"}
draw.vf.cell(tf, fi, "\\'o", i, nr); i<-i+1; { "oacute"}
draw.vf.cell(tf, fi, "\\^o", i, nr); i<-i+1; { "ocircumflex"}
draw.vf.cell(tf, fi, "\\~o", i, nr); i<-i+1; { "otilde"}
draw.vf.cell(tf, fi, "\\:o", i, nr); i<-i+1; { "odieresis"}
draw.vf.cell(tf, fi, "\\di", i, nr); i<-i+1; { "divide"}
draw.vf.cell(tf, fi, "\\/o", i, nr); i<-i+1; { "oslash"}
draw.vf.cell(tf, fi, "\\`u", i, nr); i<-i+1; { "ugrave"}
draw.vf.cell(tf, fi, "\\'u", i, nr); i<-i+1; { "uacute"}
draw.vf.cell(tf, fi, "\\^u", i, nr); i<-i+1; { "ucircumflex"}
draw.vf.cell(tf, fi, "\\:u", i, nr); i<-i+1; { "udieresis"}
draw.vf.cell(tf, fi, "\\'y", i, nr); i<-i+1; { "yacute"}
draw.vf.cell(tf, fi, "\\:y", i, nr); i<-i+1; { "ydieresis"}

