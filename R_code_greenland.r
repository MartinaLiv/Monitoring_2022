# R_code_greenland.r

# Time series analysis
# Greenland increase of temperature
# Data and code from Emanuela Cosma

# install.packages("raster")
# install.packages("rasterVis")
library(raster)
#library(rasterVis) 
library(patchwork)
# library(rgdal)

setwd("~/lab/greenland") # Linux
# setwd("C:/lab/greenland") # Windows
# setwd("/Users/name/Desktop/lab/greenland") # Mac 

# list f files:
rlist <- list.files(pattern="lst")
rlist

import <- lapply(rlist,raster)
import

TGr <- stack(import)
TGr
plot(TGr)

#levelplot(TGr)
cl <- colorRampPalette(c("blue","light blue","pink","red"))(100)
plot(TGr, col=cl)

plot(TGr,col=cl, names.attr=c("July 2000","July 2005", "July 2010", "July 2015"))

plot(TGr,col.regions=cl, main="LST variation in time", names.attr=c("July 2000","July 2005", "July 2010", "July 2015"))

p1 <- ggplot() + 
geom_raster(TGr$lst_2000, mapping = aes(x=x, y=y, fill=lst_2000)) +
scale_fill_viridis(option="magma") 
# ggtitle("cividis palette")

p2 <- ggplot() + 
geom_raster(TGr$lst_2015, mapping = aes(x=x, y=y, fill=lst_2015)) +
scale_fill_viridis(option="magma") 

p1+p2

# stats

plot(TGr$lst_2000, TGr$lst_2015)
abline(0,1,col="red")

pairs(TGr)
