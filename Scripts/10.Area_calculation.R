#####
# Project: Climatic suitability and invasion risk of the elm zigzag sawfly in North America
# Authors: Claudia Nuñez-Penichet, Zenia P. Ruiz-Utrilla, Daniel Rojas-Ariza, 
#          Weverton C. F. Trindade, Joanna L. Corimanya, Andres Herrera, 
# 
# Calculating the area predicted to be suitable for both taxa study

setwd("Working directory")
library(terra)

get_areas <- function(x, unit = "km") {
  # Step 1: Calculate the area of each cell in square kilometers
  area_raster <- cellSize(x, unit = unit)
  
  # Step 2: Extract values and areas, excluding NA cells
  valid_cells <- !is.na(x)
  r_values <- values(x, mat = FALSE)[valid_cells]
  r_areas  <- values(area_raster, mat = FALSE)[valid_cells]
  
  # Step 3: Combine into data frame and calculate total area per value
  df <- data.frame(class = r_values, area_km2 = r_areas)
  area_per_class <- aggregate(area_km2 ~ class, data = df, FUN = sum)
  
  return(area_per_class)
}

#NE
ja_ne <- rast("Binary/new/Japan_saw_ulmus_NE.tif")
jaAs_ne <- rast("Binary/new/JapanAsia_saw_ulmus_NE.tif")
jaAsEu_ne <- rast("Binary/new/JapanAsiaEurope_saw_ulmus_NE.tif")

#E
ja_e <- rast("Binary/new/Japan_saw_ulmus_E.tif")
jaAs_e <- rast("Binary/new/JapanAsia_saw_ulmus_E.tif")
jaAsEu_e <- rast("Binary/new/JapanAsiaEurope_saw_ulmus_E.tif")

#EC
ja_ec <- rast("Binary/new/Japan_saw_ulmus_EC.tif")
jaAs_ec <- rast("Binary/new/JapanAsia_saw_ulmus_EC.tif")
jaAsEu_ec <- rast("Binary/new/JapanAsiaEurope_saw_ulmus_EC.tif")

#### With area in km2-----------------------------------------------------------
# Calculate the area of each cell in square meters (returns a SpatRaster of same dimensions)
cell_areas_ja_e <- cellSize(ja_e, unit = "km")
cell_areas_jaAs_e <- cellSize(jaAs_e, unit = "km")
cell_areas_jaAsEu_e <- cellSize(jaAsEu_e, unit = "km")

# Total area (e.g., sum of non-NA cell areas)
total_area_km2_ja_e <- global(cell_areas_ja_e, fun = "sum", na.rm = TRUE)
total_area_km2_jaAs_e <- global(cell_areas_jaAs_e, fun = "sum", na.rm = TRUE)
total_area_km2_jaAsEu_e <- global(cell_areas_jaAsEu_e, fun = "sum", na.rm = TRUE)

# Assuming categorical raster 'r'
freq_table_ja_e <- freq(ja_e)
freq_table_jaAs_e <- freq(jaAs_e)
freq_table_jaAsEu_e <- freq(jaAsEu_e)

class_areas_ja_e <- freq_table_ja_e$count * res(ja_e)[1] * res(ja_e)[2]  # pixel count × pixel size
class_areas_jaAs_e <- freq_table_jaAs_e$count * res(jaAs_e)[1] * res(jaAs_e)[2]  # pixel count × pixel size
class_areas_jaAsEu_e <- freq_table_jaAsEu_e$count * res(jaAsEu_e)[1] * res(jaAsEu_e)[2]  # pixel count × pixel size

tab_ja_e <- cbind(freq_table_ja_e, class_areas_ja_e)
tab_jaAs_e <- cbind(freq_table_jaAs_e, class_areas_jaAs_e)
tab_jaAsEu_e <- cbind(freq_table_jaAsEu_e, class_areas_jaAsEu_e)

write.csv(tab_ja_e, "Area/new/count_japan_area_e.csv")
write.csv(tab_jaAs_e, "Area/new/count_japan_Asia_area_e.csv")
write.csv(tab_jaAsEu_e, "Area/new/count_japan_Asia_Europe_area_e.csv")

