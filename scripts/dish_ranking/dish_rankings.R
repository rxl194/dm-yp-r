# Computes dish rankings for 6 cuisines using 4 scores: document frequency, average review stars, and versions of the two scores weighted by the probability that the reviews belong to a food topic.

require(stringr)
require(dplyr)
require(slam)
require(qdap)

load('results/dish_ranking/italian_dishes_freq.RData')
rm(italian.dish.counts)

load('results/dish_ranking/chinese_dishes_freq.RData')
rm(chinese.dish.counts)

load('results/dish_ranking/mexican_dishes_freq.RData')
rm(mexican.dish.counts)

load('results/dish_ranking/indian_dishes_freq.RData')
rm(indian.dish.counts)

load('results/dish_ranking/mediterranean_dishes_freq.RData')
rm(mediterranean.dish.counts)

load('results/dish_ranking/american_dishes_freq.RData')
rm(american.dish.counts)



load('data/R/review.RData')
restaurant.review <- review[review$review_id %in% review_restaurant_id,]

rm(review)

load('results/topic_models/restaurant_reviews_all_3.RData')

doc.p <- data.frame(fit@gamma)[,2]
names(doc.p) <- fit@documents


rm(fit)

compute.dish.rankings <- function(dish.counts.matrix,restaurant.review,doc.p){
  dishes <- str_match(colnames(dish.counts.matrix),"term\\( (.+) \\)")[,2]
  colnames(dish.counts.matrix) <- dishes
  
  dish.document.frequency <- dish.counts.matrix >0
  
  dish.document.frequency$v <- dish.document.frequency$v*1
  
  dish.rankings <- data.frame(dishes=dishes,doc.freq=col_sums(dish.counts.matrix >0),stringsAsFactors = FALSE)
  
  
  ############### Stars
  
  stars <- restaurant.review %>% select(review_id,stars)
  
  stars <- stars[match(stars$review_id,rownames(dish.document.frequency)),2]
  
  dishes.stars <- do.call(cbind,colapply_simple_triplet_matrix(dish.document.frequency,function(x) {
    
    as.simple_triplet_matrix(x*stars)
  }))
  
  colnames(dishes.stars) <- colnames(dish.document.frequency)
  rownames(dishes.stars) <- rownames(dish.document.frequency)
  
  mean.stars <- col_sums(dishes.stars)
  
  mean.stars[dish.rankings$doc.freq >0] <- mean.stars[dish.rankings$doc.freq >0]/dish.rankings$doc.freq[dish.rankings$doc.freq>0]
  
  mean.stars <- mean.stars*(dish.rankings$doc.freq>0)
  
  dish.rankings <- dish.rankings %>% mutate(stars=mean.stars)
  
  
  ##### Topic model
  
  
  
  
  
  dish.document.freq.topic <- dish.document.frequency[names(doc.p),]
  
  dish.document.freq.topic <- do.call(cbind,colapply_simple_triplet_matrix(dish.document.freq.topic,function(x) {
    
    as.simple_triplet_matrix(x*doc.p)
  }))
  
  dish.rankings <- dish.rankings %>% mutate(doc.freq.topic=col_sums(dish.document.freq.topic))
  
  
  ##### Topic model stars
  
  dish.stars.topic <- dishes.stars[names(doc.p),]
  
  dish.stars.topic <- do.call(cbind,colapply_simple_triplet_matrix(dish.stars.topic,function(x) {
    
    as.simple_triplet_matrix(x*doc.p)
  }))
  mean.stars <- col_sums(dish.stars.topic)
  mean.stars[dish.rankings$doc.freq >0] <- mean.stars[dish.rankings$doc.freq >0]/dish.rankings$doc.freq[dish.rankings$doc.freq>0]
  dish.rankings <- dish.rankings %>% mutate(stars.topic=mean.stars)
  
}


italian.dish.rankings <- compute.dish.rankings(italian.dish.counts.matrix,restaurant.review,doc.p)

chinese.dish.rankings <- compute.dish.rankings(chinese.dish.counts.matrix,restaurant.review,doc.p)

indian.dish.rankings <- compute.dish.rankings(indian.dish.counts.matrix,restaurant.review,doc.p)

mexican.dish.rankings <- compute.dish.rankings(mexican.dish.counts.matrix,restaurant.review,doc.p)

mediterranean.dish.rankings <- compute.dish.rankings(mediterranean.dish.counts.matrix,restaurant.review,doc.p)

american.dish.rankings <- compute.dish.rankings(american.dish.counts.matrix,restaurant.review,doc.p)

save(italian.dish.rankings,chinese.dish.rankings,indian.dish.rankings,mexican.dish.rankings,mediterranean.dish.rankings,american.dish.rankings,file='results/dish_ranking/dish_rankings.RData')





