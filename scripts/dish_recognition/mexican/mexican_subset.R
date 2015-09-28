# Extracts all the useful positive reviews for mexican restaurants.

if(!require(tm)){
  install.packages("tm",dependencies = TRUE)
}

require(tm)


if(!require(slam)){
  install.packages("slam",dependencies = TRUE)
}

require(slam)


if(!require(dplyr)){
  install.packages("dplyr",dependencies = TRUE)
}

require(dplyr)

if(!require(openNLP)){
  install.packages("openNLP")
}

require(openNLP)

# Load reviews ids by cuisines

load('data/R/restaurant_reviews_ids_by_cuisine.RData')

load('data/R/useful_restaurant_review_id.RData')

load('data/R/restaurant_reviews_id_positive_negative.RData')

# Select mexican cuisine reviews

mexican.reviews.ids <- reviews.by.cuisine[["Mexican"]]$review_id

mexican.reviews.positive.useful <- intersect(intersect(mexican.reviews.ids,positive_review_restaturant_id), useful_restaurant_review_id)


# Load the reviews and keep only mexican positive useful reviews

load('data/R/review.RData')

mexican.positive.useful <- review %>% select(review_id,text) %>% filter(review_id %in% mexican.reviews.positive.useful)

rm(review)


sent_token_annotator <- Maxent_Sent_Token_Annotator(language = 'en')    

mexican.positive.useful.sentences <- do.call(c,lapply(mexican.positive.useful$text,function(text){
  
  s <- as.String(text)
  result <- s[annotate(s, list(sent_token_annotator))]
  result
  
}))




f <- file('results/dish_discovery/mexican/mexican_positive_useful_corpus.txt')
writeLines(mexican.positive.useful$text,f)
close(f)



f <- file('results/dish_discovery/mexican/mexican_positive_useful_sentences_corpus.txt')
writeLines(mexican.positive.useful.sentences,f)
close(f)


