require(slam)
require(dplyr)
require(ggplot2)

load('results/hygiene_prediction/review.unigram.RData')





word.freq <- rollup(dtm.review.unigram,1,FUN=sum)

is.empty <- as.vector(word.freq ==0)

dtm.review.unigram <- dtm.review.unigram[,!is.empty]


word.freq <- rollup(dtm.review.unigram,1,FUN=sum)



word.freq <- data.frame(word=colnames(word.freq),word.freq=matrix(word.freq),stringsAsFactors = FALSE)

word.freq <- word.freq %>% arrange(desc(word.freq))



ggplot(word.freq,aes(x=word.freq))+geom_histogram(binwidth=10,color="black",fill="red")+xlim(0,1000)


frequent.words <- word.freq %>% mutate(cummperc=cumsum(word.freq)/sum(word.freq))


ggplot(frequent.words,aes(x=1:nrow(frequent.words),y=cummperc))+geom_line()+geom_hline(aes(yintercept = 0.99))+xlim(0,15000)

selected.words <- frequent.words %>% filter(cummperc <=0.99)


dtm.review.unigram <- dtm.review.unigram[,selected.words$word]

doc.freq <- rollup(dtm.review.unigram,2,FUN=sum)

is.empty <- as.vector(doc.freq ==0)

dtm.review.unigram <- dtm.review.unigram[!is.empty,]


save(dtm.review.unigram,file="results/hygiene_prediction/reviews.unigram.reduced.RData")
