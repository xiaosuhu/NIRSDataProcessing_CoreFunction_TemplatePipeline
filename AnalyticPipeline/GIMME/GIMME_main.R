# The script coduct GIMME analysis
# The script will need package GIMME to run
# Xiaosu Hu, 20220329

# Include gimme library
library("gimme")

# Working directory
setwd("/Users/xiaosuhu/Documents/MATLAB/PLAYGROUND/Nia/GIMME/GIMMEData/")

#Run the GIMME Model
gimme(data = "ENSPPAcombined", 
      out = "Gimme_ENSPPAcombined_result_originalgimmecommand", 
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