if(!require(dplyr)){
  
  install.packages("dplyr")
  
}

require(dplyr)

if(!require(tm)){
  
  install.packages("tm")
  
}

require(tm)

require(parallel)

if(!require(RWeka)){
  
  install.packages("RWeka")
  
}

require(RWeka)


load('data/R/review.RData')


review <- review %>% select(review_id,text)


ngram <- 1

language <- "en"



review <- review %>% 
  mutate(text=iconv(text,to="ASCII",sub="")) %>%
  mutate(text=stripWhitespace(text)) %>%
  mutate(text=tolower(text)) %>%
  mutate(text=removePunctuation(text)) %>%
  mutate(text=removeNumbers(text))

  


NgramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = ngram,delimiters = " \\r\\n\\t.,;:\"()?!"))



options(mc.cores=1)
dtm.review.unigram<- DocumentTermMatrix(VCorpus(VectorSource(review$text), readerControl=list(language=language)),
                          control=list(tokenize = NgramTokenizer, 
                                              wordLengths=c(3,Inf), 
                                              tolower=FALSE,
                                              stemming=TRUE,
                                              bounds=list(global=c(5,Inf)),
                                              stopwords=TRUE
                                              
))
options(mc.cores=detectCores())

rownames(dtm.review.unigram) <- review$review_id

save(dtm.review.unigram,file="results/language_models/review.unigram.RData")
