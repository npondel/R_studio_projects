#############################
# Nick Pondel
# June 17th, 2019
# String search script
# Version 4

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
if (!require(readxl)) {
  install.packages("readxl")
  library(readxl)
}

# timing the script
match.start.time <- Sys.time()

##### Read in data ######
options(stringsAsFactors = FALSE)

setwd("S:/RESLeonardJ_NickPondel/0_stringmatch_pipeline/input/")
text_data <- read.csv(file = "text_data.csv")
text_data$X <- NULL

##### define function for text data underscores #####
under_func_text <- function(x){
  y <- gsub("^", "_", x) #add at start of word
  y <- gsub("$", "_", y) #add at end of word
  y <- gsub(" ", "_", y) #replace all spaces
  return(y)
}

##### Add underscores to main text data #####
text_data$all_fields <- under_func_text(text_data$all_fields)

##### Reading in word variables #####
word_variables <- lapply(excel_sheets("word_vars.xlsx"), read_excel,
                         path = "word_vars.xlsx",
                         col_names = FALSE)
names(word_variables) <- excel_sheets("word_vars.xlsx")

##### Define function for word variables underscores #####
under_func_tibble <- function(x){
  y <- x$...1 #create a vector by selecting the first (and only) column per tibble
  y <- gsub("^", "_", y) #add at start of word
  y <- gsub("$", "_", y) #add at end of word
  y <- gsub(" ", "_", y) #replace all spaces
  return(y)
}

##### Add underscores to all word search variables #####
word_vars_underscores <- sapply(word_variables, under_func_tibble)

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

###### calling string match function on text data ######
match_data <- sapply(word_vars_underscores, match_func, text_df = text_data)
match_data <- data.frame(match_data)

##### Calculate means of each variable #####
match_means <- gather(summarise_all(match_data, mean))
names(match_means) <- c("variable","mean")

##### Add back identifiers to data #####
IDs <- text_data$KEY_CASE
match_data_ID <- cbind(IDs,match_data)

#####  Write out the data  #####
setwd("S:/RESLeonardJ_NickPondel/0_stringmatch_pipeline/output/")
write.csv(match_data, file = "match_data_NOid.csv")
write.csv(match_data_ID, file = "match_data.csv")
write.csv(match_means, file = "data_means.csv")

##### Print run time #####

match.end.time <- Sys.time()
match.time.taken <- match.end.time - match.start.time
match.time.taken
