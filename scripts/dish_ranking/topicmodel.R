# Computes a topic model for the corpus of restaurant reviews. 3 topics

if(!require(topicmodels)){
  install.packages("topicmodels",dependencies = TRUE)
}
require(topicmodels)

if(!require(dplyr)){
  install.packages("dplyr",dependencies = TRUE)
}

require(dplyr)

if(!require(caret)){
  install.packages("caret",dependencies = TRUE)
}







load('results/language_models/restaurant.reviews.unigram.RData')









seed <- 200



n.topics <- 3


  
  
  
  
  fit <- LDA(dtm.restaurant.review.unigram, n.topics,method="Gibbs",control = list(seed=seed,verbose=100,thin=100,burnin=1000))  
  
  
  

  
  save(fit,file=paste0("results/topic_models/restaurant_reviews_all_3.RData"))
  






