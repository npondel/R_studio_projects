#############################
# Nick Pondel
# June 10th, 2019
# String search script
# Version 3


## check packages before installing/running ##

if (!require(stringr)) {
  install.packages("stringr")
  library(stringr)
}
if (!require(tibble)) {
  install.packages("tibble")
  library(tibble)
}
if (!require(plyr)) {
  install.packages("plyr")
  library(plyr)
}
if (!require(dplyr)) {
  install.packages("dplyr")
  library(dplyr)
}

# timing the script
match.start.time <- Sys.time()

##### Read in data ######
options(stringsAsFactors = FALSE)

setwd("S:/RESLeonardJ_NickPondel/0_nick_final/")
text_data <- read.csv(file = "5-combined_data/joined_records.csv")
text_data$X <- NULL

##### Add underscores to main text data #####
text_data <- gsub(" ","_",text_data) #replace all spaces with underscores
text_data <- gsub("^","_",text_data) #add an underscore at the beginning of each record
text_data <- gsub("$","_",text_data) #add an underscore at the end of each record

##### Pulling in word variables #####
setwd("S:/RESLeonardJ_NickPondel/0_nick_final/6-single_word_search_variables/csv_variables/")
temp_list <- list.files()

readcsv_func <- function(x) {
  read.csv(file = x, header = F)$V1
}

word_variables <- lapply(temp_list, readcsv_func)

var_names <- substring(temp_list, 19)
var_names <- gsub(x = var_names, pattern = "*.csv", replacement = "")
var_names <- gsub(x = var_names, pattern = " ", replacement = "_")
names(word_variables) <- var_names

##### Add underscores to all word search variables #####

under_func <- function(x){
  y <- gsub("^", "_", x)
  y <- gsub("$", "_", y)
  return(y)
}

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
# WARNING - this takes aprox 7 mins
match_data <- sapply(word_variables, match_func, text_df = text_data)


##### Calculate means of each variable #####
match_means <- gather(summarize_all(match_data[,2:37], mean))
match_means <- rename(match_means, c("key"="match_variable", "value"="mean"))

#####  Write out the data  #####
#write.csv(match_data, file = "8-string_match_data/match_data.csv")
#write.csv(match_means, file = "8-string_match_data/data_match_means.csv")

##### Print run time #####

match.end.time <- Sys.time()
match.time.taken <- match.end.time - match.start.time
match.time.taken
