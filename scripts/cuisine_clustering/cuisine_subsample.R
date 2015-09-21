# Loads the document-term matrix of restaurant reviews and saves a subset dtm of positive useful reviews for a subset of restaurant categories.

if(!require(slam)){
  install.packages("slam",dependencies=TRUE)
}

require(slam)


# Load the document-term matrix of restaurant reviews

load("results/language_models/restaurant.reviews.unigram.RData")

# Load the review ids for our subset of restaurant categories

load("data/R/restaurant_reviews_ids_by_cuisine.RData")

# Load ids of positive and negative restaurant reviews

load("data/R/restaurant_reviews_id_positive_negative.RData")

# Load ids of useful restaurant reviews

load("data/R/useful_restaurant_review_id.RData")


# Select only positive and useful restaurant reviews

positive_useful_reviews_id <- intersect(positive_review_restaturant_id,useful_restaurant_review_id)


# Filter the reviews of our subset of restaurant categories

reviews.by.cuisine <- lapply(reviews.by.cuisine,function(cuisine){
  
  list(cuisine=cuisine$cuisine,review_id=intersect(cuisine$review_id,positive_useful_reviews_id))
  
})



reviews.by.cuisine.sample.ids <- unique(unlist(lapply(reviews.by.cuisine,function(x) x$review_id)))

# Subset the restaurants reviews document-term matrix to keep only positive useful restaurant reviews

dtm.cuisine.subsample.review.unigram <- dtm.restaurant.review.unigram[rownames(dtm.restaurant.review.unigram) %in% reviews.by.cuisine.sample.ids, ]

# Remove terms with count 0

word.freq <- rollup(dtm.cuisine.subsample.review.unigram,1,FUN=sum)

is.empty <- as.vector(word.freq ==0)

dtm.cuisine.subsample.review.unigram <- dtm.cuisine.subsample.review.unigram[,!is.empty]


# Save results

save(dtm.cuisine.subsample.review.unigram,file="results/language_models/restaurant.cuisines.subsample.RData")
