#####
# Project: Climatic suitability and invasion risk of the elm zigzag sawfly in North America
# Authors: Claudia Nuñez-Penichet, Zenia P. Ruiz-Utrilla, Daniel Rojas-Ariza, 
#          Weverton C. F. Trindade, Joanna L. Corimanya, Andres Herrera, 
#          Kier Mitchel E. Pitogo, A. Townsend Peterson

# Initial cleaning of occurrence data
## Excluding: records with no coordinates, duplicates, records with 
## coordinates (0, 0), and records with low precision
#####

# data needed 
## Species occurrences in a .csv; in this example we will use a file named 
## Aproceros_leucopoda_combined.csv, which contains the data from GBIF and 
## from Prof. Hara. 

install.packages("geodata")  #for visualizing the data in the geography
library(geodata)

# Defining working directory
setwd("Working directory") 
# change this to your working directory

## Creating a list whit the paths for reading each .csv 
# Sawfly
D <- list.files(path = "Working directory/data/GBIF/sawfly", 
                pattern = ".csv$", full.names = T)
## Creating a list whit the names for saving the clean records
nam <- list.files(path = "Working directory/data/GBIF/sawfly",
                  pattern = ".csv$", full.names = F)
## Creating a list whit the paths for writing each .csv
Finalnam <- paste0("Working directory/data/GBIF/sawfly/Clean/", nam)

# Cleaning
for (i in 1:length(D)){
  occurrences <- read.csv(D[i]) # reading occurrences 
  
  occurrences <- occurrences[, c("species", "decimalLongitude", "decimalLatitude")] # Selecting the columns to keep, you can add others, like time depending on the question
  colnames(occurrences) <- c("Species", "Longitude", "Latitude") #Re-naming the columns
  
  # Excluding duplicates
  occurrences$code <-  paste(occurrences$Species, occurrences$Longitude, # concatenating columns of interest
                             occurrences$Latitude, sep = "_")
  
  occurrences <- occurrences[!duplicated(occurrences$code), 1:4] # erasing duplicates
  occurrences <- na.omit(occurrences[, 1:3]) #Keeping only original colunms
  
  # Excluding records with (0, 0) coordinates
  occurrences <- occurrences[occurrences$Longitude != 0 & occurrences$Latitude != 0, ]
  
  # Excluding records with low level of precision (<= 2 decimals)
  ## samll function to detect precision 
  ## (from https://stackoverflow.com/questions/5173692/how-to-return-number-of-decimal-places-in-r)
  decimalplaces <- function(x) {
     if (abs(x - round(x)) > .Machine$double.eps^0.5) {
       nchar(strsplit(sub('0+$', '', as.character(x)), ".", fixed = TRUE)[[1]][[2]])
     } else {
       return(0)
     }
   }
   
  occurrences <- occurrences[sapply(occurrences$Longitude, decimalplaces) >= 2 & # keep only the ones with more than 2 decimals
                                sapply(occurrences$Latitude, decimalplaces) >= 2, ]
  
  # saving the new set of occurrences inside continents and area of interest
  write.csv(occurrences, Finalnam[i], row.names = FALSE)
}

#-------------------------------------------------------------------------------
# Ulmus
D_ulmus <- list.files(path = "Working directory/data/GBIF/Ulmus", 
                      pattern = ".csv$", full.names = T)
nam_ulmus <- list.files(path = "Working directory/data/GBIF/Ulmus",
                        pattern = ".csv$", full.names = F)
Finalnam_ulmus <- paste0("Working directory/data/GBIF/Ulmus/Clean/", 
                         nam_ulmus)

for (i in 1:length(D_ulmus)){
  occurrences <- read.csv(D_ulmus[i]) # occurrences 
  
  occurrences <- occurrences[, c("species", "decimalLongitude", "decimalLatitude")] # Selecting the columns to keep, you can add others, like time depending on the question
  colnames(occurrences) <- c("Species", "Longitude", "Latitude") #Re-naming the columns
  
  # Excluding duplicates
  occurrences$code <-  paste(occurrences$Species, occurrences$Longitude, # concatenating columns of interest
                             occurrences$Latitude, sep = "_")
  
  occurrences <- occurrences[!duplicated(occurrences$code), 1:4] # erasing duplicates
  occurrences <- na.omit(occurrences[, 1:3])
  
  # Excluding records with (0, 0) coordinates
  occurrences <- occurrences[occurrences$Longitude != 0 & occurrences$Latitude != 0, ]
  
  # Excluding records with low level of precision (<= 2 decimals)
  ## samll function to detect precision 
  ## (from https://stackoverflow.com/questions/5173692/how-to-return-number-of-decimal-places-in-r)
  decimalplaces <- function(x) {
     if (abs(x - round(x)) > .Machine$double.eps^0.5) {
      nchar(strsplit(sub('0+$', '', as.character(x)), ".", fixed = TRUE)[[1]][[2]])
     } else {
       return(0)
     }
   }
   
  occurrences <- occurrences[sapply(occurrences$Longitude, decimalplaces) >= 2 & # keep only the ones with more than 1 decimals
                                sapply(occurrences$Latitude, decimalplaces) >= 2, ]
  
  # saving the new set of occurrences inside continents and area of interest
  write.csv(occurrences, Finalnam_ulmus[i], row.names = FALSE)
}

####
#Creating a big table with all species
setwd("Working directorydata/GBIF/Ulmus/Clean") 
# directory with all clean .csv

D <- list.files(path = ".", pattern = ".csv$", full.names = T)
l <- list()

for (i in 1:length(D)){
  l[[i]] <- read.csv(D[i]) 
}

all <- do.call(rbind, l)

write.csv(all, "all_Ulmus.csv", row.names = FALSE)

# For looking at the data in a world map
wolrd_map <- world(path = ".")
plot(wolrd_map)

# Reading occurrences
ulmus <- read.csv("Working directory/data/GBIF/Ulmus/Clean/all_Ulmus.csv") 
points(ulmus[, 2:3], pch = 19, col = "blue")

sawfly <- read.csv("Working directory/data/GBIF/sawfly/Clean/Aproceros_leucopoda_combined.csv") 
points(sawfly[, 2:3], pch = 19, col = "red")