#####
# Project: Climatic suitability and invasion risk of the elm zigzag sawfly in North America
# Authors: Claudia Nuñez-Penichet, Zenia P. Ruiz-Utrilla, Daniel Rojas-Ariza, 
#          Weverton C. F. Trindade, Joanna L. Corimanya, Andres Herrera, 
# 
# Creating PCA with environmental variables
##### 

# data needed 
## Environmental variables of the world and shapefiles of areas of projection

# #Installing packages
install.packages("terra")
library(terra)

devtools::install_github("cjbwalsh/hier.part")
remotes::install_github("marlonecobos/kuenm")
library(kuenm)

#Working directory
setwd("Working directory")  

var_folder <- "Variables/wc2.1_2.5m_bio" # name of folder with variables to be combined in distinct sets
out_folder <- "Variables/variables_PCs" # name of folder that will contain the sets
in_format <- "GTiff" 
out_format <- "GTiff" 
npcs <-  5 # number of pcs you want as rasters

# PCA of variables for models
kuenm_rpca(variables  = var_folder, in.format = in_format, var.scale = TRUE, 
           write.result = TRUE, out.format = out_format, out.dir = out_folder, 
           n.pcs = npcs)

# We will calibrate our models for sawfly using Japan only, Japan + East Asia, and
# Japan + East Asia + Europe. For Ulmus we used North America
# We will project them to North America + Europe and to North America, respectively.

# The following lines have to be done for all the calibration and projection areas

# Reading shapefile to crop the variables to area of interest
shp_na <- vect("Working directory/shapefile/NorthAmerica.shp")
plot(shp_na)

vars <- list.files("Variables/variables_PCs/", pattern = ".tif", full.names = TRUE)
var_stack <- terra::rast(vars)

# Cropping the variables to North America
var <- terra::crop(var_stack, shp_na, mask = T)

# Writing the cropped variables
dir.create("Variables/variables_PCs/North_America")
name <- names(var)
var_name <- paste0("Variables/variables_PCs/North_America/", name, ".tif")

for (i in 1:length(var_name)){
  writeRaster(var[[i]], var_name[i], overwrite = TRUE)
} 