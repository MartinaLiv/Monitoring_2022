#R code for species distribution modelling
install.packages("sdm")
library("sdm")
library("rgdal")
library("raster")

#data 
file <- system.file("external/species.shp",package = "sdm")

#let's import the shapefile
species <- shapefile(file)

#plot
plot(species, pch= 19, col= "blue")
