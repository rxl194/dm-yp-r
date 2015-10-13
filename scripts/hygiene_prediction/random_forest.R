require(caret)
require(ROCR)
require(dplyr)
require(slam)
require(topicmodels)
require(ggplot2)
require(tm)
require(stringr)
require(RWeka)

load('results/hygiene_prediction/training_test_dtm_unigram.RData')
training.dtm <- training[,-c(1:7)]
test.dtm <- test[,-c(1:6)]
load("results/hygiene_prediction/training_test_topic_model_50.RData")

test.topic <- test %>% dplyr::select(T=starts_with("X"))
training.topic <- training %>% dplyr::select(T=starts_with("X"))

load("results/hygiene_prediction/training_test_topic_model_label1_100.RData")

training <- cbind(training,training.topic,training.dtm)
test <- cbind(test,test.topic,test.dtm)


cuisines.factor <- function(dataset){
  cuisines <- str_split(gsub("\\[|\\]|'","",dataset$restaurant_cuisines),",")
  cuisines <- rbind_all(lapply(cuisines,function(x){
    
    r <- data.frame(t(rep(1,length(x))))
    colnames(r) <- x
    r
  }))
  
  cuisines[is.na(cuisines)] <- 0
  
  cuisines <-cuisines %>% mutate_each(funs(factor))
  
  cuisines
  
}




training <- cbind(training,cuisines.factor(training))

training <- training %>% dplyr::select(-reviews_text,-restaurant_cuisines,-id)

test <- cbind(test,cuisines.factor(test))
#training <- training %>% mutate(hygiene_label=factor(hygiene_label))

set.seed(200)
train.index <- createDataPartition(y = training$hygiene_label,p=0.8,list = FALSE)

train.set <- training[train.index,]
test.set <- training[-train.index,]

F1 <- function(data,lev,model){
  
  pred <- prediction(as.numeric(as.character(data$pred)), as.numeric(as.character(data$obs)))
  out <-performance(pred,"f")@y.values[[1]][2]
  names(out) <- c("F1")
  out
}

resampling.control <- trainControl(method="cv",number=10,verboseIter = TRUE,summaryFunction = F1)

mtryGrid <-data.frame(mtry=c(2,seq(5000,ncol(train.set)-1,5000)))
set.seed(300)
rfFit <- train(hygiene_label ~ ., data=train.set, method="rf",trControl=resampling.control,tuneGrid=mtryGrid)

plot(rfFit)

pred <- predict(rfFit,newdata = test.set)

pred <- prediction(as.numeric(as.character(pred)),as.numeric(as.character(test.set$hygiene_label)))


perf<- performance(pred,"tpr","fpr")

ggplot(data.frame(FP=perf@x.values[[1]],TP=perf@y.values[[1]]),aes(x=FP,y=TP))+geom_line()+geom_abline(slope=1)

performance(pred,"auc")

perf<- performance(pred,"f")

cutoff <- perf@x.values[[1]][which.max(perf@y.values[[1]])]

ggplot(data.frame(cutoff=perf@x.values[[1]],F1=perf@y.values[[1]]),aes(x=cutoff,y=F1))+geom_line()

perf<- performance(pred,"sens")

ggplot(data.frame(cutoff=perf@x.values[[1]],sens=perf@y.values[[1]]),aes(x=cutoff,y=sens))+geom_line()


submission.prediction <- as.character(as.numeric(predict(rfFit,newdata = test) >= 0.5))

sum(submission.prediction=="1")/length(submission.prediction)

save(rfFit,submission.prediction,train.set,test.set,test,file="results/hygiene_prediction/random_forest_dtm_unigram_topic_model_50_label1_100.RData")
