# Utilize the anti_join function to remove stopwords and custom lists of stop words

##### text data #####
setwd("S:/RESLeonardJ_NickPondel/0_nick_final/")
text.data <- read.csv(file = "5-combined_data/joined_records.csv", stringsAsFactors = FALSE)

text.counting <- data.frame(text=text.data$all_fields, stringsAsFactors = FALSE)

##### single counts #####
tidy_data <- text.counting %>%
  unnest_tokens(word, text)

single_word_list <- tidy_data %>%
  count(word, sort=TRUE) %>%
  anti_join(stopwords) %>%
  anti_join(my_stopwords)

single_word_list$n <- NULL

#remove all rows with 2 or less characters in the "word" column
single_word_list <- single_word_list[(which(nchar(single_word_list$word) >= 2 )),]

##### bigrams #####
bigrams_list <- text.counting %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2) %>%
  separate(bigram, c("word1", "word2"), sep = " ") %>%
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word,
         !word1 %in% my_stopwords$word,
         !word2 %in% my_stopwords$word) %>%
  count(word1, word2, sort = TRUE)

#filter to occurances where n > 1
bigrams_unite_n2 <- bigrams_unite %>%
  filter(n>1)

##### trigrams #####
#trigrams
trigrams_list <- text.counting %>%
  unnest_tokens(trigram, text, token = "ngrams", n = 3) %>%
  separate(trigram, c("word1", "word2", "word3"), sep = " ") %>%
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word,
         !word3 %in% stop_words$word,
         !word1 %in% my_stopwords$word,
         !word2 %in% my_stopwords$word,
         !word3 %in% my_stopwords$word) %>%
  count(word1, word2, word3, sort = TRUE)

#reunite words
trigrams_unite <- trigrams %>%
  unite(trigram, word1, word2, word3)

#filter to occurances where n > 1
trigrams_unite_n2 <- trigrams_unite %>%
  filter(n>1)

trigrams_list$n <- NULL
trigrams_list$trigram <- gsub(" ","_",trigrams_list$trigram, ignore.case = T)
