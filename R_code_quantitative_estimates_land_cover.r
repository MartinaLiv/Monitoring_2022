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
l1992c <- unsuperClass(l1992, nClasses=2) # unsuperClass(x, nClasses) 
l1992c

plot(l1992c$map)
# value 1 = forests 
# value 2 = agricultural areas and water

freq(l1992c$map)
#     value  count
#[1,]     1  306582
#[2,]     2  34710

# forest (class 1) = 306582
# agricultural areas and water (class 2) = 34710

total <- 341292
propagri <- 34710/total
propforest <- 306582/total

# agriculture and water: 0.1017018 ~ 0.10
# forest: 0.8982982 ~ 0.90

# build a dataframe
cover <- c("Forest", "Agriculture")
# prop1992 <- c(0.8982982, 0.1017018)
prop1992 <- c(propforest, propagri)

proportion1992 <- data.frame(cover, prop1992)

ggplot(proportion1992, aes(x=cover, y=prop1992, color=cover)) + geom_bar(stat="identity", fill="white")

# Classification of 2006
# Unsupervised classification
l2006c <- unsuperClass(l2006, nClasses=2) # unsuperClass(x, nClasses) 
l2006c

plot(l2006c$map)
# forest: value 1
# agriculture: value 2

# Frequencies
freq(l2006c$map)

#  value  count
#[1,]     1 179374 # forest
#[2,]     2 163352 # agriculture

# Proportions

total <- 342726
propagri2006 <- 163352/total
propforest2006 <- 179374/total

# build a dataframe
cover <- c("Forest", "Agriculture")
prop1992 <- c(propforest, propagri)
prop2006 <- c(propforest2006, propagri2006)

proportion <- data.frame(cover, prop1992, prop2006)

proportion
ggplot(proportion, aes(x=cover, y=prop2006, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1)
ggplot(proportion, aes(x=cover, y=prop1992, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1)

# plotting altogether

p1 <- ggplot(proportion, aes(x=cover, y=prop1992, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1)
p2 <- ggplot(proportion, aes(x=cover, y=prop2006, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1)

# plot two graphs with gridExtra package
grid.arrange(p1, p2, nrow=1)
# or with patchwork package:
p1+p2
# if you want to put one graph on top of the other:
p1/p2

# patchworkn is working even with raster data, but they should be plotted with the ggplot2 package
# instead of using plotRGB we are going to use ggRGB
# Common stuff:
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")
ggRGB(l1992, r=1, g=2, b=3)
ggRGB(l1992, r=1, g=2, b=3, stretch="lin")
ggRGB(l1992, r=1, g=2, b=3, stretch="hist")
ggRGB(l1992, r=1, g=2, b=3, stretch="sqrt")
ggRGB(l1992, r=1, g=2, b=3, stretch="log")

# patchwork
gp1 <- ggRGB(l1992, r=1, g=2, b=3, stretch="lin")
gp2 <- ggRGB(l1992, r=1, g=2, b=3, stretch="hist")
gp3 <- ggRGB(l1992, r=1, g=2, b=3, stretch="sqrt")
gp4 <- ggRGB(l1992, r=1, g=2, b=3, stretch="log")

gp1 + gp2 + gp3 + gp4

# multitemporal patchwork
gp1 <- ggRGB(l1992, r=1, g=2, b=3)
gp5 <- ggRGB(l2006, r=1, g=2, b=3)

gp1 + gp5
gp1 / gp5

