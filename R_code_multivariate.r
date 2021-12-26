# R code for measuring community interactions
install.pakage("vegan")
library(vegan)

#let's load a dataset
load("biomes_multivar.RData")
ls()

#multivariate analysis dca
multivar <- decorana(biomes)

#let's plot
plot(multivar)

#biomes names in the graph: are species in the same biomes?
attach(biomes_types)
ordiellipse(multivar, type, col=c("black", "red", "green", "blue"), kind = "ehull", lwd=3)
ordispider(multivar, type, col=c("black", "red", "green", "blue"), label = T)
