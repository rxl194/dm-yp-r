require(caret)
require(ROCR)
require(dplyr)
require(slam)
require(topicmodels)



load('results/hygiene_prediction/data.RData')

topic <- TRUE

if(topic){
  
  load('results/hygiene_prediction/reviews_topic_model_50.RData')
  
  
  topics.training <- fit@gamma[match(training$id,fit@documents),]
  
  topics.test <- fit@gamma[match(test$id,fit@documents),]
  
  topics.test[is.na(rowSums(topics.test)),] <- 1/ncol(topics.test)
  
  training <- cbind(training,topics.training)
  
  training <- training %>% select(-reviews_text,-restaurant_cuisines,-id)
  
  test <- cbind(test,topics.test)
  
}else{
  
  load('results/hygiene_prediction/reviews.unigram.reduced.RData')
  training <- training %>% select(-reviews_text,-restaurant_cuisines)
  
  
  training <- cbind(training[match(training$id,rownames(dtm.review.unigram)),],data.frame(as.matrix(dtm.review.unigram[as.character(1:546),])))
  training <- training %>% select(-id)
  
  x <- test %>% filter(id %in% rownames(dtm.review.unigram))
  
  test <- cbind(x,data.frame(as.matrix(dtm.review.unigram[(nrow(training)+1):nrow(dtm.review.unigram),])))
  
}




training <- training %>% mutate(hygiene_label=factor(hygiene_label))

set.seed(200)
train.index <- createDataPartition(y = training$hygiene_label,p=0.8,list = FALSE)

train.set <- training[train.index,]
test.set <- training[-train.index,]

F1 <- function(data,lev,model){
  
  pred <- prediction(as.numeric(as.character(data$pred)), as.numeric(as.character(data$obs)))
  out <-performance(pred,"f")@x.values[[1]][2]
  names(out) <- c("F1")
  out
}

resampling.control <- trainControl(method="cv",number=10,verboseIter = TRUE,summaryFunction = F1)

svmFit <- train(hygiene_label ~ ., data=train.set, method="svmPoly",trControl=resampling.control)


pred <- predict(svmFit,newdata = test.set,type="raw")

pred <- prediction(as.numeric(as.character(pred)),as.numeric(as.character(test.set$hygiene_label)))


perf<- performance(pred,"tpr","fpr")

ggplot(data.frame(FP=perf@x.values[[1]],TP=perf@y.values[[1]]),aes(x=FP,y=TP))+geom_line()+geom_abline(slope=1)

perf<- performance(pred,"auc")

perf<- performance(pred,"f")

ggplot(data.frame(cutoff=perf@x.values[[1]],F1=perf@y.values[[1]]),aes(x=cutoff,y=F1))+geom_line()

perf<- performance(pred,"sens")

ggplot(data.frame(cutoff=perf@x.values[[1]],sens=perf@y.values[[1]]),aes(x=cutoff,y=sens))+geom_line()

submission.prediction <- as.character(predict(svmFit,newdata=test))

save(svmFit,submission.prediction,file="results/hygiene_prediction/svm.RData")
