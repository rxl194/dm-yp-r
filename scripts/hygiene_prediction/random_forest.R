require(caret)
require(ROCR)
require(dplyr)
require(slam)
require(topicmodels)

#load('results/hygiene_prediction/reviews_topic_model_label1_100.RData')

load('results/hygiene_prediction/data.RData')

load('results/hygiene_prediction/reviews.unigram.reduced.RData')

#gamma <- posterior(fit,dtm.review.bigram[1:100,])

#all <- as.character(1:sum(nrow(training),nrow(test)))

#all.training <- all[1:nrow(training)]

#all.test <- all[(nrow(training)+1):length(all)]

#topics.training <- fit@gamma[match(all.training,fit@documents),]

#topics.test <- fit@gamma[match(all.test,fit@documents),]

#topics.test[is.na(rowSums(topics.test)),] <- 1/ncol(topics.test)


training <- training %>% select(-reviews_text,-restaurant_cuisines)


training <- cbind(training[match(training$id,rownames(dtm.review.unigram)),],data.frame(as.matrix(dtm.review.unigram[as.character(1:546),])))
#training <- cbind(training,topics.training)

training <- training %>% select(-id)

x <- test %>% filter(id %in% rownames(dtm.review.unigram))

test <- cbind(x,data.frame(as.matrix(dtm.review.unigram[(nrow(training)+1):nrow(dtm.review.unigram),])))
#test <- cbind(test,topics.test)


set.seed(200)
train.index <- createDataPartition(y = training$hygiene_label,p=0.8,list = FALSE)

train.set <- training[train.index,]
test.set <- training[-train.index,]

F1 <- function(data,lev,model){

  pred <- prediction(as.numeric(as.character(data$pred)), as.numeric(as.character(data$obs)))
  out <-performance(pred,"f")@y.values[[1]][2]
  names(out) <- "F1"
  out
}

resampling.control <- trainControl(method="cv",number=10,verboseIter = TRUE,summaryFunction = F1)

rfFit <- train(factor(hygiene_label) ~ ., data=train.set, method="rf",trControl=resampling.control)

trellis.par.set(caretTheme())
plot(rfFit)

pred <- predict(rfFit,newdata = test.set)

performance(prediction(as.numeric(as.character(pred)),as.numeric(as.character(test.set$label))),"f")

submission.prediction <- as.character(predict(rfFit,newdata=test))

save(rfFit,submission.prediction,file="results/hygiene_prediction/random_forest.RData")
