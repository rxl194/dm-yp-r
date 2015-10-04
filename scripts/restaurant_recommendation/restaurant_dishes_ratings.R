# Computes the dishes-restaurants ratings matrix for 6 cuisines and for the 4 scored used to rank dishes
require(stringr)
require(dplyr)
require(slam)




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


business.ratings <- function(dish.counts.matrix,restaurant.review){
  
  dishes <- str_match(colnames(dish.counts.matrix),"term\\( (.+) \\)")[,2]
  colnames(dish.counts.matrix) <- dishes
  
  dish.document.frequency <- dish.counts.matrix >0
  
  dish.document.frequency$v <- dish.document.frequency$v*1
  
  
  
  
  
  stars <- restaurant.review %>% select(review_id,stars)
  
  stars <- stars[match(stars$review_id,rownames(dish.document.frequency)),2]
  
  dishes.stars <- do.call(cbind,colapply_simple_triplet_matrix(dish.document.frequency,function(x) {
    
    as.simple_triplet_matrix(x*stars)
  }))
  
  colnames(dishes.stars) <- colnames(dish.document.frequency)
  rownames(dishes.stars) <- rownames(dish.document.frequency)
  
  
  
  load('results/topic_models/restaurant_reviews_all_3.RData')
  
  doc.p <- data.frame(fit@gamma)[,2]
  names(doc.p) <- fit@documents
  
  dish.document.freq.topic <- dish.document.frequency[names(doc.p),]
  
  dish.document.freq.topic <- do.call(cbind,colapply_simple_triplet_matrix(dish.document.freq.topic,function(x) {
    
    as.simple_triplet_matrix(x*doc.p)
  }))
  
  
  dish.stars.topic <- dishes.stars[names(doc.p),]
  
  dish.stars.topic <- do.call(cbind,colapply_simple_triplet_matrix(dish.stars.topic,function(x) {
    
    as.simple_triplet_matrix(x*doc.p)
  }))
  
  
  load('data/R/business.RData')
  
  
  business_id <- restaurant.review$business_id[match(rownames(dish.document.frequency), restaurant.review$review_id)]
  
  business_id.topic <- restaurant.review$business_id[match(rownames(dish.document.freq.topic), restaurant.review$review_id)]
  
  dish.business.frequency <- dish.document.frequency
  
  
  
  dish.business.frequency <- do.call(rbind,lapply(unique(business_id),function(business){
    
    result <- as.simple_triplet_matrix(t(col_sums(dish.business.frequency[which(business_id==business),])))
    rownames(result) <- business
    result
  }))
  
  
  dish.business.stars <- dishes.stars
  
  
  
  dish.business.stars <- do.call(rbind,lapply(unique(business_id),function(business){
    
    n.reviews <- col_sums(dish.business.stars[which(business_id==business),] >0) 
    total.stars <- col_sums(dish.business.stars[which(business_id==business),])
    total.stars[n.reviews >0] <- total.stars[n.reviews >0]/n.reviews[n.reviews >0]
    result <- as.simple_triplet_matrix(t(total.stars))
    rownames(result) <- business
    result
  }))
  
  
  
  
  dish.business.frequency.topic <- dish.document.freq.topic
  
  
  
  dish.business.frequency.topic <- do.call(rbind,lapply(unique(business_id.topic),function(business){
    
    result <- as.simple_triplet_matrix(t(col_sums(dish.business.frequency.topic[which(business_id.topic==business),])))
    rownames(result) <- business
    result
  }))
  
  
  dish.business.stars.topics <- dish.stars.topic
  
  
  
  dish.business.stars.topics <- do.call(rbind,lapply(unique(business_id.topic),function(business){
    
    
    
    n.reviews <- col_sums(dishes.stars[which(business_id==business),] >0) 
    weights <- dish.document.freq.topic[which(business_id.topic==business),]
    
    stars <- dishes.stars[rownames(weights),]
    
    
    
    total.stars <- col_sums(stars*weights)
    
    
    total.stars[n.reviews >0] <- total.stars[n.reviews >0]/n.reviews[n.reviews >0]
    result <- as.simple_triplet_matrix(t(total.stars))
    rownames(result) <- business
    result
  }))
  
  list(dish.business.frequency=dish.business.frequency,dish.business.stars=dish.business.stars,dish.business.frequency.topic=dish.business.frequency.topic,dish.business.stars.topics=dish.business.stars.topics)
}


italian.business.ratings <- business.ratings(italian.dish.counts.matrix,restaurant.review)

chinese.business.ratings <- business.ratings(chinese.dish.counts.matrix,restaurant.review)

indian.business.ratings <- business.ratings(indian.dish.counts.matrix,restaurant.review)

mexican.business.ratings <- business.ratings(mexican.dish.counts.matrix,restaurant.review)

mediterranean.business.ratings <- business.ratings(mediterranean.dish.counts.matrix,restaurant.review)

american.business.ratings <- business.ratings(american.dish.counts.matrix,restaurant.review)

save(italian.business.ratings,chinese.business.ratings,indian.business.ratings,mexican.business.ratings,mediterranean.business.ratings,american.business.ratings,file='results/restaurant_recommendation/dish_rating_matrices.RData')
