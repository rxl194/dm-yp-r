require(caret)
require(ROCR)
require(dplyr)
require(slam)
require(topicmodels)
require(ggplot2)
require(tm)
require(stringr)
require(RWeka)

load('results/hygiene_prediction/data.RData')
load('results/hygiene_prediction/reviews_topic_model_100.RData')
  
  
topics.training <- data.frame(fit@gamma[match(training$id,fit@documents),])
topics.test <- data.frame(fit@gamma[match(test$id,fit@documents),])
topics.test[is.na(rowSums(topics.test)),] <- 1/ncol(topics.test)

which(is.na(rowSums(topics.test)))




training <- cbind(training,topics.training)



test <- cbind(test,topics.test)

save(training,test,file="results/hygiene_prediction/training_test_topic_model_100.RData")
