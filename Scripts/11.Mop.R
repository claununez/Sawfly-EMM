#####
# Project: Climatic suitability and invasion risk of the elm zigzag sawfly in North America
# Authors: Claudia Nuñez-Penichet, Zenia P. Ruiz-Utrilla, Daniel Rojas-Ariza, 
#          Weverton C. F. Trindade, Joanna L. Corimanya, Andres Herrera, 
# 
# MOP analysis to identify areas of extrict extrapolation

# package
library(mop)

setwd("Working directory")

# data
## current conditions
current_list <- list.files("Working directory/ulmus_maxent/variables_PCA/crop/ascii",  
                           pattern= "asc", full.names =T)
reference_layers <- terra::rast(current_list)

## projection conditions
interest_list <- list.files("Working directory/ulmus_maxent/Ulmus/G_variables/set_26/curent", 
                            pattern= "asc", full.names =T)
layers_of_interest <- terra::rast(interest_list)

# plot the data
## variables to represent current conditions
terra::plot(reference_layers)
terra::plot(layers_of_interest)

# analysis
mop_basic_res <- mop(m = reference_layers, g = layers_of_interest, 
                     type = "detailed", calculate_distance = TRUE, 
                     where_distance = "all", distance = "euclidean", 
                     scale = TRUE, center = TRUE)
# summary
summary(mop_basic_res)
terra::plot(mop_basic_res$mop_simple)
terra::plot(mop_basic_res$mop_basic)
terra::plot(mop_basic_res$mop_detailed$towards_high_combined)
save(mop_basic_res, file = "mop_Ulmus.RData")
writeRaster(mop_basic_res$mop_simple, "mop_Ulmus_simple.tif", overwrite = TRUE)
writeRaster(mop_basic_res$mop_basic, "mop_Ulmus_basic.tif", overwrite = TRUE)
writeRaster(mop_basic_res$mop_detailed$towards_high_combined, "mop_Ulmus_detailed_higcombined.tif", overwrite = TRUE)
writeRaster(mop_basic_res$mop_distances, "mop_Ulmus_distances.tif", overwrite = TRUE)

#The code above was repeated for all calibration areas of sawfly