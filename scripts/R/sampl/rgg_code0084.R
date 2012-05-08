require(party)

    data(airquality)
    airq <- subset(airquality, !is.na(Ozone))
    airct <- ctree(Ozone ~ ., data = airq, 
                   controls = ctree_control(maxsurrogate = 3))
    plot(airct)

