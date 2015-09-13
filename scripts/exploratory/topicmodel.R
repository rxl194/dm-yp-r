if(!require(topicmodels)){
  install.packages("topicmodels")
}
require(topicmodels)


require(dplyr)

require(caret)





load('results/language_models/restaurant.reviews.unigram.RData')









seed <- 200

set.seed(seed)



training <- as.vector(unlist(createDataPartition(1:nrow(dtm.restaurant.review.unigram),p=0.2)))


n.topics <- c(seq(2,20, by=2),seq(30,100,by=10))

for(k in n.topics){
  
  
    print(paste0(Sys.time()," N topics:",k))

  fit <- LDA(dtm.restaurant.review.unigram[training,], k,method="Gibbs",control = list(seed=seed,verbose=100,thin=100,burnin=1000))  
  
  
  
  ll <- as.numeric(logLik(fit))
  
  
  print(paste0("N topics:",k))
  print(paste0("LogLikelihood:",ll))
  
  print(data.frame(terms(fit,10),stringsAsFactors = FALSE))
  
  topics.reviews <- posterior(fit)
  
  print(head(topics.reviews$topics))
  
  save(k,ll,fit,file=paste0("results/topic_models/exploratory/review_topics_LDA_Gibbs_k_",k,".RData"))
  
}





