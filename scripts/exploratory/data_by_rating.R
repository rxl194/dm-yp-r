vars1 <- load('data/R/restaurant_ids.RData')


vars2 <- load('data/R/review.RData')

review.restaurant <- review[review$review_id %in% review_restaurant_id,]

positive_review_restaturant_id <- review.restaurant[review.restaurant$stars >3,"review_id"]
negative_review_restaurant_id <- review.restaurant[review.restaurant$stars < 3,"review_id"]


rm(review.restaurant,list=c(vars1,vars2))
rm(vars1,vars2)

vars3 <- load('results/language_models/restaurant.reviews.unigram.RData')

dtm.restaurant.review.unigram.positive <- dtm.restaurant.review.unigram[rownames(dtm.restaurant.review.unigram) %in% positive_review_restaturant_id,]
dtm.restaurant.review.unigram.negative <- dtm.restaurant.review.unigram[rownames(dtm.restaurant.review.unigram) %in% negative_review_restaurant_id,]


rm(list=vars3)
rm(vars3)

save(dtm.restaurant.review.unigram.positive,dtm.restaurant.review.unigram.negative,file='results/language_models/restaurant.reviews.unigram.positive.negative.RData')
save(positive_review_restaturant_id,negative_review_restaurant_id,file="data/R/restaurant_reviews_id_positive_negative.RData")




