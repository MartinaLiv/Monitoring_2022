#R code for species distribution modelling

install.packages("sdm")
library("sdm")
library("rgdal") # species 
library("raster") # predictors (env variables)
# or library(c(raster, rgdal))

#data 
file <- system.file("external/species.shp",package = "sdm")

#let's import the shapefile
species <- shapefile(file) # exactly  as the raster function for raster files

#how many occurrences are there? (values with 1)
presences <- species[species$Occurrence == 1 ,] #subset
absences <- species[species$Occurrence == 0 ,] #subset

#plot!
plot(species, pch= 19)

#plot presences and absences
plot(presences, pch=19, col= "blue")
points(absences, pch=19, col= "red")

# let's look at the predictors
path <- system.file("external", package = "sdm") #let's find the path where the predictors are
#extention of predictors is .asc
#let's make a list of predictors
lst_predictors <- list.files(path, pattern = "asc", full.names = T)

#you can use the lapply fuction with the raster function to do the job but in this case we can use stack because the file are already in R
preds <- stack(lst_predictors)

#plot preds
cl <- colorRampPalette(c("blue", "orange", "yellow")(100))
plot(preds, col=cl)

#plot elevation and presences
plot(preds$elevation, col=cl)
points(presences, pch=19)

#plot temperature and presences
plot(preds$temperature, col=cl)
points(presences, pch=19)

#veg and presences
plot(preds$vegetation, col=cl)
points(presences, pch=19)

#precipitation and presence
plot(preds$precipitation, col=cl)
points(presences, pch=19)

#day2
#upload script with the function source
setwd("C:/Users/marti/OneDrive/Documents/lab/")
source("R_code_source_sdm.r")

preds # elevation, precipitation, temperature, vegetation 

#model
#we have to explain to the software which are the data we are going to use
datasdm <- sdmData(train=species, predictors=preds)

#generalized linear model
m1 <- sdm(Occurrence~temperature+elevation+precipitation+vegetation, data=datasdm, methods= "glm") # we put the y (Occurrence) and xs (preds) and then the model will calculate the intercept and the slope. 

#prediction: build the final map 
p1 <- predict(m1, newdata=preds)
plot(p1, col=cl)

#add to the stack
s1 <- stack(preds, p1)
#change the name of a dataset with the function names()
names(s1) <- c("elevation", "precipitation", "temperature", "vegetation", "model")


