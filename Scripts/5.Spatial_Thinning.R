#####
# Project: Climatic suitability and invasion risk of the elm zigzag sawfly in North America
# Authors: Claudia Nuñez-Penichet, Zenia P. Ruiz-Utrilla, Daniel Rojas-Ariza, 
#          Weverton C. F. Trindade, Joanna L. Corimanya, Andres Herrera, 
#   
# Spatial thinning of the species geographic occurrences
#####

# data needed 
## Clean species occurrences in a .csv

# setting working directory
setwd("Working directory")

# Installing packages
install.packages("spThin")
# Loading packages
library(spThin)  # geographic rarefaction of records (spatial thinning)

##--------You need to do the steps below for each species independently---------
#sawfly
# Reading occurrence data  
occ_saw <- read.csv("sawfly/Clean/Aproceros_leucopoda_combined.csv")

# Spatial thinning
occt <- thin(loc.data = occ_saw, lat.col = "Latitude", long.col = "Longitude",   
             spec.col = "Species", thin.par = 5, reps = 5,  # thin.par = 5; Assuming 5km thinning distance
             locs.thinned.list.return = FALSE, write.files = TRUE,
             max.files = 1, out.dir = "sawfly/Clean/records",
             out.base = "saw_occ_thinned")

#Ulmus
# Reading occurrence data  
occ_ul <- read.csv("Ulmus/Clean/all_Ulmus.csv")

# Spatial thinning
occt <- thin(loc.data = occ_ul, lat.col = "Latitude", long.col = "Longitude",   
             spec.col = "Species", thin.par = 5, reps = 5,  # thin.par = 5; Assuming 5km thinning distance
             locs.thinned.list.return = FALSE, write.files = TRUE,
             max.files = 1, out.dir = "Ulmus/Clean/records",
             out.base = "ulm_occ_thinned")
