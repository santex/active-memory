library(ROCR)

# plot ROC curves for several cross-validation runs (dotted
# in grey), overlaid by the vertical average curve and boxplots
# showing the vertical spread around the average.
data(ROCR.xval)
pred <- prediction(ROCR.xval$predictions, ROCR.xval$labels)
perf <- performance(pred,"tpr","fpr")
plot(perf,col="grey82",lty=3)
plot(perf,lwd=1,avg="vertical",spread.estimate="boxplot",add=TRUE)

