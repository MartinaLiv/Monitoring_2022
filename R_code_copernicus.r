#R code for uploading and visualizing copernicus data

setwd()
install.packages("ncdf4")
library(ncdf4)

#upload data (single layer)
snow20211214 <- raster("c_gls_SCE_202112140000_NHEMI_VIIRS_V1.0.1.nc")

#plot
plot(snow20211214)
cl <- colorRampPalette(c("dark blue", "blue", "light blue"))(100)
plot(snow20211214, col=cl)

#viridis package is used to change colour in maps
install.packages("viridis")
library(viridis)

#additional libraries
library(RStoolbox)
library(ggplot2)

#ggplot() open an empty window and then we need to add a geom_raster which is the geometrical frame we want to use, in this case an image (raster)
ggplot() +
geom_raster(snow20211214, mapping = aes(x = x, y = y, fill = Snow.Cover.Extent))

#ggplot function with viridis
ggplot() +
geom_raster(snow20211214, mapping = aes(x = x, y = y, fill = Snow.Cover.Extent)) + 
scale_fill_viridis() 

#same but with a different legend of viridis
ggplot() +
geom_raster(snow20211214, mapping = aes(x = x, y = y, fill = Snow.Cover.Extent)) + 
scale_fill_viridis(option="cividis") 
#add title
ggplot() +
geom_raster(snow20211214, mapping = aes(x = x, y = y, fill = Snow.Cover.Extent)) + 
scale_fill_viridis(option="cividis") +
ggtitle("cividis palette")

#---day2---
#set wd and recall libraries
#lapply function apply a function to a set of objects
rlist <- list.files(pattern = "SCE")#create a list with all the objects with the pattern chosen
list_rast <- lapply(rlist, raster)#lapply function
snow_stack <- stack(list_rast)#make a stack

#rename objects
ssummer<- snow_stack$Snow.Cover.Extent.1
swinter<- snow_stack$Snow.Cover.Extent.2 

#ggplot
p1 <- ggplot()+
geom_raster(ssummer, mapping = aes(x=x, y=y, fill=Snow.Cover.Extent.1))+
scale_fill_viridis(option= "viridis")+
ggtitle("Snow cover during summer")

p2 <- ggplot()+
geom_raster(swinter, mapping = aes(x=x, y=y, fill=Snow.Cover.Extent.2))+
scale_fill_viridis(option= "viridis")+
ggtitle("Snow cover during winter")

#patchwork them together
#library patchwork
p1/p2 #one image on top of the other

#how to crop the image on a certain area-> coordinates
#we want to zoom on italy
#longitude from 0 to 20
#latitude from 30 to 50
ext <- c(0, 20, 30, 50)
ssummer_cropped <- crop(ssummer, ext)
swinter_cropped <- crop(swinter, ext)
#stack_cropped <- crop(snow_stack, ext)

#ggplot cropped
p1 <- ggplot()+
geom_raster(ssummer_cropped, mapping = aes(x=x, y=y, fill=Snow.Cover.Extent.1))+
scale_fill_viridis(option= "viridis")+
ggtitle("Snow cover during summer")

p2 <- ggplot()+
geom_raster(swinter_cropped, mapping = aes(x=x, y=y, fill=Snow.Cover.Extent.2))+
scale_fill_viridis(option= "viridis")+
ggtitle("Snow cover during winter")

p1/p2
                 


