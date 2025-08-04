#####
# Project: Climatic suitability and invasion risk of the elm zigzag sawfly in North America
# Authors: Claudia Nuñez-Penichet, Zenia P. Ruiz-Utrilla, Daniel Rojas-Ariza, 
#          Weverton C. F. Trindade, Joanna L. Corimanya, Andres Herrera, 
# # Binarization
library(terra)

setwd("Working directory")

dir()
sps <- dir()
out_calibration <- paste0(sps, "/Calibration_results/selected_models.csv")
occ_joint <- paste0(sps, "/sp_occ_joint.csv")

for (i in 1:length(sp)){
  good <- read.csv(out_calibration[i])
  n_rows <- nrow(good)
  
  if (n_rows == 1){
    ###For one good model-----------------------------------------------------------
    occ <- read.csv(occ_joint[i])
    occ <- occ[, 2:3]
    occ$code <-  paste(occ$Longitude, occ$Latitude, # concatenating columns of interest
                       sep = "_")
    
    med <- paste0(sps, "/Final_models/", good$Model, "_E/", sps[i], "_median.csv")
    all <- read.csv(med[i])
    all$code <-  paste(all$Longitude, all$Latitude, # concatenating columns of interest
                       sep = "_")
    
    o_suit <- all[all$code %in% occ$code, 3]
    o_suit_sort <- sort(o_suit)
    threshold <- 5
    thres <- o_suit_sort[ceiling(length(occ[, 1]) * threshold / 100) + 1]
    
    raster <- paste0(sps, "/Final_models/", good$Model, "_E/", sps[i], "_current_median.asc")
    bin <- rast(raster[i])
  }
  else {
    folders <- list.dirs(path = "Models/East_Asia", full.names = TRUE, recursive = FALSE)
    
    # Create directory where files will be saved
    dir.create('sample_Pred_files')
    dir.create('sample_Pred_files/East_Asia')
   
    # Create subdirectories for E, EC, and NE
    dir.create("sample_Pred_files/East_Asia/E")
    dir.create("sample_Pred_files/East_Asia/EC")
    dir.create("sample_Pred_files/East_Asia/NE")
    
    cont <- 1
    for (j in seq_along(folders)){
      
      # Sample predictions files in each folder
      sample_pred_files <- list.files(path = folders[j], pattern = "_samplePredictions.csv$", 
                                      full.names = TRUE)
      
      for (i in seq_along(sample_pred_files)){
        # Change names of sample predictions files and save them
        # Read files
        file <- read.csv(sample_pred_files[i])
        print(sample_pred_files[i])
        
        # Write and save file
        if (cont == 1){
          write.csv(file, paste('sample_Pred_files/East_Asia/E/', paste(sub('.*/', '', paste(folders[j], '_', sep = '')), 
                                                                        paste(toString(i-1), '.csv', sep =''), 
                                                                        sep = ''), sep = ''), row.names = FALSE)
        }
        else if (cont == 2){
          write.csv(file, paste('sample_Pred_files/East_Asia/EC/', paste(sub('.*/', '', paste(folders[j], '_', sep = '')), 
                                                                         paste(toString(i-1), '.csv', sep =''), sep = ''), 
                                sep = ''), row.names = FALSE)
        }
        else {
          write.csv(file, paste('sample_Pred_files/East_Asia/NE/', paste(sub('.*/', '', paste(folders[j], '_', sep = '')), 
                                                                         paste(toString(i-1), '.csv', sep =''), sep = ''), 
                                sep = ''), row.names = FALSE)
        }
      }
      if (cont != 3){
        cont <- cont + 1
      }
      else{
        cont <- 1
      }
      
    }
    
    D <- list.files(path = "sample_Pred_files/Japan/E/", 
                    pattern = ".csv$", full.names = T)
    
    l <- list()
    for (i in 1:length(D)){
      #Reading occurrence data
      occ <- read.csv(D[i])
      l[[i]] <- occ$Cloglog.prediction
    }
    
    all <- as.data.frame(do.call(cbind, l))
    all$median <- apply(all, 1, median)
    write.csv(all, "sample_Pred_files/Japan/Japan_E.csv", row.names = FALSE)
    
    ###For several good models------------------------------------------------------
    o_suit <- all$median
    o_suit_sort <- sort(o_suit)
    threshold <- 5
    thres <- o_suit_sort[ceiling(length(all[, 1]) * threshold / 100) + 1]
    
    bin <- rast("Final_models_stats/Japan/Statistics_E/current_med.tif")
  } 
  
  # Binarization
  bin <- (bin >= thres) * 1
  plot(bin)
  
  writeRaster(bin, filename = paste0("Binary/", sps[i], ".tif"), 
              filetype = "GTiff", overwrite = TRUE)
}

# ulmus-------------------------------------------------------------------------
occ_1 <- read.csv("Ulmus/sp_joint.csv")
occ_1 <- occ_1[, 2:3]
occ_1$code <-  paste(occ_1$Longitude, occ_1$Latitude, # concatenating columns of interest
                   sep = "_")
bin_1 <- rast("Ulmus/Ulmus_E/Ulmus_curent_median.asc")

occ_1.1 <- read.csv("Ulmus/Ulmus_E/Ulmus_median.csv")
occ_1.1$code <-  paste(occ_1.1$Longitude, occ_1.1$Latitude, # concatenating columns of interest
                    sep = "_")

o_suit_1 <- occ_1.1[occ_1.1$code %in% occ_1$code, 3]

o_suit_sort_1 <- sort(o_suit_1)
threshold <- 5
thres <- o_suit_sort_1[ceiling(length(occ_1[, 1]) * threshold / 100) + 1]

# Binarization
bin_1 <- (bin_1 >= thres) * 1
writeRaster(bin_1, filename = "Binary/new/ulmus_E.tif", 
            filetype = "GTiff", overwrite = TRUE)

# Overlap
bin_1.1 <- bin_1 * 100
over <- crop (bin, bin_1.1, mask = T)
overl <- over + bin_1.1

plot(overl)

writeRaster(overl, filename = "Binary/new/Japan_saw_ulmus_E.tif", 
            filetype = "GTiff", overwrite = TRUE)