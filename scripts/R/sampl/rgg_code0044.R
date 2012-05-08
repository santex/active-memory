require(scatterplot3d)
data(trees)
s3d <- scatterplot3d(trees, type="h", highlight.3d=TRUE, 
                     angle=55, scale.y=0.7, pch=16, main="scatterplot3d - 5")
        
# Now adding some points to the "scatterplot3d"
s3d$points3d(seq(10,20,2), seq(85,60,-5), seq(60,10,-10), 
             col="blue", type="h", pch=16)        

# Now adding a regression plane to the "scatterplot3d"
attach(trees)
my.lm <- lm(Volume ~ Girth + Height)
s3d$plane3d(my.lm)

