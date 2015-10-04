# Computes the document frequency of each dish in the restaurant reviews corpus.
if(!require(dplyr)){
  
  install.packages("dplyr")
  
}

require(dplyr)

if(!require(tm)){
  
  install.packages("tm")
  
}

require(tm)

require(parallel)

if(!require(RWeka)){
  
  install.packages("RWeka")
  
}

require(RWeka)

require(qdap)
require(slam)
require(stringr)


load('data/R/restaurant_ids.RData')
load('results/dish_discovery/italian/italian_dishes_clean.txt')
load('results/dish_discovery/chinese/chinese_dishes_clean.txt')
load('results/dish_discovery/american/american_dishes_clean.txt')
load('results/dish_discovery/indian/indian_dishes_clean.txt')
load('results/dish_discovery/mediterranean/mediterranean_dishes_clean.txt')
load('results/dish_discovery/mexican/mexican_dishes_clean.txt')



load('data/R/review.RData')


restaurant.reviews <- review %>% select(review_id,text) %>% filter(review_id %in% review_restaurant_id)
rownames(restaurant.reviews) <- restaurant.reviews$review_id



# Preprocess the texts:
# 1- remove non-printable characters.
# 2- strip extra whitespaces
# 3- conver the text to lowercase
# 4- remove punctuation
# 5- remove numbers.

restaurant.reviews <- restaurant.reviews %>% 
  mutate(text=iconv(text,to="ASCII",sub="")) %>%
  mutate(text=stripWhitespace(text)) %>%
  mutate(text=tolower(text)) %>%
  mutate(text=removePunctuation(text)) %>%
  mutate(text=removeNumbers(text))


restaurant.reviews$text <- paste0(" ",restaurant.reviews$text," ")

if(!file.exists("results/dish_ranking/italian_dishes_freq.RData")){
italian_clean <- paste0(" ",italian_clean," ")

italian.dish.counts <- termco_d(restaurant.reviews$text,match.string=italian_clean)






# Save the results

italian.dish.counts.matrix <- as.simple_triplet_matrix(attr(italian.dish.counts$raw,"by.row") %>% select(-all,-word.count))

rownames(italian.dish.counts.matrix) <- review_restaurant_id


save(italian.dish.counts,review_restaurant_id,italian.dish.counts.matrix,file="results/dish_ranking/italian_dishes_freq.RData")
}

if(!file.exists("results/dish_ranking/chinese_dishes_freq.RData")){
  chinese_clean <- paste0(" ",chinese_clean," ")
  
  
  
  chinese.dish.counts <- termco_d(restaurant.reviews$text,match.string=chinese_clean)
  

  
  # Save the results
  
  chinese.dish.counts.matrix <- as.simple_triplet_matrix(attr(chinese.dish.counts$raw,"by.row") %>% select(-all,-word.count))
  
  rownames(chinese.dish.counts.matrix) <- review_restaurant_id
  
  
  save(chinese.dish.counts,review_restaurant_id,chinese.dish.counts.matrix,file="results/dish_ranking/chinese_dishes_freq.RData")
}


if(!file.exists("results/dish_ranking/indian_dishes_freq.RData")){
  indian_clean <- paste0(" ",indian_clean," ")
  
  
  
  indian.dish.counts <- termco_d(restaurant.reviews$text,match.string=indian_clean)
  
  
  
  # Save the results
  
  indian.dish.counts.matrix <- as.simple_triplet_matrix(attr(indian.dish.counts$raw,"by.row") %>% select(-all,-word.count))
  
  rownames(indian.dish.counts.matrix) <- review_restaurant_id
  
  
  save(indian.dish.counts,review_restaurant_id,indian.dish.counts.matrix,file="results/dish_ranking/indian_dishes_freq.RData")
}


if(!file.exists("results/dish_ranking/mexican_dishes_freq.RData")){
  mexican_clean <- paste0(" ",mexican_clean," ")
  
  
  
  mexican.dish.counts <- termco_d(restaurant.reviews$text,match.string=mexican_clean)
  
  
  
  # Save the results
  
  mexican.dish.counts.matrix <- as.simple_triplet_matrix(attr(mexican.dish.counts$raw,"by.row") %>% select(-all,-word.count))
  
  rownames(mexican.dish.counts.matrix) <- review_restaurant_id
  
  
  save(mexican.dish.counts,review_restaurant_id,mexican.dish.counts.matrix,file="results/dish_ranking/mexican_dishes_freq.RData")
}


if(!file.exists("results/dish_ranking/mediterranean_dishes_freq.RData")){
  mediterranean_clean <- paste0(" ",mediterranean_clean," ")
  
  
  
  mediterranean.dish.counts <- termco_d(restaurant.reviews$text,match.string=mediterranean_clean)
  
  
  
  # Save the results
  
  mediterranean.dish.counts.matrix <- as.simple_triplet_matrix(attr(mediterranean.dish.counts$raw,"by.row") %>% select(-all,-word.count))
  
  rownames(mediterranean.dish.counts.matrix) <- review_restaurant_id
  
  
  save(mediterranean.dish.counts,review_restaurant_id,mediterranean.dish.counts.matrix,file="results/dish_ranking/mediterranean_dishes_freq.RData")
}

if(!file.exists("results/dish_ranking/american_dishes_freq.RData")){
  american_clean <- paste0(" ",american_clean," ")
  
  
  
  american.dish.counts <- termco_d(restaurant.reviews$text,match.string=american_clean)
  
  
  
  # Save the results
  
  american.dish.counts.matrix <- as.simple_triplet_matrix(attr(american.dish.counts$raw,"by.row") %>% select(-all,-word.count))
  
  rownames(american.dish.counts.matrix) <- review_restaurant_id
  
  
  save(american.dish.counts,review_restaurant_id,american.dish.counts.matrix,file="results/dish_ranking/american_dishes_freq.RData")
}
