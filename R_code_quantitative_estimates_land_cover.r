# R code for quantitative estimates of land cover

#recall library
library(raster)

#set working directory
setwd("C:/Users/marti/OneDrive/Documents/lab")

#brick
# first, list the files avaliable
rlist <- list.files(pattern= "defor")

# second, lapply() with the function brick to import entire satellite data
list_rast <- lapply(rlist, brick)

# plot the first element
plot(list_rast[[1]]) # plot every layers singularly 

#defor: NIR 1, red 2, green 3
plotRGB(list_rast[[1]], r=1, g=2, b=3, stretch= "Lin") 

#change names and plot
l1992 <- list_rast[[1]]
plotRGB(l1992, r=1, g=2, b=3, stretch= "Lin") 

l2006 <- list_rast[[2]]
plotRGB(l2006, r=1, g=2, b=3, stretch= "Lin") 

library(RStoolbox)

#unseprivised classification

