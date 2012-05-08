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
nc <- 3
make.table(nr, nc)
code <- c(300:307,310:317,320:327,330:337,340:347,350:357,360:367,370:377,
          243,263)
string <- c(
"\300","\301","\302","\303","\304","\305","\306","\307",
"\310","\311","\312","\313","\314","\315",
"\316","\317","\320","\321","\322","\323",
"\324","\325","\326","\327","\330","\331",
"\332","\333","\334","\335","\336","\337",
"\340","\341","\342","\343","\344","\345","\346","\347",
"\350","\351","\352","\353","\354","\355",
"\356","\357","\360","\361","\362","\363",
"\364","\365","\366","\367","\370","\371",
"\372","\373","\374","\375","\376","\377","\243","\263")
draw.title("Cyrillic Octal Codes", i = 0, nr ,nc)
for (i in 1:66)
    draw.vf.cell(tf, "cyrillic", string[i], i-1, nr,
                 raw.string=paste("\\", as.character(code[i]), sep=""))


