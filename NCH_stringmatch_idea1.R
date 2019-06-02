#############################################
## check package before installing/running ##
#############################################
if (!require(stringr)) {
  install.packages("stringr")
  library(stringr)
}

if (!require(dplyr)) {
  install.packages("dplyr")
  library(dplyr)
}

###############################
#####  Make up some data  #####
###############################
KEY_CASE <- c("1234", "238094", "12039823", "382902", "234890",
              "23984775", "99920AB", "234567", "0984028")

input_text <- c("this is a bunch of junk text",
                  "wow look at all this text",
                  "wish I had a text generator of some sort",
                  "almost done with nonsense",
                  "wefoij,23j, foij, hello",
                  "trying to break it 1234, - / , -..",
                  "hi", 
                  "this is my text data",
                  "abuse notes")

text_df <- data.frame(KEY_CASE, input_text)

text_df$KEY_CASE <- as.character(text_df$KEY_CASE)
text_df$input_text <- as.character(text_df$input_text)
###############################


#################################
##########  THINGS 1  ###########
#################################

# setup variables for matches here
things1_to_find <- c("this", "1234", "foij")

# Create TRUE/FALSE vector based on string matching "things1_to_find"
things1_matches <- grepl(
  paste(things1_to_find, collapse = "|"),
  text_df$input_text)

# create dataframe for matches and reset IDs as character vector
match_data <- data.frame(text_df$KEY_CASE, things1_matches)
match_data$text_df.KEY_CASE <- as.character(match_data$text_df.KEY_CASE)
colnames(match_data)[colnames(match_data)=="text_df.KEY_CASE"] <- "KEY_CASE"

# convert T/F into 1/0 by first changing to character vector then perform string replacement
match_data$things1_matches <- as.character(match_data$things1_matches)
match_data$things1_matches <- str_replace_all(match_data$things1_matches, "TRUE", "1")
match_data$things1_matches <- str_replace_all(match_data$things1_matches, "FALSE", "0")

#################################
##########  THINGS 2  ###########
#################################

# setup variables for matches here
things2_to_find <- c("and", "a", "generator")

# Create TRUE/FALSE vector based on string matching "things1_to_find"
things2_matches <- grepl(
  paste(things2_to_find, collapse = "|"),
  text_df$input_text)

match_data$things2_matches <- things2_matches

# convert T/F into 1/0 by first changing to character vector then perform string replacement
match_data$things2_matches <- as.character(match_data$things2_matches)
match_data$things2_matches <- str_replace_all(match_data$things2_matches, "TRUE", "1")
match_data$things2_matches <- str_replace_all(match_data$things2_matches, "FALSE", "0")