#EC
cell_areas_ja_ec <- cellSize(ja_ec, unit = "km")
cell_areas_jaAs_ec <- cellSize(jaAs_ec, unit = "km")
cell_areas_jaAsEu_ec <- cellSize(jaAsEu_ec, unit = "km")

# Total area (e.g., sum of non-NA cell areas)
total_area_km2_ja_ec <- global(cell_areas_ja_ec, fun = "sum", na.rm = TRUE)
total_area_km2_jaAs_ec <- global(cell_areas_jaAs_ec, fun = "sum", na.rm = TRUE)
total_area_km2_jaAsEu_ec <- global(cell_areas_jaAsEu_ec, fun = "sum", na.rm = TRUE)

# Assuming categorical raster 'r'
freq_table_ja_ec <- freq(ja_ec)
freq_table_jaAs_ec <- freq(jaAs_ec)
freq_table_jaAsEu_ec <- freq(jaAsEu_ec)

class_areas_ja_ec <- freq_table_ja_ec$count * res(ja_ec)[1] * res(ja_ec)[2]  # pixel count × pixel size
class_areas_jaAs_ec <- freq_table_jaAs_ec$count * res(jaAs_ec)[1] * res(jaAs_ec)[2]  # pixel count × pixel size
class_areas_jaAsEu_ec <- freq_table_jaAsEu_ec$count * res(jaAsEu_ec)[1] * res(jaAsEu_ec)[2]  # pixel count × pixel size

tab_ja_ec <- cbind(freq_table_ja_ec, class_areas_ja_ec)
tab_jaAs_ec <- cbind(freq_table_jaAs_ec, class_areas_jaAs_ec)
tab_jaAsEu_ec <- cbind(freq_table_jaAsEu_ec, class_areas_jaAsEu_ec)

write.csv(tab_ja_ec, "Area/new/count_japan_area_ec.csv")
write.csv(tab_jaAs_ec, "Area/new/count_japan_Asia_area_ec.csv")
write.csv(tab_jaAsEu_ec, "Area/new/count_japan_Asia_Europe_area_ec.csv")

#NE
cell_areas_ja_ne <- cellSize(ja_ne, unit = "km")
cell_areas_jaAs_ne <- cellSize(jaAs_ne, unit = "km")
cell_areas_jaAsEu_ne <- cellSize(jaAsEu_ne, unit = "km")

# Total area (e.g., sum of non-NA cell areas)
total_area_km2_ja_ne <- global(cell_areas_ja_ne, fun = "sum", na.rm = TRUE)
total_area_km2_jaAs_ne <- global(cell_areas_jaAs_ne, fun = "sum", na.rm = TRUE)
total_area_km2_jaAsEu_ne <- global(cell_areas_jaAsEu_ne, fun = "sum", na.rm = TRUE)

# Assuming categorical raster 'r'
freq_table_ja_ne <- freq(ja_ne)
freq_table_jaAs_ne <- freq(jaAs_ne)
freq_table_jaAsEu_ne <- freq(jaAsEu_ne)

class_areas_ja_ne <- freq_table_ja_ne$count * res(ja_ne)[1] * res(ja_ne)[2]  # pixel count × pixel size
class_areas_jaAs_ne <- freq_table_jaAs_ne$count * res(jaAs_ne)[1] * res(jaAs_ne)[2]  # pixel count × pixel size
class_areas_jaAsEu_ne <- freq_table_jaAsEu_ne$count * res(jaAsEu_ne)[1] * res(jaAsEu_ne)[2]  # pixel count × pixel size

tab_ja_ne <- cbind(freq_table_ja_ne, class_areas_ja_ne)
tab_jaAs_ne <- cbind(freq_table_jaAs_ne, class_areas_jaAs_ne)
tab_jaAsEu_ne <- cbind(freq_table_jaAsEu_ne, class_areas_jaAsEu_ne)

write.csv(tab_ja_ne, "Area/new/count_japan_area_ne.csv")
write.csv(tab_jaAs_ne, "Area/new/count_japan_Asia_area_ne.csv")
write.csv(tab_jaAsEu_ne, "Area/new/count_japan_Asia_Europe_area_ne.csv")