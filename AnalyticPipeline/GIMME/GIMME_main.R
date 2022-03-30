# The script coduct GIMME analysis
# The script will need package GIMME to run
# Xiaosu Hu, 20220329

# Include gimme library
library("gimme")

# Working directory
# setwd("/Users/xiaosuhu/Documents/MATLAB/PLAYGROUND/Nia/GIMME/GIMMEData/")
setwd("D:\\Matlab\\PlayGroud\\Nia\\GIMME\\GIMME Data\\GIMMEData")

#Run the GIMME Model
gimme(data = "ENPAnorm", 
      out = "Gimme_ENPAnorm_results", 
      sep = "", 
      header = FALSE, 
      ar = TRUE, 
      plot = TRUE, 
      subgroup = TRUE, 
      paths = NULL,  
      groupcutoff = 0.75, 
      subcutoff = 0.5, 
      diagnos = FALSE,
      ms_allow = FALSE)