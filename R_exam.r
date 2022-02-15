#represent distribution of an endogenous European crayfish (Austropotamobius pallipes) vs distribution of invasive Louisiana crawfish (Procambarus clarkii) in Europe
#create a model to represent the probability distribution of P. clarkii and A. pallipes in a Climate Change scenario. 


#set the working directory
setwd("/Users/marti/OneDrive/Documents/lab/exam/exam_monitoring/final")

#recall packages I want to use
library(dplyr)
library(maptools)
library(ggplot2)
library(rgbif)
library(sp)
library(raster)
library(RStoolbox)
library(viridis)
library(dismo)
library(rgdal)
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
legend(x= -37, y=50, legend = c("A. pallipes", "P. clarkii"), col=c("darkgreen", "darkred"), pch = c(16, 17)) # add a legend to identify the two different species

#let's try to count the occurrences of the two species in Europe
t1 <- table(dat1$countryCode)
t2 <- table(dat2$countryCode)

#I want to do a barplot with ggplot so I need to trasform the data in df
ds1 <- as.data.frame(t1)
ds2 <- as.data.frame(t2)

bar_1 <- ggplot(ds1, aes(x= Var1, y=Freq))+ geom_bar(stat= "identity", fill= "darkgreen")+
  labs(x="Country Code", y="Occurrences", title = "Occurrences of A. pallipes in Europe") #barplot of A. pallipe
 
 bar_1
 
#for P.clarkii I have global data while data for A.pallipes were restricted to Europe, so I have to filter them

ds2 <- ds2 %>%
  filter(Var1 %in% c("AT", "CH", "ES", "FR", "GB", "IE", "IT", "LI", "NL"))

bar_2 <- ggplot(ds2, aes(x= Var1, y=Freq))+ geom_bar(stat= "identity", fill= "darkred")+
  labs(x="Country Code", y="Occurrences", title = "Occurrences of P.clarkii in Europe") #barplot of P. clarkii

#let's see the two barplots 
bar_1 + bar_2

#Sdm 
#present climate data on WorldClim
# I selected Annual Mean Temperature and Annual Precipitation based on previous works
present.temperature <- raster("wc2.1_2.5m_bio_1.tif")
present.precipitation <- raster("wc2.1_2.5m_bio_12.tif")

#crop on Europe
ext <- c(-35, 50, 35, 75)
present.temperature <- crop(present.temperature, ext)
present.precipitation <- crop(present.precipitation, ext)

#future climate variable 2081-2100 Shared Socioeconomic Pathway 8.5 (RCP 8.5)
future.clim <- brick("wc2.1_2.5m_bioc_BCC-CSM2-MR_ssp585_2081-2100.tif")

#select variables of interest
future.temperature <- future.clim$wc2.1_2.5m_bioc_BCC.CSM2.MR_ssp585_2081.2100.1
future.precipitation <- future.clim$wc2.1_2.5m_bioc_BCC.CSM2.MR_ssp585_2081.2100.12

#crop them on Europe
future.temperature <- crop(future.temperature, ext)
future.precipitation <- crop(future.precipitation, ext)

#plot them
cl <- colorRampPalette(c('blue4','cyan',"chartreuse","orangered","darkred"))(100)
#plot together historical climatic variables and future climatic variables
par(mfrow=c(2,2))
plot(present.temperature, main= "Historical Annual mean temperature", col=cl)
plot(future.temperature, main ="Projected Annual mean temperature 2081-2100 ", col= cl)
plot(present.precipitation, main= "Historical Annual precipitation", col= cl)
plot(future.precipitation, main= "Projected Annual precipitation for 2081-2100", col=cl)

dev.off()

#compute the difference to see the change
diff_temperature <- future.temperature - present.temperature
diff_precipitation <- future.precipitation - present.precipitation

#plot the difference
cl1 <- colorRampPalette(c('red', 'orange', 'yellow'))(100)
cl2 <- colorRampPalette(c("cyan", "blue", "darkblue"))(100)

par(mfrow= c(1, 2))
plot(diff_temperature, main= "Difference in Annual mean temperature", col= cl1)
plot(diff_precipitation, main= "Difference in Annual precipitation", col= cl2)
dev.off()

#plot distribution of invasive species on Annual mean Temperature to have a first representation 
plot(present.temperature, main= "Historical Annual mean temperature", col=cl)
points(dat2_loc, pch= 17, col= "black")# P. clarkii
legend(x= -35, y=50, legend =  "P. clarkii", col= "black", pch = 17)

#let's see if the distribution of P. clarkii change because of climate change (hypothesis: expand?)
#MAXENT
#create  stacks with climatic variables
present <- stack(present.temperature, present.precipitation)
future <- stack(future.temperature, future.precipitation)
names(future) <- names(present) #assign the same name

#prepare occurrence data for the model
#remove erroneous coordinates
occ_clean <- subset(dat2, (!is.na(decimalLatitude)) & (!is.na(decimalLongitude)))
cat(nrow(dat2)- nrow(occ_clean), "records are removed") # 0 records removed

#remove duplicates
dups <- duplicated(occ_clean[c("decimalLatitude", "decimalLongitude")])
occ_unique <- occ_clean[!dups, ]
cat(nrow(occ_clean) - nrow(occ_unique), "records are removed") #949 records removed

