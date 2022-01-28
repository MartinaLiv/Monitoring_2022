#represent distribution of an endogenous European crayfish (Austropotamobius pallipes) vs distribution of invasive Louisiana crawfish (Procambarus clarkii) in Europe

#set the working directory
setwd("/Users/marti/OneDrive/Documents/lab/exam/exam_monitoring")

#recall packages I want to use
library(dplyr)
library(maptools)
library(ggplot2)
library(rgbif)
library(sp)
library(raster)
library(patchwork)

#let's start with the autochthonous species
dat1 <- occ_search(scientificName = "Austropotamobius pallipes", limit = 5000, hasCoordinate = T) #search occurrences in gbif 
dat1 <- dat1$data   # trasnformation data in a tbl so that I can work on it with dplyr

dat1 # a lot of variables 

#let's select the variables of interest
dat1 <- dat1 %>%
  dplyr::select(species, decimalLongitude, decimalLatitude, countryCode, individualCount,
                gbifID, family, taxonRank, coordinateUncertaintyInMeters, year,
                basisOfRecord, institutionCode, datasetName)
                
#get a subset of the data that include only data on Latitude and Longitude to plot them on a map of EU
dat1_loc <- dat1 %>%
  dplyr::select(decimalLongitude, decimalLatitude)

#let's plot these data on the map
data("wrld_simpl") #map of the world

plot(wrld_simpl, xlim=c(-35,50), ylim=c(50,50)) #extent cut on EU
points(dat1_loc, pch=19, col= "darkgreen") #adding occurences of A. palipes

#let's do the same with the invasive species 
dat2 <- occ_search(scientificName = "Procambarus clarkii", limit = 5000, hasCoordinate = T)
dat2 <- dat2$data #to work with dplyr

#select only variables of interest
dat2 <- dat2 %>%
  dplyr::select(species, decimalLongitude, decimalLatitude, countryCode, individualCount,
                gbifID, family, taxonRank, coordinateUncertaintyInMeters, year,
                basisOfRecord, institutionCode, datasetName)

#get a subset for spatial representation
dat2_loc <- dat2 %>%
  dplyr::select(decimalLongitude, decimalLatitude)

#plot on the map
plot(wrld_simpl, xlim=c(-35,50), ylim=c(50,50)) #extent cut on EU
points(dat2_loc, pch= 17, col= "darkred")

#plot the two species on the same map
plot(wrld_simpl, xlim=c(-35,50), ylim=c(50,50))
points(dat1_loc, pch=16, col= "darkgreen") #A. pallipes
points(dat2_loc, pch= 17, col= "darkred")# P. clarkii
legend(x= -35, y=50, legend = c("A. pallipe", "P. clarkii"), col=c("darkgreen", "darkred"), pch = c(16, 17)) # add a legend to identify the two different species

#let's try to count the occurrences of the two species in Europe
t1 <- table(dat1$countryCode)
t2 <- table(dat2$countryCode)

#I want to do a barplot with ggplot so I need to trasform the data in df
ds1 <- as.data.frame(t1)
ds2 <- as.data.frame(t2)

bar_1 <- ggplot(ds1, aes(x= Var1, y=Freq))+ geom_bar(stat= "identity", fill= "darkgreen")+
  labs(x="Country Code", y="Occurrences", title = "Occurrences of A. pallipe in Europe") #barplot of A. pallipe
 
 bar_1
 
#for P.clarkii I have global data while data for A.pallipes were restricted to Europe, so I have to filter them

ds2 <- ds2 %>%
  filter(Var1 %in% c("AT", "CH", "ES", "FR", "GB", "IE", "IT", "LI", "NL"))

bar_2 <- ggplot(ds2, aes(x= Var1, y=Freq))+ geom_bar(stat= "identity", fill= "darkred")+
  labs(x="Country Code", y="Occurrences", title = "Occurrences of P.clarkii in Europe") #barplot of P. clarkii

#let's see the two barplots 
bar_1 + bar_2

#paper Gallardo et. al (2015) --> the importance of human footprint in shaping the distribution of freshwater invaders

#I want to add data on population density
pop_density_2020 <- raster("gpw_v4_population_density_rev11_2020_30_min.tif")
cl <- colorRampPalette(c('red ', 'orange', 'yellow'))(100)
plot(pop_density_2020, col=cl)

    
                

