require(effects)

data(Cowles)
mod.cowles <- glm(volunteer ~ sex + neuroticism*extraversion, 
    data=Cowles, family=binomial)
eff.cowles <- all.effects(mod.cowles, xlevels=list(neuroticism=0:24, 
    extraversion=seq(0, 24, 6)))
    
plot(eff.cowles, 'neuroticism:extraversion', ylab="Prob(Volunteer)",
    ticks=list(at=c(.1,.25,.5,.75,.9)))
