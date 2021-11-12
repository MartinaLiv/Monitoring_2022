# R code for ecosystem monitoring by remote sensing
# First of all, we need to install additional packages
# raster package to manage image data
# https://cran.r-project.org/web/packages/raster/index.html

install.packages("raster")

library(raster)

setwd("/Users/name/lab/")

# we are going to import satellite data
#brick function creates the raster file (image composed by pixels in which each pixel has a reflectance)

l2011 <- brick("p224r63_2011.grd")

#plot(l2011)

# B1 is the reflectance in the blue band
# B2 is the reflectance in the green band
# B3 is the reflectance in the red band

plot(l2011)

#change colour palette

cl <- colorRampPalette(c("black","gray","light gray"))(100) 

plot(l2011, col=cl)

plotRGB(l2011, r=3, g=2, b=1, stretch="Lin")

--------day2---------

# B1 is the reflectance in the blue band
# B2 is the reflectance in the green band
# B3 is the reflectance in the red band
#B4 is the reflectance in the yellow band

#each band has a specific name and we can see it in the info of the object

# let's plot the green band
plot(l2011$B2_sre)

cl <- colorRampPalette(c("black","gray","light gray"))(100) 

plot(l2011$B2_sre, col=cl)

# change the colorRampPaette with dark, green, and light green, e.g. clg

clg <- colorRampPalette(c("dark green", "green", "light green"))(100)
plot(l2011$B2_sre, col=clg)

#do the same for the blue band using "dark blue", "blue", and "light blue".

clb <- colorRampPalette(c("dark blue", "blue", "light blue"))(100)
plot(l2011$B1_sre, col=clb)

#plot both images in just one multiframe graph
par(mfrow=c(1,2))
plot(l2011$B2_sre, col=clg)
plot(l2011$B1_sre, col=clb)

#let's do the same but with 2 rows and 1 column
par(mfrow=c(2,1))
plot(l2011$B2_sre, col=clg)
plot(l2011$B1_sre, col=clb)

--------day3---------

plot(l2011$B1_sre)

#plot the blue band using a blue colorRampPalette
clb <- colorRampPalette(c("dark blue", "blue", "light blue"))(100)
plot(l2011$B1_sre, col=clb)

par(mfrow=c(1,2)) 

#plot the blue and the green besides, with different colorRampPalette
par(mfrow=c(1,2))
plot(l2011$B2_sre, col=clg)
plot(l2011$B1_sre, col=clb)

#plot the first four bands with two rows and two columns
clr <- colorRampPalette(c("dark red", "red", "pink"))(100)
clnir <- colorRampPalette(c("red", "orange", "yellow"))(100)

par(mfrow=c(2,2))
plot(l2011$B2_sre, col=clg)
plot(l2011$B1_sre, col=clb)
plot(l2011$B3_sre, col=clr)
plot(l2011$B4_sre, col=clnir)

#let's clean 
dev.off()

plotRGB(l2011, r=3, g=2, b=1, stretch= "Lin") #natural colours
plotRGB(l2011, r=4, g=3, b=2, stretch= "Lin") #false colours
plotRGB(l2011, r=3, g=4, b=2, stretch= "Lin") #false colours
plotRGB(l2011, r=3, g=2, b=4, stretch= "Lin") #false colours


par(mfrow=c(2,2))
plotRGB(l2011, r=3, g=2, b=1, stretch= "Lin") #natural colours
plotRGB(l2011, r=4, g=3, b=2, stretch= "Lin") #false colours
plotRGB(l2011, r=3, g=4, b=2, stretch= "Lin") #false colours
plotRGB(l2011, r=3, g=2, b=4, stretch= "Lin") #false colours




