#Fourfold display

data(UCBAdmissions)
x <- aperm(UCBAdmissions, c(2, 1, 3))
dimnames(x)[[2]] <- c("Yes", "No")
names(dimnames(x)) <- c("Sex", "Admit?", "Department")

fourfoldplot(x[,,1:4])

