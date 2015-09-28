if(!require(dplyr)){
  install.packages("dplyr",dependencies = TRUE)
}

require(dplyr)


if(!require(tm)){
  install.packages("tm",dependencies = TRUE)
}

require(tm)


if(!require(lsa)){
  install.packages("lsa",dependencies = TRUE)
}

require(lsa)

train_file <- 'results/dish_discovery/mexican/mex_w2v_train.txt'

output_file_bin <- 'results/dish_discovery/mexican/mex_w2v_model.bin'

output_file_text <- 'results/dish_discovery/mexican/mex_w2v_model.txt'

output_file_bigram <- 'results/dish_discovery/mexican/mex_w2v_bigram.txt'

output_file_trigram <- 'results/dish_discovery/mexican/mex_w2v_trigram.txt'


source('scripts/gpuFunctions.R')
source('scripts/dish_recognition/word2vec.R')

f <- file('results/dish_discovery/mexican/mexican_positive_useful_corpus.txt')

mexican <-data.frame(text=readLines(f),stringsAsFactors = FALSE)

close(f)

mexican <- mexican %>% 
  mutate(text=iconv(text,to="ASCII",sub="")) %>%
  mutate(text=stripWhitespace(text)) %>%
  mutate(text=tolower(text)) %>%
  mutate(text=removeNumbers(text)) %>%
  mutate(text=removePunctuation(text))


f <- file(train_file)
writeLines(mexican$text,f)
close(f)


system(paste0("tools/word2vec/word2phrase -train ",train_file," -output ",output_file_bigram," -min-count 5"))

system(paste0("tools/word2vec/word2phrase -train ",output_file_bigram," -output ",output_file_trigram," -min-count 5"))

system(paste0("tools/word2vec/word2vec -train ",output_file_trigram," -output ",output_file_bin," -binary 1 -min-count 5"))

system(paste0("tools/word2vec/word2vec -train ",output_file_trigram," -output ",output_file_text," -binary 0 -min-count 5"))

# Read the vectors

vectors <- read.table(output_file_text,skip = 1,stringsAsFactors = FALSE)

# Get the terms

words <- vectors[,1]

# Transform matrix to a vector

vectors <- as.matrix(vectors[,-1])


# Compute cosine similarity

# Remove stop words

words.no.stop <- words[!words %in% stopwords(kind="en")]

vectors.no.stop <- vectors[!words %in% stopwords(kind="en"),]

vectors.no.stop <- vectors.no.stop[!words.no.stop %in% stopwords(kind="es"),]


words.no.stop <- words.no.stop[!words.no.stop %in% stopwords(kind="es")]






cosine.similarity <- gpuCosine(vectors.no.stop)

rownames(cosine.similarity) <- words.no.stop
colnames(cosine.similarity) <- words.no.stop




# read training set 

labels <- read.table('results/manualAnnotationTask/Mexican.label',sep="\t",stringsAsFactors = FALSE,quote="\"") %>% filter(V2==1) %>% mutate(V1=gsub(" ","_",V1)) %>% filter(V1 %in% rownames(cosine.similarity))

labels <- labels$V1



max.depth <-4

# thresholds <- seq(1,0.7,-0.02)
# n.dishes <- unlist(lapply(thresholds,function(threshold){
#   length(extract.related.words(cosine.similarity,labels,threshold = threshold,max.depth = max.depth))
# }))
#   
# plot(thresholds,n.dishes)
dishes <- extract.related.words(cosine.similarity,labels,threshold = 0.74,max.depth = max.depth)


f <- file("results/dish_discovery/mexican/mexican_dishes.txt","w")

writeLines(c(gsub("_"," ",dishes)),f)

close(f)


