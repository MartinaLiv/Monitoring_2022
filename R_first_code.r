# This is my first code in github! Yayy

# Here are the input data

# Costanza data on streams
water <- c(100, 200, 300, 400, 500)

# Marta data on fishes genomes
fishes <- c(10, 50, 60, 100, 200)

# plot diversity of fishes (y) versus the amount of water (x)
plot(water, fishes)

# the data we developed can be stored in a table
# a table in R is called data frame

streams <- data.frame(water, fishes)

#set workingdirectory

getwd()
setwd("C:/Users/marti/OneDrive/Documents/lab/")

# export data!

write.table(streams, file = "my_first_table.txt")

#import

read.table("my_first_table.txt")

#let's assign it to an object in R

martinatable <- read.table("my_first_table.txt")

# the first statistics

summary(martinatable)

#if we want to get info only on fishes

summary(martinatable$fishes)

hist(martinatable$fishes)

hist(martinatable$water)
