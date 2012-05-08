data(votes.repub)
votes.diss <- daisy(votes.repub)
votes.clus <- pam(votes.diss, 2, diss = TRUE)$clustering
clusplot(votes.diss, votes.clus, diss = TRUE, shade = TRUE)

