#####
# Project: Climatic suitability and invasion risk of the elm zigzag sawfly in North America
# Authors: Claudia Nuñez-Penichet, Zenia P. Ruiz-Utrilla, Daniel Rojas-Ariza, 
#          Weverton C. F. Trindade, Joanna L. Corimanya, Andres Herrera, 
#   
# Spatial thinning of the species (country density) only done to Ulmus

#installing if needed
install.packages("spocc")

if(!require(devtools)){
  install.packages("devtools")
}
# url https://github.com/marlonecobos/ellipsenm#installing-the-package
devtools::install_github("marlonecobos/ellipsenm")

if(!require(ellipsenm)){
  devtools::install_github("marlonecobos/ellipsenm")
}
library(ellipsenm)

# packages
library(spocc)
library(rgbif)
library(maps)
library(ellipsenm)
library(raster)
library(sp)
library(dplyr)
library(purrr)
library(terra)
library(rgdal)

if(!require(terra)){
  install.packages("terra")
  library(terra)
}

# directory
setwd("Working directory")

set.seed(111)

# reading shapefile (the world shape file used here was: ESRI UIA_World Countries Boundaries,
#2023. https://hub.arcgis.com/datasets/252471276c9941729543be8789e06e12/explore)

wrld <- readOGR("shapefile/Shapefile/North_America.shp")
plot(wrld)

# extracting country names by coordinates in our data base
# Convert data.frame to SpatialPointsDataFrame
sf_sp <- read.csv("Working directory/Ulmus/occurrences_2/ulmus_combined_2.5_NA_thinned_thin1_complete.csv")
names(sf_sp)
coordinates(sf_sp) <- ~Longitude.x + Latitude.x
crs(sf_sp) <- crs(wrld)
plot(sf_sp, add = T)

# Get the shapefile attributes
# Extract values to points
sf_atributtes <- over(sf_sp, wrld)
sf_atributtes <- sf_atributtes %>% filter(!is.na(CNTRY_NAME))

# Join the attributes
sf_df <- data.frame(sf_sp, sf_atributtes)
sf_df$CNTRY_NAME <- as.character(sf_df$CNTRY_NAME)
hist(table(sf_df$CNTRY_NAME))

# Split data by country
cto_sampleL <- sf_df %>% split(.$CNTRY_NAME,drop = T)

# Take area per country
areas <- sf_atributtes %>% distinct(CNTRY_NAME,SQKM_CNTRY)
occ_per_country <- sf_atributtes %>% count(CNTRY_NAME)
occ_per_km2 <- inner_join(occ_per_country, areas, by = 'CNTRY_NAME')
occ_per_km2$occ_density <- occ_per_km2$n/occ_per_km2$SQKM_CNTRY
median_occ_per_km2 <- median(occ_per_km2$occ_density[1:9])
occ_per_km2$median_per_area <- occ_per_km2$SQKM_CNTRY*median_occ_per_km2

dataList = list()

  # Function for randomly sampling by country
  sample_by_country <- function(df, country, n) {
    if (country %in% unique(df$CNTRY_NAME)) {
      df %>%
        filter(CNTRY_NAME == country) %>%
        slice_sample(n = n, replace = FALSE)
    } else {
      return(NULL) # if the country in not in the data frame, return NULL
    }
  }

# List to store the data of each country
dataList <- vector("list", length = length(cto_sampleL))

# Iteration over each dataframe in cto_sampleL
for (i in 1:length(cto_sampleL)) {
  dataList[[i]] <- lapply(unique(cto_sampleL[[i]]$CNTRY_NAME), function(country) {
    sample_by_country(cto_sampleL[[i]], country, switch(country,
                                                        "Canada"       = 1019,
                                                        "Costa Rica"   = 5,
                                                        "El Salvador"  = 2,
                                                        "Guatemala"    = 7,
                                                        "Honduras"     = 3,
                                                        "Mexico"       = 202,
                                                        "Nicaragua"    = 5,
                                                        "Panama"       = 5,
                                                        "United States"= 973))
  })
  
  # Concatenar listas de cada país en un solo dataframe
  dataList[[i]] <- bind_rows(dataList[[i]])
}

# Graficar los puntos
for (i in 1:length(dataList)) {
  if (!is.null(dataList[[i]])) {
    points(dataList[[i]][, c(4, 5)], col = "red") # Especifica un color aquí
  }
}
write.csv(dataList[[9]],"Ulmus_country_2.5_thinned_9_country.csv", row.names = F)

# list of csv in the directory
files <- list.files(pattern = "Ulmus_country_2.5_thinned_\\d+_country.csv")

# read and combined in one dataframe
combined_data <- lapply(files, read.csv)
combined_data <- do.call(rbind, combined_data)

str(combined_data)

# save the combined dataframe
write.csv(combined_data, "Ulmus_country_2.5_thinned_9_country_combined.csv", 
          row.names = FALSE)