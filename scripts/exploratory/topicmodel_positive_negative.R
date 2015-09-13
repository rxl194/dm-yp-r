if(!require(topicmodels)){
  install.packages("topicmodels")
}
require(topicmodels)


require(dplyr)

require(caret)

vars1 <- load('results/language_models/restaurant.reviews.unigram.positive.negative.RData')




seed <- 200




set.seed(seed)
n <- min(nrow(dtm.restaurant.review.unigram.positive),nrow(dtm.restaurant.review.unigram.negative))
training.positive <- sample(1:nrow(dtm.restaurant.review.unigram.positive),size=n)
training.negative <- sample(1:nrow(dtm.restaurant.review.unigram.negative),size=n)

n.topics <- 20


restaurant.reviews.positive.topicmodel <- LDA(dtm.restaurant.review.unigram.positive[training.positive,], n.topics,method="Gibbs",control = list(seed=seed,verbose=100,thin=100,burnin=1000))  

restaurant.reviews.negative.topicmodel <- LDA(dtm.restaurant.review.unigram.negative[training.negative,], n.topics,method="Gibbs",control = list(seed=seed,verbose=100,thin=100,burnin=1000))  



save(restaurant.reviews.positive.topicmodel,restaurant.reviews.negative.topicmodel,file="results/topic_models/review_topics_positive_negative.RData")
