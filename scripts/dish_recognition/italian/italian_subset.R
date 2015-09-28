# Extracts all the useful positive reviews for italian restaurants.

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

# Select italian cuisine reviews

italian.reviews.ids <- reviews.by.cuisine[["Italian"]]$review_id

italian.reviews.positive.useful <- intersect(intersect(italian.reviews.ids,positive_review_restaturant_id), useful_restaurant_review_id)


# Load the reviews and keep only italian positive useful reviews

load('data/R/review.RData')

italian.positive.useful <- review %>% select(review_id,text) %>% filter(review_id %in% italian.reviews.positive.useful)

rm(review)

#Save the subset.

f <- file('results/dish_discovery/italian/italian_positive_useful_corpus.txt')
writeLines(italian.positive.useful$text,f)
close(f)



