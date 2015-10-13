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
load('results/hygiene_prediction/reviews.unigram.reduced.RData')





training <- cbind(training[match(training$id,rownames(dtm.review.unigram)),],data.frame(as.matrix(dtm.review.unigram[as.character(1:546),])))

test.ids <- test$id

missing.test <- test %>% filter(id %in% test.ids[!test.ids %in% rownames(dtm.review.unigram)])
missing.test <- cbind(missing.test, t(rep(0,ncol(dtm.review.unigram))))
x <- test %>% filter(id %in% rownames(dtm.review.unigram))

test <- cbind(x,data.frame(as.matrix(dtm.review.unigram[(nrow(training)+1):nrow(dtm.review.unigram),])))



names(missing.test) <- names(test)


test <- rbind(test,missing.test)

test <- test[order(as.numeric(test$id),decreasing = TRUE),]

save(training,test,file="results/hygiene_prediction/training_test_dtm_unigram.RData")
