



n <- scan('http://addictedtor.free.fr/graphiques/tools/nextGraph.php', quiet = TRUE) - 1
for(i in 1:n){
    download.file(sprintf('http://addictedtor.free.fr/graphiques/sources/source_%d.R', i),
        sprintf('rgg_code%04d.R', i))
}
