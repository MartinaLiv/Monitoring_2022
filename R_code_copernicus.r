#R code for uploading and visualizing copernicus data

setwd()
install.packages("ncdf4")
library(ncdf4)

#upload data (single layer)
snow20211214 <- raster("c_gls_SCE_202112140000_NHEMI_VIIRS_V1.0.1.nc")

#plot
plot(snow20211214)
