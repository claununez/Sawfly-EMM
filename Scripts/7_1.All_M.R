#####
# Project: Climatic suitability and invasion risk of the elm zigzag sawfly in North America
# Authors: Claudia Nuñez-Penichet, Zenia P. Ruiz-Utrilla, Daniel Rojas-Ariza, 
#          Weverton C. F. Trindade, Joanna L. Corimanya, Andres Herrera, 
# 
# Combining East and West Ms for sawfly

setwd("Working directory")

library(terra)

one <- vect("West6/M/M_26.gpkg")
two <- vect("East/M/M_26.gpkg")

all <- one + two
nam <- paste0("M_sawfly", ".gpkg")
writeVector(all, nam)