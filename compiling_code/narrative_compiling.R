#narrative compiling code
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


narrative_raw <- read.csv("S:/RESLeonardJ_NickPondel/0_nick_final/1-raw_datasets/narratives.csv", header = TRUE)


#new dataframe with only needed columns
narrative <- data.frame("KEY_CASE" = narrative_raw$KEY_CASE,
                         "text" = narrative_raw$COMMENTTEXT)

narrative$KEY_CASE <- as.character(narrative$KEY_CASE)
narrative$text <- as.character(narrative$text)

#create corpus from data, thus creating duplicate IDs
corpus1 <- corpus(narrative, docid_field = "KEY_CASE", text_field = "text")

#pull out IDs and text as seperate dataframes then bind columns
text_df <- data.frame(texts(corpus1))
docid_df <- data.frame(docnames(corpus1))
duplicate_id_df <- bind_cols(docid_df, text_df)

duplicate_id_df$docnames.corpus1. <- as.character(duplicate_id_df$docnames.corpus1.)
duplicate_id_df$texts.corpus1. <- as.character(duplicate_id_df$texts.corpus1.)

#pull out extra numbers to another column
duplicate_id_df$occurances <- gsub(".*}", "", duplicate_id_df$docnames.corpus1.)

#remove periods from occurances column
duplicate_id_df$occurances <- gsub("[.]*", "", duplicate_id_df$occurances)

#remove extra numbers from ID column
duplicate_id_df$docnames.corpus1. <- gsub("(}).*","\\1",duplicate_id_df$docnames.corpus1.)

#define occurances as a numeric variable
duplicate_id_df$occurances <- as.numeric(duplicate_id_df$occurances)

#replace all blank fields with a 0
duplicate_id_df$occurances[is.na(duplicate_id_df$occurances)] <- 0

#reshaping long to wide
shape1 <- reshape(duplicate_id_df, timevar = "occurances", idvar = "docnames.corpus1.", direction = "wide")

#set NA values to blank to avoid strings of NA characters later
shape1[is.na(shape1)] <- ""

#unite columns from reshape
shape1 <- unite(shape1, combined_text, remove = TRUE, -1, sep = "  ")

#rename columns to originals
names(shape1)[names(shape1) == "docnames.corpus1."] <- "KEY_CASE"
names(shape1)[names(shape1) == "combined_text"] <- "narrative_text"

###################################################
#Verify final dataset is correct
#View(shape1)

#export final CSV
write.csv(shape1, "S:/RESLeonardJ_NickPondel/0_nick_final/3-compiled_data/narrative_compiled.csv")