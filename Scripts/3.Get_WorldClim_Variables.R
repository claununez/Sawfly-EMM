#####
# Project: Climatic suitability and invasion risk of the elm zigzag sawfly in North America
# Authors: Claudia Nuñez-Penichet, Zenia P. Ruiz-Utrilla, Daniel Rojas-Ariza, 
#          Weverton C. F. Trindade, Joanna L. Corimanya, Andres Herrera, 
#     
# Downloading climatic variables from Worldclim 2.1
#####

# data needed 
## Shapefile of area of interest in case you want to crop the environmental 
# variables 

#Installing packages
install.packages("terra")
library(terra)

install.packages("geodata")
library(geodata)

# Setting working directory
setwd("Working directory")  
# Change this to the folder of this project

# Calling functions (it have to be on the same working directory)
source("Functions.R")

# Getting the variables at 2.5 min
# Current
cvars <- get_NWC_bio(period = "historical", res = "2.5m", time = NULL, 
                     SSP = NULL, GCM = NULL, output_dir = "Variables") 

vars <- list.files("variables/wc2.1_2.5m_bio/", pattern = ".tif", full.names = TRUE)
vars

#discarded bio8-9, bio18-19 because combine T and precipitation variables
selected <- c(1:9, 12:17)

var_stack <- terra::rast(vars[selected])

# We will calibrate our models for sawfly using Japan only, Japan + East Asia, and
# Japan + East Asia + Europe. For Ulmus we used North America
# The code below is exemplifying with Japan what we did for all calibration areas

#Reading shapefile to crop the variables to area of interest
shp_japan <- vect("Working directory/Japan.shp")
plot(shp_japan)

# Cropping the variables
var <- terra::crop(var_stack, shp_japan, mask = T)

# Modifying variable names (bio5, bio6, bio13, bio14, etc)
name <- names(var)
name1 <- gsub("wc2.1_2.5m_", "", name) 

names(var) <- name1
# Creating the path for saving cropped variables
dir.create("wc2.1_2.5m_bio_crop")
var_name <- paste0("Variables/wc2.1_2.5m_bio_crop/", name1, ".tif")

# Writing the cropped variables
for (i in 1:length(var_name)){
  writeRaster(var[[i]], var_name[i], overwrite = TRUE)
}

# The process above was repeated for the other two calibration areas of sawfly
# (Japan + East Asia, and Japan + East Asia + Europe), and for the calibration
# area used for Ulmus (North America).