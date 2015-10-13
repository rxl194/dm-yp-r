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


load('results/hygiene_prediction/reviews_topic_model_label1_100.RData')
load('results/hygiene_prediction/reviews.unigram.RData')

topics.training <- data.frame(id=fit@documents,fit@gamma,stringsAsFactors = FALSE)
missing.training <- training$id[!training$id %in% fit@documents ]
posterior.topics.training <- posterior(fit,dtm.review.unigram[missing.training,])
posteriors.prob <- data.frame(id=missing.training,posterior.topics.training$topics,stringsAsFactors = FALSE)
topics.training <- rbind(topics.training,posteriors.prob) %>% arrange(as.numeric(id))
if(file.exists("results/hygiene_prediction/posteriors.test.label1.RData")){
  load("results/hygiene_prediction/posteriors.test.label1.RData")
}else{
  posterior.topics.test <- posterior(fit,dtm.review.unigram[rownames(dtm.review.unigram) %in% test$id,])
  save(posterior.topics.test,file="results/hygiene_prediction/posteriors.test.label1.RData")
}
text <- test[which(!test$id %in% rownames(dtm.review.unigram)),]$reviews_text
text <- gsub("\\."," ",text)
text <- tolower(text)
text <- str_split(text," ")
text <- stemDocument(text[[1]])
new_line <- simple_triplet_zero_matrix(1,ncol=ncol(dtm.review.unigram))
rownames(new_line) <- test[which(!test$id %in% rownames(dtm.review.unigram)),]$id
colnames(new_line) <- colnames(dtm.review.unigram)
new_line[1,which(colnames(new_line) %in% text)] <- 1
x <- posterior(fit,new_line)$topics

x <- data.frame(id=test[which(!test$id %in% rownames(dtm.review.unigram)),]$id,x,stringsAsFactors = FALSE)
posteriors.prob <- data.frame(id=rownames(dtm.review.unigram[which(rownames(dtm.review.unigram) %in% test$id),]),posterior.topics.test$topics,stringsAsFactors = FALSE)

topics.test <- rbind(posteriors.prob,x) %>% arrange(as.numeric(id)) %>% select(-id)



training <- cbind(training,topics.training %>% dplyr::select(-id))



test <- cbind(test,topics.test)






save(training,test,file="results/hygiene_prediction/training_test_topic_model_label1_100.RData")
