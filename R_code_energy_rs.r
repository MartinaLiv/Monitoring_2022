# R code for estimating energy in ecosystems

#recall library raster
library(raster)

#install.package "rgdal"

#set the working directory
setwd("C:/Users/marti/OneDrive/Documents/lab")

#importing data
l1992 <- brick("defor1_.jpg") #image of 1992
l1992

# Bands:  defor1_.1, defor1_.2, defor1_.3 
#plotRGB
plotRGB(l1992, r=1 , g=2 , b=3, stretch="Lin")

#defor1_.1= NIR (only thing we know for sure because all vegetation reflects red)
#defor1_.2= red
#defor1_.3= green


#day2

l2006 <- brick("defor2_.jpg") #image of 2006

# plotting the imported image of 2006
plotRGB(l2006, r=1, g=2, b=3, stretch="Lin")

#par two images

par(mfrow=c(2,1))
plotRGB(l1992, r=1 , g=2 , b=3, stretch="Lin")
plotRGB(l2006, r=1, g=2, b=3, stretch="Lin")

# let's calculate energy in 1992
dev.off()
l1992
dvi1992 <- l1992$defor1_.1 - l1992$defor1_.2
cl <- colorRampPalette(c("darkblue", "yellow", "red", "black"))(100)
plot(dvi1992, col=cl)

#let's calculate energy in 2006
l2006
dvi2006 <- l2006$defor2_.1 - l2006$defor2_.2
plot(dvi2006, col=cl)

#differencing two images of energy in two different times
dvidif <- dvi1992 - dvi2006
cld <- colorRampPalette(c("blue", "white", "red"))(100)
plot(dvidif, col=cld)

#final plot: original images, dvis, final dvi differences
par(mfrow=c(3,2))
plotRGB(l1992, r=1 , g=2 , b=3, stretch="Lin")
plotRGB(l2006, r=1, g=2, b=3, stretch="Lin")
plot(dvi1992, col=cl)
plot(dvi2006, col=cl)
plot(dvidif, col=cld)

#let's create a pdf
pdf("energy.pdf")
par(mfrow=c(3,2))
plotRGB(l1992, r=1 , g=2 , b=3, stretch="Lin")
plotRGB(l2006, r=1, g=2, b=3, stretch="Lin")
plot(dvi1992, col=cl)
plot(dvi2006, col=cl)
plot(dvidif, col=cld)
    
