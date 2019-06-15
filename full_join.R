#full join code
#Nick Pondel
#Updated May 29th, 2019

##################
#package checking
if (!require(dplyr)) {
  install.packages("dplyr")
  library(dplyr)
}

if (!require(tidyr)) {
  install.packages("tidyr")
  library(tidyr)
}
###################

#load in all datasets for compiled variables
demographics <- read.csv(file = "S:/RESLeonardJ_NickPondel/0_nick_final/3-compiled_data/demographics_compiled.csv")
causes <- read.csv(file = "S:/RESLeonardJ_NickPondel/0_nick_final/3-compiled_data/causes_compiled.csv")
complaints <- read.csv(file = "S:/RESLeonardJ_NickPondel/0_nick_final/3-compiled_data/complaints_compiled.csv")
impressions <- read.csv(file = "S:/RESLeonardJ_NickPondel/0_nick_final/3-compiled_data/impressions_compiled.csv")
narrative <- read.csv(file = "S:/RESLeonardJ_NickPondel/0_nick_final/3-compiled_data/narrative_compiled.csv")
preexist <- read.csv(file = "S:/RESLeonardJ_NickPondel/0_nick_final/3-compiled_data/preexist_compiled.csv")
symptoms <- read.csv(file = "S:/RESLeonardJ_NickPondel/0_nick_final/3-compiled_data/symptoms_compiled.csv")

#nested full join operations
raw_joined_data <- full_join(narrative, demographics, by = "KEY_CASE") %>%
  full_join(., causes, by = "KEY_CASE") %>%
  full_join(., complaints, by = "KEY_CASE") %>%
  full_join(., impressions, by = "KEY_CASE") %>%
  full_join(., preexist, by = "KEY_CASE") %>%
  full_join(., symptoms, by = "KEY_CASE")

#clean up data frame
joined_data <- data.frame("KEY_CASE" = raw_joined_data$KEY_CASE,
                          "narrative" = raw_joined_data$narrative_text,
                          "demographics" = raw_joined_data$demo_compiled,
                          "cause" = raw_joined_data$cause_text,
                          "complaint" = raw_joined_data$complaint_text,
                          "impressions" = raw_joined_data$impressions_text,
                          "preexist" = raw_joined_data$preexist_text,
                          "symptoms" = raw_joined_data$symptoms_text)

joined_data <- unite(joined_data, all_fields, sep = " // ", remove = TRUE, -1)

#view dataset
#View(joined_data)

write.csv(joined_data,"S:/RESLeonardJ_NickPondel/0_nick_final/5-combined_data/joined_records.csv")
