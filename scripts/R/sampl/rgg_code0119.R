require(vcd)

data(HairEyeColor)

## aggregate over 'sex':
(tab <- margin.table(HairEyeColor, c(2,1)))


## plot observed table:
sieve(tab, shade = TRUE)


