#############################
# Nick Pondel
# June 12th, 2019
# String search script
# Version 3

## check packages before installing/running ##

if (!require(stringr)) {
  install.packages("stringr")
  library(stringr)
}
if (!require(plyr)) {
  install.packages("plyr")
  library(plyr)
}
if (!require(dplyr)) {
  install.packages("dplyr")
  library(dplyr)
}
if (!require(tidyr)) {
  install.packages("tidyr")
  library(tidyr)
}
if (!require(tibble)) {
  install.packages("tibble")
  library(tibble)
}

# timing the script
match.start.time <- Sys.time()

##### Read in data ######
options(stringsAsFactors = FALSE)

setwd("S:/RESLeonardJ_NickPondel/0_nick_final/")
text_data <- read.csv(file = "5-combined_data/joined_records.csv")
text_data$X <- NULL

##### Define function for underscores #####
under_func <- function(x){
  y <- gsub("^", "_", x) #add at start of line
  y <- gsub("$", "_", y) #add at end of line
  y <- gsub(" ", "_", y) #replace all spaces
  return(y)
}

##### Add underscores to main text data #####
text_data$all_fields <- under_func(text_data$all_fields)

##### Pulling in word variables #####
setwd("S:/RESLeonardJ_NickPondel/0_nick_final/6-single_word_search_variables/csv_6.7.19/")
temp_list <- list.files()

readcsv_func <- function(x) {
  read.csv(file = x, header = F)$V1
}

word_variables <- lapply(temp_list, readcsv_func)

var_names <- substring(temp_list, 21)
var_names <- gsub(x = var_names, pattern = "*.csv", replacement = "")
var_names <- gsub(x = var_names, pattern = " ", replacement = "_")
names(word_variables) <- var_names

##### Add underscores to all word search variables #####
word_vars_underscores <- lapply(word_variables, under_func)

###### Create our data frame for matches ######
match_data <- data.frame(text_data$KEY_CASE)
names(match_data) <- "KEY_CASE"

###### matching function ######
match_func <- function(words, text_df){
  x <- grepl(
         paste(words, collapse = "|"),
         text_df[,2],
         ignore.case = T
        )
  x <- as.character(x)
  x <- str_replace_all(x, "TRUE", "1")
  x <- str_replace_all(x, "FALSE", "0")
  x <- as.numeric(x)
  return(x)
  }

###### matching variables to main text ######
match_data <- sapply(word_variables, match_func, text_df = text_data)

##### Calculate means of each variable #####
match_means <- gather(summarize_all(match_data, mean))
match_means <- rename(match_means, c("key"="match_variable", "value"="mean"))

##### Add back identifiers #####
match_data_with_keys <- match_data
row.names(match_data_with_keys) <- text_data$KEY_CASE

#####  Write out the data  #####
setwd("S:/RESLeonardJ_NickPondel/0_nick_final/")
write.csv(match_data, file = "8-string_match_data/match_data.csv")
write.csv(match_data_with_keys, file = "8-string_match_data/match_data_withkeys.csv")
write.csv(match_means, file = "8-string_match_data/data_match_means.csv")

##### Print run time #####

match.end.time <- Sys.time()
match.time.taken <- match.end.time - match.start.time
match.time.taken
