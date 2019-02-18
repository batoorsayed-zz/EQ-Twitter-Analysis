#### Prep Work ####
library(twitteR)
library(tm)
library(ggplot2)
library(rtweet)
library(tidyr)
library(dplyr)
library(stringr)
library(tidytext)
library(reshape2)
library(wordcloud)

setwd("...")

consumer_key <- '...'
consumer_secret <- '...'
access_token <- '...'
access_secret <- '...'

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

searcheq <- searchTwitter('#EQ OR EQ OR #emotionalintelligence OR \"Emotional Intellignece\"  AND -filter:retweets',
                          n = 100000, lang='en', since = '2019-02-08',  until = '2019-02-18',  retryOnRateLimit = 1e3)
eqtweets = twitteR::twListToDF(searcheq)

write.csv(eqtweets, file = ".../eqtweets.csv")

#### Tokenizing and Cleaning  ####
## Getting rid of clutter ##
eqtweets$text = gsub("&amp", "", eqtweets$text)
eqtweets$text = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", eqtweets$text)
eqtweets$text = gsub("@\\w+", "", eqtweets$text)
eqtweets$text = gsub("[[:punct:]]", "", eqtweets$text)
eqtweets$text = gsub("[[:digit:]]", "", eqtweets$text)
eqtweets$text = gsub("http\\w+", "", eqtweets$text)
eqtweets$text = gsub("[ \t]{2,}", "", eqtweets$text)
eqtweets$text = gsub("^\\s+|\\s+$", "", eqtweets$text)
eqtweets$text <- iconv(eqtweets$text, "UTF-8", "ASCII", sub="")

## Getting rid of stop_words and tokenizing it ##
tokens_twittereq <- eqtweets %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  #count(word, sort=TRUE)
  print(tokens_twittereq)

## Sentiment analysis based on Bing ##
bing_eq <- tokens_twittereq %>%
  unnest_tokens(word, word) %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort=T) %>%
  ungroup()
#write.csv(bing_eq, file = ".../bing_eq.csv")

## Sentimet analysis based on NRC ##
nrc_eq <- tokens_twittereq %>%
  unnest_tokens(word, word) %>%
  inner_join(get_sentiments("nrc")) %>%
  count(word, sentiment, sort=T) %>%
  ungroup()
#write.csv(nrc_eq, file = ".../nrc_eq.csv")

##Sentiment analysis based on Loughran ##
loughran_eq <- tokens_twittereq %>%
  unnest_tokens(word, word) %>%
  inner_join(get_sentiments("loughran")) %>%
  count(word, sentiment, sort=T) %>%
  ungroup()
#write.csv(loughran_eq, file = ".../loughran_eq.csv")

## Sentiment analysis based on Afinn ##
afinn_eq <- tokens_twittereq %>%
  unnest_tokens(word, word) %>%
  inner_join(get_sentiments("afinn")) %>%
  count(word, score, sort=T) %>%
  ungroup()
#write.csv(afinn_eq, file = ".../afinn_eq.csv")

## This is as far as I'm willing to visualize with R ###
loughran_eq %>% #<- Change the df to any other you have just created up top. (bing_eq, etc.)
  group_by(sentiment) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word=reorder(word, n)) %>%
  ggplot(aes(word, n, fill=sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y")+
  labs(y="Contribution to sentiment", x=NULL)+
  coord_flip()

###Here is where I give up on tryting to visualize. Shamelessly exporting the data to Tableau. ###
#### Nothing to see here ####

#bing_eq %>%
#  group_by(sentiment) %>%
#  top_n(10) %>%
#  ungroup() %>%
#  mutate(word = reorder(word, n)) %>%
#  ggplot(aes(word, n, fill = sentiment)) +
#  geom_col(show.legend = FALSE) +
#  facet_wrap(~sentiment, scales = "free_y") +
#  labs(title = "Sentiment during the 2013 flood event.",
#       y = "Contribution to sentiment",
#       x = NULL) +
#  coord_flip()


#wordcloud_tweet = c(
#  paste(nrc_eq$word[nrc_eq$sentiment > 0], collapse=" "),
#  paste(tweets.df$text[emotions$anticipation > 0], collapse=" "),
#  paste(tweets.df$text[emotions$disgust > 0], collapse=" "),
#  paste(tweets.df$text[emotions$fear > 0], collapse=" "),
#  paste(tweets.df$text[emotions$joy > 0], collapse=" "),
#  paste(tweets.df$text[emotions$sadness > 0], collapse=" "),
#  paste(tweets.df$text[emotions$surprise > 0], collapse=" "),
#  paste(tweets.df$text[emotions$trust > 0], collapse=" ")
#)

# If you did end up making above lines of codes work, can you let me know how?? ##
