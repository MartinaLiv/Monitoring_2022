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

