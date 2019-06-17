# Utilize the anti_join function to remove stopwords and custom lists of stop words

##### text data #####
setwd("S:/RESLeonardJ_NickPondel/0_nick_final/")
text.data <- read.csv(file = "5-combined_data/joined_records.csv", stringsAsFactors = FALSE)

text.counting <- data.frame(text=text.data$all_fields, stringsAsFactors = FALSE)

##### single counts #####
tidy_data <- text.counting %>%
  unnest_tokens(word, text)

single_word_list <- tidy_data %>%
  count(word, sort=TRUE)

single_word_list$n <- NULL

##### bigrams #####
bigrams_list <- text.counting %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2)

bigrams_list <- bigrams_list %>%
  count(bigram, sort=TRUE)

bigrams_list$n <- NULL
bigrams_list$bigram <- gsub(" ","_",bigrams_list$bigram, ignore.case = T)

##### trigrams #####
trigrams_list <- text.counting %>%
  unnest_tokens(trigram, text, token = "ngrams", n = 3)

trigrams_list <- trigrams_list %>%
  count(trigram, sort=TRUE)

trigrams_list$n <- NULL
trigrams_list$trigram <- gsub(" ","_",trigrams_list$trigram, ignore.case = T)
