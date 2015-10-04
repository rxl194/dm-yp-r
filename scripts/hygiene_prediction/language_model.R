# Computes a unigram language model for a corpus of Yelp reviews. 

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


# Load the reviews

load('results/hygiene_prediction/data.RData')

# Select the review ids and their text

review <- data.frame(id=c(training$id,test$id),text=c(training$reviews_text,test$reviews_text),stringsAsFactors = FALSE)

# We will use unigrams and the language is english.

ngram <- 1

language <- "en"

# Preprocess the texts:
# 1- remove non-printable characters.
# 2- strip extra whitespaces
# 3- conver the text to lowercase
# 4- remove punctuation
# 5- remove numbers.

review <- review %>% 
  mutate(text=iconv(text,to="ASCII",sub="")) %>%
  mutate(text=stripWhitespace(text)) %>%
  mutate(text=tolower(text)) %>%
  mutate(text=removePunctuation(text)) %>%
  mutate(text=removeNumbers(text))


# Define a tonenizer to divide the texts in unigrams.

NgramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = ngram,delimiters = " \\r\\n\\t.,;:\"()?!"))



options(mc.cores=1) # Needed in MAC OSX or we get an error.

# Compute the document term matrix.

dtm.review.unigram<- DocumentTermMatrix(VCorpus(VectorSource(review$text), readerControl=list(language=language)),
                                        control=list(tokenize = NgramTokenizer, 
                                                     wordLengths=c(3,Inf), 
                                                     tolower=FALSE,
                                                     stemming=TRUE,
                                                     bounds=list(global=c(5,Inf)),
                                                     stopwords=TRUE
                                                     
                                        ))
options(mc.cores=detectCores()) # return to using as many cores as possible.

#To identify the reviews, use their id as row names.

rownames(dtm.review.unigram) <- review$id

# Save the results

save(dtm.review.unigram,file="results/hygiene_prediction/review.unigram.RData")
