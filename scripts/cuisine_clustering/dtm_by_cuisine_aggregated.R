# Aggregates the DTM of positive useful restaurant reviews by cuisine label. For that it concatenates all the documents for each label.

if(!require(slam)){
  install.packages("slam",dependencies=TRUE)
}

require(slam)


# Load the DTM for positive restaurant reviews for a subset of restaurant categories
load('results/language_models/restaurant.cuisines.subsample.RData')

# Load the list of review ids grouped by cuisine.
load('data/R/restaurant_reviews_ids_by_cuisine.RData')

dtm <- dtm.cuisine.subsample.review.unigram 

# For each cuisine, get the list of reviews for that cuisine and compute the marginal frequencies of words for those reviews. 
# This is the same that concatenating the texts and recomputing the dtm.

dtm.by.cuisine <- lapply(reviews.by.cuisine,function(x){ 
  # Select the rows in the dtm corresponding to reviews for the cuisine
  dtm.reviews.cuisine <- dtm[rownames(dtm) %in% x$review_id,]
  
  # Compute the marginal word frequencies for the cuisine.
  rollup(dtm.reviews.cuisine,1,FUN=sum)

    })

# Concatenate in one matrix
dtm.aggregated <- do.call(rbind,dtm.by.cuisine)

# Name the cuisines
rownames(dtm.aggregated) <- cuisines





####### Balanced sample

dtm.by.cuisine.balanced <- lapply(reviews.by.cuisine,function(x){ 
  # Select the rows in the dtm corresponding to reviews for the cuisine
  
  set.seed(150)
  dtm.reviews.cuisine <- dtm[rownames(dtm) %in% sample(x$review_id,min(length(x$review_id),10000)),]
  
  # Compute the marginal word frequencies for the cuisine.
  rollup(dtm.reviews.cuisine,1,FUN=sum)
  
})

# Concatenate in one matrix
dtm.aggregated.balanced <- do.call(rbind,dtm.by.cuisine.balanced)

# Name the cuisines
rownames(dtm.aggregated.balanced) <- cuisines

#Save result

save(dtm.aggregated,dtm.aggregated.balanced,file='results/language_models/restaurant.cuisines.subsample.aggregated.RData')


