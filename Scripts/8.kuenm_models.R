#####
# Project: Climatic suitability and invasion risk of the elm zigzag sawfly in North America
# Authors: Claudia Nuñez-Penichet, Zenia P. Ruiz-Utrilla, Daniel Rojas-Ariza, 
#          Weverton C. F. Trindade, Joanna L. Corimanya, Andres Herrera, 
# 
# Ecological niche modeling 

## kuenm
devtools::install_github("marlonecobos/kuenm")

# # loading the package
library(kuenm)
library(raster)
library(terra)

# setting working directory (CHANGE IT ACCORDING TO YOUR NEEDS)
setwd("Working directory")

# preparing data (complete the code)
## reading initial data
occurrences <- read.csv("all.csv") # species occurrence records
occurrences <- occurrences[, c(2, 3, 1)]

vars <- stack(list.files("variables/PCA_M_2_5m/asc_file_M/", pattern = ".asc$", # variables for
                         full.names = TRUE))                                    # calibration area

# data preparation
data_prep <- prepare_swd(occ = occurrences, species = "Species", 
                         longitude = "Longitude", latitude = "Latitude", 
                         data.split.method = "random", train.proportion = 0.7, 
                         raster.layers = vars, 
                         var.sets = "all_comb", save = TRUE, 
                         name.occ = "sp", 
                         back.folder = "background")

# model calibration and selection
## define arguments
oj <- "sp_joint.csv"
otr <- "sp_train.csv"
ote <- "sp_test.csv"
back <- "background"
btch <- "batch_calibration"
odir_calmodels <- "Candidate_models"
rg <- c(0.1, 0.25, 0.5, 0.75, 1, 2, 3, 4, 5)
fc <- c("q", "lq", "lp", "qp", "lqp")
mx <- "Working directory/maxent"
sel <- "OR_AICc"
thr <- 5
odir_eval <- "Calibration_results"

## run function
cal <- kuenm_cal_swd(occ.joint = oj, occ.tra = otr, occ.test = ote, 
                     back.dir = back, batch = btch, 
                     out.dir.models = odir_calmodels, reg.mult = rg, 
                     f.clas = fc, maxent.path = mx, selection = sel, 
                     threshold = thr, out.dir.eval = odir_eval)

# final models and projections
## variables for projections
cal$selected_models[1, ]

## names of predictors
preds <- read.csv("background/Set_21.csv") #Set_26.csv for Ulmus
colnames(preds)  # PCs 1, 2, 4, and 5

#### general directory
gvar <- "G_variables"
dir.create(gvar)
dir.create(paste0(gvar, "/Set_21"))

pcs_set21 <- c(1, 2, 3, 4)
mnames <- paste0("G_variables/Set_21/current/PC_", pcs_set21, ".asc")

writeRaster(mnames, filename = mnames1, overwrite = TRUE)

gnamesall <- list.files(path = "G_variables/Set_21/current/",
                        pattern = ".asc$", full.names = T)

### fix NAs
for (i in gnamesall) {
  writeLines(gsub("nan", "-99999", readLines(i)), i)
}

## arguments for final models
btch_final <- "bacth_final"
rn <- 10
rt <- "Bootstrap"
jk <- TRUE
of <- "cloglog"
pr <- TRUE
ety <- "all"
mod_dir <- "Final_models"


## run final models
kuenm_mod_swd(occ.joint = oj, back.dir = back, out.eval = odir_eval, 
              batch = btch_final, rep.n = rn, rep.type = rt, maxent.path = mx,
              jackknife = jk, out.format = of, project = pr, 
              G.var.dir = gvar, ext.type = ety, out.dir = mod_dir, wait = TRUE)

# Post modeling analysis
# model consensus
## define stat arguments
sp <- read.csv("sp_joint.csv")[1, 1]
scen <- dir("G_variables_crop/Set_21/")
stats <- c("med", "range")
statsdir <- "Final_model_stats"

## run model stats
kuenm_modstats_swd(sp.name = sp, fmod.dir = mod_dir, statistics = stats, 
                   proj.scenarios = scen, ext.type = ety, out.dir = statsdir)

#The code above was repeated for all sawfly calibration areas and for Ulmus in North America