#make occ spatial
coordinates(occ_unique) <- ~decimalLongitude + decimalLatitude

#look for erraneous points by plotting
plot(present[[1]]) #first layer representing temperature
plot(occ_unique, add= T) #plot occ on the above raster layer
#it seems there are no erranous points

#we want to use only one occurrence point per pixel so we need to thin our occurrence data
cells <- cellFromXY(present[[1]], occ_unique)
dups <- duplicated(cells)
occ_final <- occ_unique[!dups, ]
cat(nrow(occ_unique) - nrow(occ_final), "records are removed") #2969 records are removed!!

plot(present[[1]])
plot(occ_final, add= T, col= "red") #last look 

#create the model
model <- maxent(x=present, p= occ_final, ngb=20000)

#response curve: P of finding the species at those values of the variables
plot(model) #variable contribution: more mean annual temperature than precipitation
response(model) #P of occurrence on temperature and precipitation

#prediction with historical data
map_hist <- predict(model, present) # Probable suitability of P. clarkii based on historical conditions

#prediction with future data
map_future <- predict(model, future)#Probable suitability of P. clarkii based on projected future conditions

#save raster layers
writeRaster(map_hist, filename = "C:/Users/marti/OneDrive/Documents/lab/exam/exam_monitoring/final/present")
writeRaster(map_future, filename = "C:/Users/marti/OneDrive/Documents/lab/exam/exam_monitoring/final/future")


#plot
names(map_hist) <- "Probability"
p1 <- ggplot() + geom_raster(map_hist, mapping = aes(x = x, y = y, fill= Probability)) + scale_fill_viridis(option = "viridis", na.value = "transparent")+ theme_bw() + ggtitle("Present distribution probabilities of the Louisiana crawfish") + 
  labs(x = "Longitude", y = "Latitude")

plot(p1)

names(map_future) <- "Probability"
p2 <- ggplot() + geom_raster(map_future, mapping = aes(x = x, y = y, fill= Probability)) + scale_fill_viridis(option = "viridis", na.value = "transparent")+ theme_bw() + ggtitle("Future distribution probabilities of the Louisiana crawfish") + 
  labs(x = "Longitude", y = "Latitude") 

plot(p2)


#plot together
p1 + p2

#let's create also the model for A. pallipes to see if the distribution change (reduction?)
#prepare data for the model
occ_clean1 <- subset(dat1, (!is.na(decimalLatitude)) & (!is.na(decimalLongitude)))
cat(nrow(dat1)- nrow(occ_clean1), "records are removed") # 0 records removed

#remove duplicates
dups1 <- duplicated(occ_clean1[c("decimalLatitude", "decimalLongitude")])
occ_unique1 <- occ_clean1[!dups1, ]
cat(nrow(occ_clean1) - nrow(occ_unique1), "records are removed") #3241 records are removed

# make occ spatial
coordinates(occ_unique1) <- ~decimalLongitude + decimalLatitude

#look for erraneous points by plotting
plot(present[[1]]) #first layer: temperature
plot(occ_unique1, add= T) #plot occ on the above raster layer
#it seems there are no erranous points

#we want to use for the model only one occurrence point per pixel--> thin data
cells1 <- cellFromXY(present[[1]], occ_unique1)
dups1 <- duplicated(cells1)
occ_final1 <- occ_unique1[!dups1, ]
cat(nrow(occ_unique1) - nrow(occ_final1), "records are removed") #488 records are removed

plot(present[[1]])
plot(occ_final1, add= T, col= "darkgreen") #last look

#create the model
model1 <- maxent(x= present, p= occ_final1, ngb= 20000)

#response curve
plot(model1) #variable contribution: precipitation more than annual mean temperature
response(model1)#P of occurrence on temperature and precipitation

#prediction with historical data
map_hist1 <- predict(model1, present) #Probable suitability of A. pallipes based on historical conditions

#prediction with future data
map_future1 <- predict(model1, future) #Probable suitability of A. pallipes based on projected future conditions

#save raster layers
writeRaster(map_hist1, filename = "C:/Users/marti/OneDrive/Documents/lab/exam/exam_monitoring/final/present/present1")
writeRaster(map_future1, filename = "C:/Users/marti/OneDrive/Documents/lab/exam/exam_monitoring/final/future/future1")

#plot
names(map_hist1) <- "Probability"
p3 <- ggplot() + geom_raster(map_hist1, mapping = aes(x = x, y = y, fill= Probability)) + scale_fill_viridis(option = "plasma", na.value = "transparent")+ theme_bw() + ggtitle("Present distribution probabilities of European crayfish") + 
  labs(x = "Longitude", y = "Latitude")

plot(p3)

names(map_future1) <- "Probability"
p4 <- ggplot() + geom_raster(map_future1, mapping = aes(x = x, y = y, fill= Probability)) + scale_fill_viridis(option = "plasma", na.value = "transparent")+ theme_bw() + ggtitle("Future distribution probabilities of European crayfish") + 
  labs(x = "Longitude", y = "Latitude")

plot(p4)

#plot the two together
p3 + p4


#all plot together
patch1 <- p1 + p2
patch2 <- p3 + p4

patch1 / patch2



                

