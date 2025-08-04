#####
# Project: Climatic suitability and invasion risk of the elm zigzag sawfly in North America
# Authors: Claudia Nuñez-Penichet, Zenia P. Ruiz-Utrilla, Daniel Rojas-Ariza, 
#          Weverton C. F. Trindade, Joanna L. Corimanya, Andres Herrera, 
#          Kier Mitchel E. Pitogo, A. Townsend Peterson

# Download occurrence data from GBIF
#####

# data needed 
## The name of the taxa you are interested in.

# Installing and loading packages
install.packages("rgbif") #for downloading the data from GBIF
library(rgbif)

# Establishing working directory
setwd("Working directory")

# Get GBIF keys for taxon of interest 
# Species Aproceros leucopoda
spKey <- name_backbone("Aproceros leucopoda")$usageKey  #Add your taxon

# Genus Ulmus
genusKey <- name_backbone(name = "Ulmus L", rank = "Ulmus")$usageKey  #Add your taxon

# Perform a download for your desired taxon and retrieve a download key.
# You can set download filter parameters using pred_in and pred functions
# Species Aproceros leucopoda
gbif_download_key = occ_download(
  pred("taxonKey", spKey), # insert taxon key for the taxon interested in
  pred("hasCoordinate", TRUE),
  pred("hasGeospatialIssue", FALSE),
  format = "SIMPLE_CSV",
  # Specify your GBIF data download user details.
  user = "",  #add your GBIF user name
  pwd = "",  #add your GBIF password
  email = ""  #add your GBIF email
)

# Genus Ulmus
gbif_download_key1 = occ_download(
  pred("taxonKey", genusKey), # insert taxon key for the taxon interested in
  pred("hasCoordinate", TRUE),
  pred("hasGeospatialIssue", FALSE),
  format = "SIMPLE_CSV",
  # Specify your GBIF data download user details.
  user = "",   #add your GBIF user name 
  pwd = "",   #add your GBIF password
  email = ""   #add your GBIF email
)

occ_download_wait(gbif_download_key)
occ_download_wait(gbif_download_key1)

data_download <- occ_download_get(gbif_download_key, overwrite = T) %>% occ_download_import()
data_download1 <- occ_download_get(gbif_download_key1, overwrite = T) %>% occ_download_import()

# For writing each species as a .csv in your working directory
saw <- unique(data_download$species)
saw <- for (i in 1:length(saw)){
  fila <- data_download[data_download$species == saw[i], ]
  write.csv(fila, paste0(saw[i], ".csv"), row.names = F)
}

elm <- unique(data_download1$species)
elm <- for (i in 1:length(elm)){
  fila <- data_download1[data_download1$species == elm[i], ]
  write.csv(fila, paste0(elm[i], ".csv"),
            row.names = F)
}