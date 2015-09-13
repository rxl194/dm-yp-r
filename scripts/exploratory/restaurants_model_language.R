require(tm)

require(slam)

require(ggplot2)

require(dplyr)

load('results/language_models/review.unigram.RData')
load('data/R/restaurant_ids.RData')


dtm.restaurant.review.unigram <- dtm.review.unigram[review_restaurant_id,]

doc.freq <- rollup(dtm.restaurant.review.unigram,2,FUN=sum)

is.empty <- as.vector(doc.freq ==0)

dtm.restaurant.review.unigram <- dtm.restaurant.review.unigram[!is.empty,]

word.freq <- rollup(dtm.restaurant.review.unigram,1,FUN=sum)

is.empty <- as.vector(word.freq ==0)

dtm.restaurant.review.unigram <- dtm.restaurant.review.unigram[,!is.empty]


word.freq <- rollup(dtm.restaurant.review.unigram,1,FUN=sum)



word.freq <- data.frame(word=colnames(word.freq),word.freq=matrix(word.freq),stringsAsFactors = FALSE)

word.freq <- word.freq %>% arrange(desc(word.freq))



ggplot(word.freq,aes(x=word.freq))+geom_histogram(binwidth=10,color="black",fill="red")+xlim(0,1000)


frequent.words <- word.freq %>% mutate(cummperc=cumsum(word.freq)/sum(word.freq))


ggplot(frequent.words,aes(x=1:nrow(frequent.words),y=cummperc))+geom_line()+geom_hline(aes(yintercept = 0.99))+xlim(0,15000)

selected.words <- frequent.words %>% filter(cummperc <=0.99)


dtm.restaurant.review.unigram <- dtm.restaurant.review.unigram[,selected.words$word]

doc.freq <- rollup(dtm.restaurant.review.unigram,2,FUN=sum)

is.empty <- as.vector(doc.freq ==0)

dtm.restaurant.review.unigram <- dtm.restaurant.review.unigram[!is.empty,]

save(dtm.restaurant.review.unigram,file="results/language_models/restaurant.reviews.unigram.RData")
