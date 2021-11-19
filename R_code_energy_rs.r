# R code for estimating energy in ecosystems

#recall library raster
library(raster)

#set the working directory
setwd("C:/Users/marti/OneDrive/Documents/lab")

#importing data
l1992 <- brick("defor1_.jpg") #image of 1992
l1992

# Bands:  defor1_.1, defor1_.2, defor1_.3 
#plotRGB
plotRGB(L1992, r=1 , g=2 , b=3, stretch="Lin")
