#demographics compiling script
#Nick Pondel
#Updated May 29th, 2019

################################
#Checking packages needed, installs if not found on system

if (!require(dplyr)) {
  install.packages("dplyr")
  library(dplyr)
}

if (!require(quanteda)) {
  install.packages("quanteda")
  library(quanteda)
}

if (!require(tidyr)) {
  install.packages("tidyr")
  library(tidyr)
}
################################

demographics <- read.csv("S:/RESLeonardJ_NickPondel/0_nick_final/1-raw_datasets/demographics.csv", header = TRUE)

demographics$KEY_CASE <- as.character(demographics$KEY_CASE)
demographics$Incident.Type <- as.character(demographics$Incident.Type)
demographics$Disposition <- as.character(demographics$Disposition)
demographics$Urgency.From.Scene <- as.character(demographics$Urgency.From.Scene)


#unite columns, ignoring the key_case variable
united_demographics <- unite(demographics, demo_compiled, remove = TRUE, -1, sep = ",  ")

#verify dataframe structure
#View(united_demographics)

#export final CSV
write.csv(united_demographics, "S:/RESLeonardJ_NickPondel/0_nick_final/3-compiled_data/demographics_compiled.csv")
