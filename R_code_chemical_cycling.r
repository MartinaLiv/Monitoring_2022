# R code for chemical cycling study 
#time series of NO2 change in Europe during lockdown

#set the working directory and library
setwd("C:/Users/marti/OneDrive/Documents/lab/en")
library(raster)

#function raster create a RasterLayer object from a file
en01 <- raster("EN_0001.png")

#set a colour palette
cl <- colorRampPalette(c('red', 'orange', 'yellow'))(100)

#plot the NO2 values of January 2020 with the cl
plot(en01, col=cl)

#excercise: import the end of March NO2 and plot it
en13 <- raster("EN_0013.png")
plot(en13, col=cl)

#build a multiframe window with 2 rows and 1 column with par function
par(mfrow=c(2,1))
plot(en01, col=cl)
plot(en13, col=cl)

#import all images
en01 <- raster("EN_0001.png")
en02<- raster("EN_0002.png")
en03 <- raster("EN_0003.png")
en04 <- raster("EN_0004.png")
en05 <- raster("EN_0005.png")
en06 <- raster("EN_0006.png")
en07 <- raster("EN_0007.png")
en08 <- raster("EN_0008.png")
en09 <- raster("EN_0009.png")
en10 <- raster("EN_0010.png")
en11 <- raster("EN_0011.png")
en12 <- raster("EN_0012.png")
en13 <- raster("EN_0013.png")

#plot all data together
#first with the par function
par(mfrow=c(4,4))
plot(en01, col=cl)
plot(en02, col=cl)
plot(en03, col=cl)
plot(en04, col=cl)
plot(en05, col=cl)
plot(en06, col=cl)
plot(en07, col=cl)
plot(en08, col=cl)
plot(en09, col=cl)
plot(en10, col=cl)
plot(en11, col=cl)
plot(en12, col=cl)
plot(en13, col=cl)

#second making a stack and plot it
en <- stack(en01, en02, en03, en04, en05, en06, en07, en08, en09, en10, en11, en12, en13)
plot(en, col=cl)
dev.off()

#plot only the first image of the stack
plot(en$EN_0001, col=cl)

#rgb
plotRGB(en, r=1, g=7, b=13, stretch='Lin')
