# Computes a topic model for the corpus of restaurant reviews. 3 topics

if(!require(topicmodels)){
  install.packages("topicmodels",dependencies = TRUE)
}
require(topicmodels)

if(!require(dplyr)){
  install.packages("dplyr",dependencies = TRUE)
}

require(dplyr)


require(slam)





load('results/hygiene_prediction/review.unigram.RData')

load('results/hygiene_prediction/data.RData')


#dtm.review.unigram <- dtm.review.unigram[which(training$label==1),]




empty <- which(row_sums(dtm.review.unigram)==0)

dtm.review.unigram <- dtm.review.unigram[-empty,]

seed <- 200



n.topics <- 50






fit <- LDA(dtm.review.unigram, n.topics,method="Gibbs",control = list(seed=seed,verbose=100,thin=100,burnin=1000))  





save(fit,file=paste0("results/hygiene_prediction/reviews_topic_model_50.RData"))







