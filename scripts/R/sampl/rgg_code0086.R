require(party)
require(ipred)

        data(GBSG2, package = "ipred")
        GBSG2ct <- ctree(Surv(time, cens) ~ .,data = GBSG2)
        plot(GBSG2ct)

