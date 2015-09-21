# Computes topic model with k=20 for dtm of concatenated positive useful restaurant reviews of a subset of restaurant categories.

if(!require(topicmodels)){
  install.packages("topicmodels",dependencies=TRUE)
}
require(topicmodels)



seed <- 200

dtm.aggregated.LDA <- LDA(dtm.aggregated, 20,method="Gibbs",control = list(seed=seed,verbose=100,thin=100,burnin=1000))  


save(dtm.aggregated.LDA,file='results/topic_models/aggregated_by_cuisine.RData')