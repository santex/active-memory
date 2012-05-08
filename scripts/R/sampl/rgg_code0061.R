require(KernSmooth)
require(ellipse)
require(chplot)

data(hdr)
chplot(age~income|gender,data=hdr,log="x")

