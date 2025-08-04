#####
# Project: Climatic suitability and invasion risk of the elm zigzag sawfly in North America
# Authors: Claudia Nuñez-Penichet, Zenia P. Ruiz-Utrilla, Daniel Rojas-Ariza, 
#          Weverton C. F. Trindade, Joanna L. Corimanya, Andres Herrera, 
#     
# Moving occurrence points to closest environmental pixel.
#####

#install.packages("terra")
library(terra)

## set directory to save results
setwd("Working directory") 

source("move2_closest.R")

#####
##Sawfly
#Reading occurrence data
saw <- read.csv("Clean/Aproceros_leucopoda_combined.csv")

#Reading one variable
vari1 <- rast(list.files(path = "Variables/wc2.1_2.5m_bio", pattern = ".tif$",
                           full.names = TRUE)[1])

data_saw <- move_2closest_cell(saw, longitude_column = "Longitude", 
                              latitude_column = "Latitude", 
                              raster_layer = vari1, move_limit_distance = 5)

write.csv(data_saw, "records/saw_moved.csv")

# The process above was repeated for Ulmus data.